import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/app_header.dart';
import '../../data/models/auto_evaluation.dart';
import '../../data/models/reponse.dart';
import '../../data/repositories/evaluation_repository.dart';
import '../home/home_viewmodel.dart';
import '../historique/historique_viewmodel.dart';

class DetailEvaluationScreen extends StatefulWidget {
  const DetailEvaluationScreen({super.key});

  @override
  State<DetailEvaluationScreen> createState() => _DetailEvaluationScreenState();
}

class _DetailEvaluationScreenState extends State<DetailEvaluationScreen> {
  AutoEvaluation? _evaluation;
  List<Reponse>? _reponses;
  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialiserEtCharger();
    });
  }

  Future<void> _initialiserEtCharger() async {
    final evaluation =
        ModalRoute.of(context)?.settings.arguments as AutoEvaluation?;

    if (evaluation == null || evaluation.id == null) {
      if (mounted) {
        setState(() {
          _chargement = false;
          _erreur = 'Aucune évaluation';
        });
      }
      return;
    }

    _evaluation = evaluation;
    await _chargerReponses();
  }

  Future<void> _chargerReponses() async {
    if (!mounted) return;

    try {
      final repo = context.read<EvaluationRepository>();
      final eval = _evaluation;
      if (eval == null || eval.id == null) {
        setState(() {
          _chargement = false;
          _erreur = 'Aucune évaluation';
        });
        return;
      }
      debugPrint('Chargement des réponses pour évaluation ID: ${eval.id}');

      final reponses = await repo.getReponses(eval.id!);

      debugPrint('Réponses chargées: ${reponses.length}');

      if (mounted) {
        setState(() {
          _reponses = reponses;
          _chargement = false;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Erreur chargement réponses: $e');
      debugPrint('StackTrace: $stackTrace');
      if (mounted) {
        setState(() {
          _chargement = false;
          _erreur = 'Erreur: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final langue = context.watch<HomeViewModel>().langueActive;

    if (_chargement) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.roseVif),
        ),
      );
    }

    if (_erreur != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Détail')),
        body: Center(child: Text(_erreur!)),
      );
    }

    if (_evaluation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Détail')),
        body: const Center(child: Text('Aucune évaluation')),
      );
    }

    final evaluation = _evaluation!;

    final couleur = evaluation.niveauRisque == 'faible'
        ? AppColors.risqueFaible
        : evaluation.niveauRisque == 'modere'
            ? AppColors.risqueModere
            : AppColors.risqueEleve;

    final couleurFond = evaluation.niveauRisque == 'faible'
        ? AppColors.risqueFaibleFond
        : evaluation.niveauRisque == 'modere'
            ? AppColors.risqueModereFond
            : AppColors.risqueEleveFond;

    return Scaffold(
      body: Column(
        children: [
          const AppHeader(titre: 'Détail de l\'évaluation'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ── Carte résumé ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientPrincipal,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: couleurFond,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _icone(evaluation.niveauRisque),
                            size: 32,
                            color: couleur,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                HistoriqueViewModel.formaterDate(
                                  evaluation.dateEvaluation,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: couleurFond,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  HistoriqueViewModel.labelNiveau(
                                    evaluation.niveauRisque,
                                    langue,
                                  ),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: couleur,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Score : ${evaluation.scoreTotal} points'
                                '${evaluation.dureeSecondes != null ? '  •  ${(evaluation.dureeSecondes! / 60).ceil()} min' : ''}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Message d'orientation ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.roseClair),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Message d\'orientation',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.roseFonce,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          evaluation.messageOrientation,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.texteSecondaire,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Réponses ──
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'RÉPONSES DONNÉES',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.texteGris,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (_chargement)
                    const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.roseVif),
                    )
                  else if (_erreur != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.roseClair),
                      ),
                      child: Center(
                        child: Text(
                          _erreur!,
                          style: const TextStyle(color: AppColors.texteGris),
                        ),
                      ),
                    )
                  else if (_reponses == null || _reponses!.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.roseClair),
                      ),
                      child: const Center(
                        child: Text(
                          'Aucune réponse enregistrée',
                          style: TextStyle(color: AppColors.texteGris),
                        ),
                      ),
                    )
                  else
                    ..._reponses!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final reponse = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.roseClair),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: AppColors.rosePale,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.roseFonce,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Question ${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.roseVif,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        size: 14,
                                        color: AppColors.roseFonce,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          reponse.valeurReponse,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textePrincipal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: reponse.poidsObtenu > 0
                                    ? AppColors.risqueEleveFond
                                    : AppColors.risqueFaibleFond,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '+${reponse.poidsObtenu}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: reponse.poidsObtenu > 0
                                      ? AppColors.risqueEleve
                                      : AppColors.risqueFaible,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                  const SizedBox(height: 8),

                  // ── Avertissement ──
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.rosePale,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.roseClair),
                    ),
                    child: const Text(
                      '⚠️ Ce résultat n\'est pas un diagnostic médical. Consultez un professionnel de santé.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.texteSecondaire,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _icone(String niveau) {
    switch (niveau) {
      case 'faible':
        return Icons.check_circle_outline;
      case 'modere':
        return Icons.warning_amber_outlined;
      default:
        return Icons.error_outline;
    }
  }
}

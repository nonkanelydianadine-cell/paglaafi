import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/app_header.dart';
import '../home/home_viewmodel.dart';
import '../evaluation/evaluation_viewmodel.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen>
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _chargerSiBesoin();
  }

  void _chargerSiBesoin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<EvaluationViewModel>();
      if (vm.questions.isEmpty || vm.termine) {
        vm.charger();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final vm = context.watch<EvaluationViewModel>();
    final langue = context.watch<HomeViewModel>().langueActive;
    final question = vm.questionActive;

    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            titre: 'Mon évaluation',
            // ← Bouton retour qui revient à l'onglet Accueil
            onBack: () => context.read<HomeViewModel>().changerOnglet(0),
            onAudio: question != null
                ? () => context
                    .read<EvaluationViewModel>()
                    .ecouterQuestion(langue)
                : null,
          ),

          if (vm.chargement)
            const Expanded(child: Center(
              child: CircularProgressIndicator(color: AppColors.roseVif),
            ))
          else if (question == null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Aucune question disponible',
                      style: TextStyle(color: AppColors.texteGris),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _chargerSiBesoin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.roseFonce,
                      ),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Barre de progression
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: vm.progression,
                            backgroundColor: AppColors.roseClair,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.roseVif),
                            minHeight: 5,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Q ${vm.questionCourante + 1}/${vm.nombreQuestions}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.texteGris,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Carte question
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.roseClair),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${vm.questionCourante + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.roseVif,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            question.enonceParLangue(langue),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textePrincipal,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Options de réponse
                    Expanded(
                      child: ListView(
                        children: question.options.map((option) {
                          final texte = option.texteParLangue(langue);
                          final poids = option.poids;
                          final selectionne =
                              vm.reponseChoisie(question.id) == texte;

                          return GestureDetector(
                            onTap: () => context
                                .read<EvaluationViewModel>()
                                .repondre(
                                  questionId: question.id,
                                  texte: texte,
                                  poids: poids,
                                ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: selectionne
                                    ? AppColors.rosePale
                                    : Colors.white,
                                border: Border.all(
                                  color: selectionne
                                      ? AppColors.roseVif
                                      : AppColors.roseClair,
                                  width: selectionne ? 2 : 1.5,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selectionne
                                          ? AppColors.roseVif
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: selectionne
                                            ? AppColors.roseVif
                                            : AppColors.roseClair,
                                        width: 2,
                                      ),
                                    ),
                                    child: selectionne
                                        ? const Icon(Icons.check,
                                            color: Colors.white, size: 12)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      texte,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: selectionne
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: selectionne
                                            ? AppColors.roseFonce
                                            : AppColors.textePrincipal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Bouton suivant / valider
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: vm.aRepondu
                            ? () async {
                                if (vm.estDerniere) {
                                  final eval = await context
                                      .read<EvaluationViewModel>()
                                      .valider(langue);
                                  if (!context.mounted) return;
                                  if (eval != null) {
                                    Navigator.of(context).pushNamed(
                                      AppRoutes.resultat,
                                      arguments: eval,
                                    );
                                  }
                                } else {
                                  context
                                      .read<EvaluationViewModel>()
                                      .suivante();
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.roseFonce,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          vm.estDerniere
                              ? 'Voir mon résultat →'
                              : 'Question suivante →',
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
}
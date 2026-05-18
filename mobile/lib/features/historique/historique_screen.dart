import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/app_header.dart';
import '../home/home_viewmodel.dart';
import '../historique/historique_viewmodel.dart';

class HistoriqueScreen extends StatefulWidget {
  const HistoriqueScreen({super.key});

  @override
  State<HistoriqueScreen> createState() => _HistoriqueScreenState();
}

class _HistoriqueScreenState extends State<HistoriqueScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profil = context.read<HomeViewModel>().profil;
      if (profil != null) {
        context.read<HistoriqueViewModel>().charger(profil.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoriqueViewModel>();
    final langue = context.watch<HomeViewModel>().langueActive;

    return Scaffold(
      body: Column(
        children: [
          const AppHeader(titre: 'Mon historique'),
          Expanded(
            child: vm.chargement
                ? const Center(child: CircularProgressIndicator(
                    color: AppColors.roseVif))
                : vm.estVide
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.rosePale,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.history_outlined,
                                size: 40,
                                color: AppColors.roseFonce,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Aucune évaluation encore réalisée',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.texteGris,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Text(
                            '${vm.nombre} évaluation(s) enregistrée(s)',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.texteGris,
                            ),
                          ),
                          const SizedBox(height: 12),

                          ...vm.evaluations.map((eval) {
                            final couleur = eval.niveauRisque == 'faible'
                                ? AppColors.risqueFaible
                                : eval.niveauRisque == 'modere'
                                    ? AppColors.risqueModere
                                    : AppColors.risqueEleve;

                            final couleurFond = eval.niveauRisque == 'faible'
                                ? AppColors.risqueFaibleFond
                                : eval.niveauRisque == 'modere'
                                    ? AppColors.risqueModereFond
                                    : AppColors.risqueEleveFond;

                            return GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.detailEvaluation,
                                arguments: eval,
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: AppColors.roseClair),
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      // Accent gauche coloré
                                      Container(
                                        width: 4,
                                        decoration: BoxDecoration(
                                          color: couleur,
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                            left: Radius.circular(12),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      HistoriqueViewModel
                                                          .formaterDate(
                                                        eval.dateEvaluation,
                                                      ),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: AppColors
                                                            .textePrincipal,
                                                      ),
                                                    ),
                                                    Text(
                                                      '8 questions${eval.dureeSecondes != null ? ' · ${(eval.dureeSecondes! / 60).ceil()} min' : ''}',
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color: AppColors.texteGris,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Badge niveau
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: couleurFond,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  HistoriqueViewModel
                                                      .labelNiveau(
                                                    eval.niveauRisque,
                                                    langue,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: couleur,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 12,
                                                color: AppColors.texteGris,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),

                          const SizedBox(height: 8),
                          // Avertissement
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.rosePale,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.roseClair),
                            ),
                            child: Text(
                              HistoriqueViewModel.avertissement(langue),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.texteSecondaire,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}
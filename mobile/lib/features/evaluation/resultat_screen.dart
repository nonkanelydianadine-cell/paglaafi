import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/risk_calculator.dart';
import '../../core/widgets/app_header.dart';
import '../../data/models/auto_evaluation.dart';
import '../home/home_viewmodel.dart';
import '../evaluation/evaluation_viewmodel.dart';
import '../historique/historique_viewmodel.dart';

class ResultatScreen extends StatelessWidget {
  const ResultatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final evaluation =
        ModalRoute.of(context)?.settings.arguments as AutoEvaluation?;
    final langue = context.watch<HomeViewModel>().langueActive;

    if (evaluation == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Résultat')),
        body: const Center(child: Text('Aucun résultat')),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          const AppHeader(titre: 'Mon résultat'),

          // Hero résultat
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.gradientPrincipal,
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: _couleurFond(evaluation.niveauRisque),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _icone(evaluation.niveauRisque),
                      size: 48,
                      color: _couleurTexte(evaluation.niveauRisque),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: _couleurFond(evaluation.niveauRisque),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    HistoriqueViewModel.labelNiveau(
                        evaluation.niveauRisque, langue),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _couleurTexte(evaluation.niveauRisque),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  HistoriqueViewModel.formaterDate(evaluation.dateEvaluation),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Message d'orientation
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.roseClair),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 4,
                              color: AppColors.roseVif,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.analytics_outlined,
                                          size: 18,
                                          color: AppColors.roseFonce,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Vos résultats',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.roseFonce,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      evaluation.messageOrientation.isNotEmpty
                                          ? evaluation.messageOrientation
                                          : RiskCalculator.messageOrientation(
                                              niveau: evaluation.niveauRisque,
                                              langue: langue,
                                            ),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.texteSecondaire,
                                        height: 1.6,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Avertissement médical
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.rosePale,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.roseClair),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_outlined,
                          size: 20,
                          color: AppColors.roseVif,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Ce résultat n\'est pas un diagnostic médical.',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.roseFonce,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Boutons CTA
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.centres),
                      icon: const Icon(Icons.local_hospital_outlined,
                          color: Colors.white),
                      label: const Text('Voir les centres de santé'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.roseFonce,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.rappels),
                      icon: const Icon(Icons.notifications_outlined),
                      label: const Text('Activer les rappels'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.roseFonce,
                        side: const BorderSide(color: AppColors.roseFonce),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      context.read<EvaluationViewModel>().reinitialiser();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (r) => false,
                      );
                    },
                    child: const Text(
                      'Retour à l\'accueil',
                      style: TextStyle(color: AppColors.texteGris),
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

  Color _couleurFond(String niveau) {
    switch (niveau) {
      case 'faible':
        return AppColors.risqueFaibleFond;
      case 'modere':
        return AppColors.risqueModereFond;
      default:
        return AppColors.risqueEleveFond;
    }
  }

  Color _couleurTexte(String niveau) {
    switch (niveau) {
      case 'faible':
        return AppColors.risqueFaible;
      case 'modere':
        return AppColors.risqueModere;
      default:
        return AppColors.risqueEleve;
    }
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

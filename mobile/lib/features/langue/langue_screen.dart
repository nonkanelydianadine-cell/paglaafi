import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/app_header.dart';
import '../home/home_viewmodel.dart';
import '../langue/langue_viewmodel.dart';

class LangueScreen extends StatelessWidget {
  const LangueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LangueViewModel>();
    final langues = ['fr', 'moore', 'dioula', 'fulfude'];

    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            titre: 'Langue',
            onBack: () => context.read<HomeViewModel>().changerOnglet(0),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Choisissez votre langue',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textePrincipal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Appuyez sur ▶ pour écouter le nom de la langue',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.texteSecondaire,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Liste des langues
                  Expanded(
                    child: ListView.separated(
                      itemCount: langues.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final langue = langues[i];
                        final labels = LangueViewModel.labelsLangues[langue]!;
                        final selectionnee = vm.langueSelectionnee == langue;

                        return GestureDetector(
                          onTap: () => context
                              .read<LangueViewModel>()
                              .selectionnerLangue(langue),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: selectionnee
                                  ? AppColors.rosePale
                                  : Colors.white,
                              border: Border.all(
                                color: selectionnee
                                    ? AppColors.roseFonce
                                    : AppColors.roseClair,
                                width: selectionnee ? 2 : 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        labels['nom']!,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: selectionnee
                                              ? AppColors.roseFonce
                                              : AppColors.textePrincipal,
                                        ),
                                      ),
                                      Text(
                                        labels['nomLocal']!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.texteSecondaire,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => context
                                      .read<LangueViewModel>()
                                      .ecouterLangue(langue),
                                  icon: const Icon(Icons.play_arrow, size: 16),
                                  label: const Text('Écouter'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.roseVif,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    minimumSize: Size.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Bouton continuer
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: vm.chargement
                          ? null
                          : () async {
                              final langue = vm.langueSelectionnee;
                              await context
                                  .read<LangueViewModel>()
                                  .confirmerLangue();
                              if (!context.mounted) return;
                              // Mettre à jour HomeViewModel pour que toutes
                              // les pages reflètent immédiatement la nouvelle langue
                              await context
                                  .read<HomeViewModel>()
                                  .changerLangue(langue);
                              if (!context.mounted) return;
                              context.read<HomeViewModel>().changerOnglet(0);
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.roseFonce,
                        side: const BorderSide(color: AppColors.roseFonce),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: vm.chargement
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Continuer →',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
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

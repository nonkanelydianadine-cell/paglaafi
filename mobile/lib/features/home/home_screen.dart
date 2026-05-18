import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../home/home_viewmodel.dart';
import '../evaluation/evaluation_screen.dart';
import '../rappels/rappels_screen.dart';
import '../langue/langue_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().charger();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      // IndexedStack garde tous les écrans en mémoire
      // et affiche seulement celui de l'index actif
      body: IndexedStack(
        index: vm.indexNavigation,
        children: const [
          _AccueilTab(),     // index 0
          EvaluationScreen(), // index 1
          RappelsScreen(),    // index 2
          LangueScreen(),     // index 3
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: vm.indexNavigation,
        selectedItemColor: AppColors.roseFonce,
        unselectedItemColor: AppColors.texteGris,
        backgroundColor: Colors.white,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        onTap: (i) => context.read<HomeViewModel>().changerOnglet(i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Évaluation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications_rounded),
            label: 'Rappels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language_outlined),
            activeIcon: Icon(Icons.language),
            label: 'Langue',
          ),
        ],
      ),
    );
  }
}

// ── Onglet Accueil (contenu de la page principale) ──
class _AccueilTab extends StatelessWidget {
  const _AccueilTab();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      body: Column(
        children: [
          // ── Header rose ──
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.gradientPrincipal,
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.white, size: 28),
                    const SizedBox(width: 10),
                    const Text(
                      'Pag Laafi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Bannière bienvenue ──
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.roseClair),
                    ),
                    child: Row(
                      children: [
                        const Text('🌸', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vm.messageAccueil,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.roseFonce,
                                ),
                              ),
                              Text(
                                vm.sousMessage,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.texteSecondaire,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Label MODULES ──
                  const Text(
                    'MODULES',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.texteGris,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Grille 2x2 ──
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      _ModuleCard(
                        icone: Icons.info_outline,
                        titre: 'Informations',
                        sousTitre: 'Cancer du sein',
                        accent: true,
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.informations),
                      ),
                      _ModuleCard(
                        icone: Icons.pan_tool_alt_outlined,
                        titre: 'Auto-examen',
                        sousTitre: 'Guide étape par étape',
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.autoExamen),
                      ),
                      _ModuleCard(
                        icone: Icons.assignment_outlined,
                        titre: 'Évaluation',
                        sousTitre: 'Mon niveau de risque',
                        onTap: () => context
                            .read<HomeViewModel>()
                            .changerOnglet(1),
                      ),
                      _ModuleCard(
                        icone: Icons.local_hospital_outlined,
                        titre: 'Centres',
                        sousTitre: 'Trouver un centre',
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.centres),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Items liste ──
                  _ModuleItem(
                    icone: Icons.notifications_outlined,
                    titre: 'Rappels de prévention',
                    sousTitre: 'Configurer mes rappels',
                    onTap: () => context
                        .read<HomeViewModel>()
                        .changerOnglet(2),
                  ),
                  const SizedBox(height: 10),
                  _ModuleItem(
                    icone: Icons.history,
                    titre: 'Mon historique',
                    sousTitre: 'Mes évaluations passées',
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.historique),
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

// ── Widget carte module ──
class _ModuleCard extends StatelessWidget {
  final IconData icone;
  final String titre;
  final String sousTitre;
  final bool accent;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.icone,
    required this.titre,
    required this.sousTitre,
    this.accent = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: accent ? AppColors.gradientPrincipal : null,
          color: accent ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: accent
              ? null
              : Border.all(color: AppColors.roseClair, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.roseVif.withOpacity(0.10),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: accent
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.rosePale,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icone,
                size: 28,
                color: accent ? Colors.white : AppColors.roseFonce,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              titre,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: accent ? Colors.white : AppColors.roseFonce,
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                sousTitre,
                style: TextStyle(
                  fontSize: 10,
                  color: accent
                      ? Colors.white70
                      : AppColors.texteSecondaire,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widget item liste ──
class _ModuleItem extends StatelessWidget {
  final IconData icone;
  final String titre;
  final String sousTitre;
  final VoidCallback onTap;

  const _ModuleItem({
    required this.icone,
    required this.titre,
    required this.sousTitre,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.roseClair, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.roseVif.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.rosePale,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icone,
                size: 22,
                color: AppColors.roseFonce,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titre,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textePrincipal,
                    ),
                  ),
                  Text(
                    sousTitre,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.texteSecondaire,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.texteGris,
            ),
          ],
        ),
      ),
    );
  }
}
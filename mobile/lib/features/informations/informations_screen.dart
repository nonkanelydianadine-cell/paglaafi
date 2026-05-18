import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/placeholder_image.dart';
import '../home/home_viewmodel.dart';
import '../informations/informations_viewmodel.dart';
//import '../../core/widgets/app_header.dart';

class InformationsScreen extends StatefulWidget {
  const InformationsScreen({super.key});

  @override
  State<InformationsScreen> createState() => _InformationsScreenState();
}

class _InformationsScreenState extends State<InformationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'cancer',
    'signes',
    'prevention',
    'risques'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);

    // Quand on change d'onglet, charger les nouveaux contenus
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final langue = context.read<HomeViewModel>().langueActive;
      context.read<InformationsViewModel>().changerCategorie(
            _categories[_tabController.index],
            langue,
          );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final langue = context.read<HomeViewModel>().langueActive;
      context.read<InformationsViewModel>().charger(langue);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InformationsViewModel>();
    final langue = context.watch<HomeViewModel>().langueActive;

    return Scaffold(
      body: Column(
        children: [
          // Header
          AppHeader(
            titre: 'Informations',
            onAudio: () {
              if (vm.contenus.isNotEmpty) {
                vm.ecouterContenu(vm.contenus.first, langue);
              }
            },
          ),

          // Onglets
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.roseFonce,
              unselectedLabelColor: AppColors.texteGris,
              indicatorColor: AppColors.roseVif,
              indicatorWeight: 2.5,
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              tabs: _categories
                  .map((cat) => Tab(
                        text: InformationsViewModel.labelCategorie(cat, langue),
                      ))
                  .toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.roseClair),

          // Contenu
          Expanded(
            child: vm.chargement
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.roseVif))
                : vm.estVide
                    ? const Center(
                        child: Text(
                        'Aucun contenu disponible',
                        style: TextStyle(color: AppColors.texteGris),
                      ))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: vm.contenus.length,
                        itemBuilder: (context, i) {
                          final contenu = vm.contenus[i];
                          return _FicheInfoCard(
                            titre: contenu.titreParLangue(langue),
                            texte: contenu.texteParLangue(langue),
                            illustrationPath: contenu.illustrationPath,
                            onAudio: () => vm.ecouterContenu(contenu, langue),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _FicheInfoCard extends StatelessWidget {
  final String titre;
  final String texte;
  final String? illustrationPath;
  final VoidCallback onAudio;

  const _FicheInfoCard({
    required this.titre,
    required this.texte,
    this.illustrationPath,
    required this.onAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.roseClair),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Illustration remplacée
          Container(
            width: double.infinity,
            height: 80,
            decoration: const BoxDecoration(
              gradient: AppColors.gradientPrincipal,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.favorite_outline,
                size: 36,
                color: Colors.white,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        titre,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.roseFonce,
                        ),
                      ),
                    ),
                    // Bouton audio
                    GestureDetector(
                      onTap: onAudio,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.roseVif,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Bordure gauche rose
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        decoration: BoxDecoration(
                          color: AppColors.roseVif,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          texte,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.texteSecondaire,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
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
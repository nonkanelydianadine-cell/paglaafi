import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_header.dart';
import '../home/home_viewmodel.dart';
import '../rappels/rappels_viewmodel.dart';
import '../../data/models/rappel.dart';

class RappelsScreen extends StatefulWidget {
  const RappelsScreen({super.key});

  @override
  State<RappelsScreen> createState() => _RappelsScreenState();
}

class _RappelsScreenState extends State<RappelsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RappelsViewModel>().charger();
    });
  }

  // Sélecteur d'heure
  Future<void> _choisirHeure(
    BuildContext context,
    Rappel rappel,
  ) async {
    final parts = rappel.heureEnvoi.split(':');
    final initial = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 9,
      minute: int.tryParse(parts[1]) ?? 0,
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.roseFonce,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textePrincipal,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      final heure = '${picked.hour.toString().padLeft(2, '0')}:'
          '${picked.minute.toString().padLeft(2, '0')}';
      context.read<RappelsViewModel>().changerHeureRappel(rappel.id!, heure);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final vm = context.watch<RappelsViewModel>();
    final langue = context.watch<HomeViewModel>().langueActive;

    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            titre: 'Mes rappels',
            onBack: () => context.read<HomeViewModel>().changerOnglet(0),
          ),
          Expanded(
            child: vm.chargement
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.roseVif),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Bannière info ──
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.rosePale,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.roseClair),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                size: 22,
                                color: AppColors.roseVif,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Les rappels fonctionnent '
                                  'sans connexion internet.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.texteSecondaire,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Label ──
                        const Text(
                          'RAPPELS CONFIGURÉS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.texteGris,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // ── Liste des rappels ──
                        ...vm.rappels.map((rappel) => _CarteRappel(
                              rappel: rappel,
                              langue: langue,
                              onToggle: () => context
                                  .read<RappelsViewModel>()
                                  .toggleRappel(rappel),
                              onChoisirHeure: () =>
                                  _choisirHeure(context, rappel),
                              onChangerFrequence: (freq) => context
                                  .read<RappelsViewModel>()
                                  .changerFrequenceRappel(rappel.id!, freq),
                            )),

                        const SizedBox(height: 20),

                        // ── Bouton enregistrer ──
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: vm.enregistrement
                                ? null
                                : () async {
                                    await context
                                        .read<RappelsViewModel>()
                                        .enregistrer();
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Rappels enregistrés !',
                                        ),
                                        backgroundColor: AppColors.roseFonce,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                            icon: vm.enregistrement
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.save_outlined),
                            label: Text(
                              vm.enregistrement
                                  ? 'Enregistrement...'
                                  : 'Enregistrer les rappels',
                            ),
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
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Widget carte rappel ──
class _CarteRappel extends StatelessWidget {
  final Rappel rappel;
  final String langue;
  final VoidCallback onToggle;
  final VoidCallback onChoisirHeure;
  final ValueChanged<String> onChangerFrequence;

  const _CarteRappel({
    required this.rappel,
    required this.langue,
    required this.onToggle,
    required this.onChoisirHeure,
    required this.onChangerFrequence,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: rappel.actif ? AppColors.roseClair : const Color(0xFFEEEEEE),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.roseVif.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── En-tête : icône + titre + toggle ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: rappel.actif
                        ? AppColors.rosePale
                        : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_active_outlined,
                    size: 24,
                    color: rappel.actif
                        ? AppColors.roseFonce
                        : AppColors.texteGris,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        RappelsViewModel.labelType(rappel.typeRappel, langue),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: rappel.actif
                              ? AppColors.textePrincipal
                              : AppColors.texteGris,
                        ),
                      ),
                      Text(
                        rappel.actif ? 'Activé' : 'Désactivé',
                        style: TextStyle(
                          fontSize: 11,
                          color: rappel.actif
                              ? AppColors.roseVif
                              : AppColors.texteGris,
                        ),
                      ),
                    ],
                  ),
                ),
                // Toggle
                GestureDetector(
                  onTap: onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 46,
                    height: 26,
                    decoration: BoxDecoration(
                      color: rappel.actif
                          ? AppColors.roseVif
                          : const Color(0xFFDDDDDD),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      alignment: rappel.actif
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Détails : fréquence + heure (TOUJOURS VISIBLES) ──
          const Divider(height: 1, color: AppColors.roseClair),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label fréquence
                const Text(
                  'FRÉQUENCE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.texteGris,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),

                // Pills de fréquence
                Wrap(
                  spacing: 8,
                  runSpacing: 0,
                  children: [
                    'quotidien',
                    'hebdo',
                    'mensuel',
                  ].map((freq) {
                    final actif = rappel.frequence == freq;
                    return GestureDetector(
                      onTap: () => onChangerFrequence(freq),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color:
                              actif ? AppColors.roseFonce : AppColors.rosePale,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: actif
                                ? AppColors.roseFonce
                                : AppColors.roseClair,
                          ),
                        ),
                        child: Text(
                          RappelsViewModel.labelFrequence(freq, langue),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                actif ? FontWeight.bold : FontWeight.normal,
                            color: actif ? Colors.white : AppColors.roseFonce,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),

                // Heure du rappel
                const Text(
                  'HEURE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.texteGris,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onChoisirHeure,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.rosePale,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.roseClair),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 18,
                          color: AppColors.roseFonce,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          rappel.heureEnvoi,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.roseFonce,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: AppColors.texteGris,
                        ),
                      ],
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

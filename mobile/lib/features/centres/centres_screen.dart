import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_header.dart';
import '../../data/models/centre_sante.dart';
import '../home/home_viewmodel.dart';
import '../centres/centres_viewmodel.dart';

class CentresScreen extends StatefulWidget {
  const CentresScreen({super.key});

  @override
  State<CentresScreen> createState() => _CentresScreenState();
}

class _CentresScreenState extends State<CentresScreen> {
  final _searchController = TextEditingController();
  bool _hasSearchText = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CentresViewModel>().charger();
      }
    });
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {
        _hasSearchText = _searchController.text.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _ouvrirGoogleMaps(CentreSante centre) async {
    late final Uri url;

    if (centre.aCoordonnees) {
      final coords = '${centre.latitude},${centre.longitude}';
      url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$coords',
      );
    } else {
      final recherche = Uri.encodeComponent(
          '${centre.nom} ${centre.adresse} ${centre.ville} Burkina Faso');
      url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$recherche');
    }

    try {
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        _showSnackBar('Impossible d\'ouvrir Google Maps');
      }
    } catch (e) {
      if (mounted) _showSnackBar('Erreur lors de l\'ouverture de Maps');
    }
  }

  Future<void> _ouvrirItineraire(CentreSante centre) async {
    late final Uri url;

    if (centre.aCoordonnees) {
      final coords = '${centre.latitude},${centre.longitude}';
      url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$coords&travelmode=driving',
      );
    } else {
      final dest = Uri.encodeComponent(
          '${centre.nom} ${centre.adresse} ${centre.ville} Burkina Faso');
      url = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$dest&travelmode=driving');
    }

    try {
      final launched =
          await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        _showSnackBar('Impossible d\'ouvrir l\'itinéraire');
      }
    } catch (e) {
      if (mounted) _showSnackBar('Impossible d\'ouvrir l\'itinéraire');
    }
  }

  Future<void> _appeler(String telephone) async {
    final url = Uri.parse('tel:$telephone');
    try {
      final launched =
          await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched && mounted) {
        _showSnackBar('Impossible de lancer l\'appel');
      }
    } catch (e) {
      if (mounted) _showSnackBar('Erreur lors de l\'appel');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.roseFonce,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CentresViewModel>();
    // Supprimé : final langue = context.watch<HomeViewModel>().langueActive;
    // (non utilisé - causait un rebuild inutile)

    return Scaffold(
      body: Column(
        children: [
          const AppHeader(titre: 'Centres de santé'),

          // Bannière info
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.rosePale,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.roseClair),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: AppColors.roseVif),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Utilisez les boutons pour ouvrir Maps, lancer l’itinéraire ou appeler directement le centre.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.texteSecondaire,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Recherche
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => context.read<CentresViewModel>().rechercher(v),
              decoration: InputDecoration(
                hintText: 'Rechercher un centre...',
                hintStyle: const TextStyle(
                  color: AppColors.texteGris,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.roseVif,
                  size: 20,
                ),
                suffixIcon: _hasSearchText
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          context.read<CentresViewModel>().rechercher('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.roseClair),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: AppColors.roseClair),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                    color: AppColors.roseVif,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // Filtres villes
          if (vm.villes.isNotEmpty)
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                itemCount: vm.villes.length,
                itemBuilder: (context, i) {
                  final ville = vm.villes[i];
                  final actif = vm.villeActive == ville;
                  return GestureDetector(
                    onTap: () =>
                        context.read<CentresViewModel>().filtrerVille(ville),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: actif ? AppColors.roseVif : AppColors.rosePale,
                        border: Border.all(
                          color:
                              actif ? AppColors.roseVif : AppColors.roseClair,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        ville,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: actif ? Colors.white : AppColors.roseFonce,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Compteur
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                const Icon(
                  Icons.local_hospital,
                  size: 14,
                  color: AppColors.roseFonce,
                ),
                const SizedBox(width: 6),
                Text(
                  '${vm.centres.length} centre(s)',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.roseFonce,
                  ),
                ),
              ],
            ),
          ),

          // Liste
          Expanded(
            child: vm.chargement
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.roseVif),
                  )
                : vm.estVide
                    ? const Center(
                        child: Text(
                          'Aucun centre trouvé',
                          style: TextStyle(color: AppColors.texteGris),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: vm.centres.length,
                        itemBuilder: (context, i) {
                          final centre = vm.centres[i];
                          return _CarteCentre(
                            centre: centre,
                            onVoirCarte: () => _ouvrirGoogleMaps(centre),
                            onItineraire: () => _ouvrirItineraire(centre),
                            onAppeler: centre.telephone != null
                                ? () => _appeler(centre.telephone!)
                                : null,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _CarteCentre extends StatelessWidget {
  final CentreSante centre;
  final VoidCallback onVoirCarte;
  final VoidCallback onItineraire;
  final VoidCallback? onAppeler;

  const _CarteCentre({
    required this.centre,
    required this.onVoirCarte,
    required this.onItineraire,
    this.onAppeler,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.roseClair),
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
          // En-tête
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.rosePale,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_hospital,
                    size: 24,
                    color: AppColors.roseFonce,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        centre.nom,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textePrincipal,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 11,
                            color: AppColors.roseVif,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              '${centre.adresse} — ${centre.ville}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.texteSecondaire,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (centre.distanceKm != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.rosePale,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${centre.distanceKm!.toStringAsFixed(1)} km',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.roseFonce,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Infos supplémentaires
          if (centre.telephone != null || centre.horaires != null)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.fondGris, // ✅ Maintenant défini !
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  if (centre.telephone != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 13,
                          color: AppColors.roseVif,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          centre.telephone!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.roseVif,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  if (centre.telephone != null && centre.horaires != null)
                    const SizedBox(height: 6),
                  if (centre.horaires != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 13,
                          color: AppColors.texteGris,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          centre.horaires!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.texteSecondaire,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Boutons d'action
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onVoirCarte,
                    icon: const Icon(Icons.map_outlined, size: 16),
                    label: const Text(
                      'Voir sur Maps',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.roseFonce,
                      side: const BorderSide(color: AppColors.roseFonce),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onItineraire,
                    icon: const Icon(Icons.directions, size: 16),
                    label: const Text(
                      'Itinéraire',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.roseFonce,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                if (onAppeler != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.rosePale,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.roseClair),
                    ),
                    child: IconButton(
                      onPressed: onAppeler,
                      icon: const Icon(
                        Icons.phone,
                        size: 18,
                        color: AppColors.roseFonce,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import '../../core/constants/db_constants.dart';

class CentreSante {
  final int id;
  final String nom;
  final String adresse;
  final String ville;
  final String? telephone;
  final String? horaires;
  final double? latitude;
  final double? longitude;
  final double? distanceKm;
  final bool actif;
  final String? audioFr;
  final String? audioMoore;

  const CentreSante({
    required this.id,
    required this.nom,
    required this.adresse,
    required this.ville,
    this.telephone,
    this.horaires,
    this.latitude,
    this.longitude,
    this.distanceKm,
    this.actif = true,
    this.audioFr,
    this.audioMoore,
  });

  /// Vérifie si le centre a des coordonnées GPS valides
  bool get aCoordonnees => latitude != null && longitude != null;

  String? audioParLangue(String langue) {
    if (langue == DbConstants.langMoore) return audioMoore ?? audioFr;
    return audioFr;
  }

  factory CentreSante.fromMap(Map<String, dynamic> m) => CentreSante(
        id: m['id'] as int,
        nom: m['nom'] as String,
        adresse: m['adresse'] as String,
        ville: m['ville'] as String? ?? 'Ouagadougou',
        telephone: m['telephone'] as String?,
        horaires: m['horaires'] as String?,
        latitude: (m['latitude'] as num?)?.toDouble(),
        longitude: (m['longitude'] as num?)?.toDouble(),
        distanceKm: (m['distance_km'] as num?)?.toDouble(),
        actif: (m['actif'] as int? ?? 1) == 1,
        audioFr: m['audio_fr'] as String?,
        audioMoore: m['audio_moore'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nom': nom,
        'adresse': adresse,
        'ville': ville,
        'telephone': telephone,
        'horaires': horaires,
        'latitude': latitude,
        'longitude': longitude,
        'distance_km': distanceKm,
        'actif': actif ? 1 : 0,
        'audio_fr': audioFr,
        'audio_moore': audioMoore,
      };
}

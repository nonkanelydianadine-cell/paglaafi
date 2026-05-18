import '../../core/constants/db_constants.dart';

class EtapeAutoExamen {
  final int id;
  final int numeroEtape;
  final String titreFr;
  final String? titreMoore;
  final String? titreDioula;
  final String? titreFulfude;
  final String descriptionFr;
  final String? descriptionMoore;
  final String? descriptionDioula;
  final String? descriptionFulfude;
  final String? illustrationPath;
  final String? audioFr;
  final String? audioMoore;
  final String? audioDioula;
  final String? audioFulfude;

  const EtapeAutoExamen({
    required this.id,
    required this.numeroEtape,
    required this.titreFr,
    this.titreMoore,
    this.titreDioula,
    this.titreFulfude,
    required this.descriptionFr,
    this.descriptionMoore,
    this.descriptionDioula,
    this.descriptionFulfude,
    this.illustrationPath,
    this.audioFr,
    this.audioMoore,
    this.audioDioula,
    this.audioFulfude,
  });

  String titreParLangue(String l) {
    switch (l) {
      case DbConstants.langMoore:
        return titreMoore ?? titreFr;
      case DbConstants.langDioula:
        return titreDioula ?? titreFr;
      case DbConstants.langFulfude:
        return titreFulfude ?? titreFr;
      default:
        return titreFr;
    }
  }

  String descriptionParLangue(String l) {
    switch (l) {
      case DbConstants.langMoore:
        return descriptionMoore ?? descriptionFr;
      case DbConstants.langDioula:
        return descriptionDioula ?? descriptionFr;
      case DbConstants.langFulfude:
        return descriptionFulfude ?? descriptionFr;
      default:
        return descriptionFr;
    }
  }

  String? audioParLangue(String l) {
    switch (l) {
      case DbConstants.langMoore:
        return audioMoore ?? audioFr;
      case DbConstants.langDioula:
        return audioDioula ?? audioFr;
      case DbConstants.langFulfude:
        return audioFulfude ?? audioFr;
      default:
        return audioFr;
    }
  }

  factory EtapeAutoExamen.fromMap(Map<String, dynamic> m) => EtapeAutoExamen(
        id: m['id'],
        numeroEtape: m['numero_etape'],
        titreFr: m['titre_fr'],
        titreMoore: m['titre_moore'],
        titreDioula: m['titre_dioula'],
        titreFulfude: m['titre_fulfude'],
        descriptionFr: m['description_fr'],
        descriptionMoore: m['description_moore'],
        descriptionDioula: m['description_dioula'],
        descriptionFulfude: m['description_fulfude'],
        illustrationPath: m['illustration_path'],
        audioFr: m['audio_fr'],
        audioMoore: m['audio_moore'],
        audioDioula: m['audio_dioula'],
        audioFulfude: m['audio_fulfude'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'numero_etape': numeroEtape,
        'titre_fr': titreFr,
        'description_fr': descriptionFr,
      };
}

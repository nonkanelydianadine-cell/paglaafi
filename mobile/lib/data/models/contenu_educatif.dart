import '../../core/constants/db_constants.dart';

class ContenuEducatif {
  final int id;
  final int ordre;
  final String categorie;
  final String titreFr;
  final String? titreMoore;
  final String? titreDioula;
  final String? titreFulfude;
  final String texteFr;
  final String? texteMoore;
  final String? texteDioula;
  final String? texteFulfude;
  final String? illustrationPath;
  final String? audioFr;
  final String? audioMoore;
  final String? audioDioula;
  final String? audioFulfude;

  const ContenuEducatif({
    required this.id,
    required this.ordre,
    required this.categorie,
    required this.titreFr,
    this.titreMoore,
    this.titreDioula,
    this.titreFulfude,
    required this.texteFr,
    this.texteMoore,
    this.texteDioula,
    this.texteFulfude,
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

  String texteParLangue(String l) {
    switch (l) {
      case DbConstants.langMoore:
        return texteMoore ?? texteFr;
      case DbConstants.langDioula:
        return texteDioula ?? texteFr;
      case DbConstants.langFulfude:
        return texteFulfude ?? texteFr;
      default:
        return texteFr;
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

  factory ContenuEducatif.fromMap(Map<String, dynamic> m) => ContenuEducatif(
        id: m['id'],
        ordre: m['ordre'],
        categorie: m['categorie'],
        titreFr: m['titre_fr'],
        titreMoore: m['titre_moore'],
        titreDioula: m['titre_dioula'],
        titreFulfude: m['titre_fulfude'],
        texteFr: m['texte_fr'],
        texteMoore: m['texte_moore'],
        texteDioula: m['texte_dioula'],
        texteFulfude: m['texte_fulfude'],
        illustrationPath: m['illustration_path'],
        audioFr: m['audio_fr'],
        audioMoore: m['audio_moore'],
        audioDioula: m['audio_dioula'],
        audioFulfude: m['audio_fulfude'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'ordre': ordre,
        'categorie': categorie,
        'titre_fr': titreFr,
        'texte_fr': texteFr,
      };
}

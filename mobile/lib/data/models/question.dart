import 'dart:convert';
import '../../core/constants/db_constants.dart';

class OptionQuestion {
  final String texteFr;
  final String? texteMoore;
  final String? texteDioula;
  final String? texteFulfude;
  final int poids;

  const OptionQuestion({
    required this.texteFr,
    this.texteMoore,
    this.texteDioula,
    this.texteFulfude,
    required this.poids,
  });

  String texteParLangue(String langue) {
    switch (langue) {
      case 'moore': return texteMoore ?? texteFr;
      case 'dioula': return texteDioula ?? texteFr;
      case 'fulfude': return texteFulfude ?? texteFr;
      default: return texteFr;
    }
  }

  Map<String, dynamic> toMap() => {
    'texte_fr': texteFr,
    'texte_moore': texteMoore,
    'texte_dioula': texteDioula,
    'texte_fulfude': texteFulfude,
    'poids': poids,
  };

  factory OptionQuestion.fromMap(Map<String, dynamic> m) => OptionQuestion(
    texteFr: m['texte_fr'] ?? m['texte'] ?? '',
    texteMoore: m['texte_moore'],
    texteDioula: m['texte_dioula'],
    texteFulfude: m['texte_fulfude'],
    poids: m['poids'] ?? 0,
  );
}

class Question {
  final int id;
  final int ordre;
  final int poidsMax;
  final String typeReponse;
  final String enonceFr;
  final String? enonceMoore;
  final String? enonceDioula;
  final String? enonceFulfude;
  final String? audioFr;
  final String? audioMoore;
  final String? audioDioula;
  final String? audioFulfude;
  final List<OptionQuestion> options;

  const Question({
    required this.id,
    required this.ordre,
    required this.poidsMax,
    required this.typeReponse,
    required this.enonceFr,
    this.enonceMoore,
    this.enonceDioula,
    this.enonceFulfude,
    this.audioFr,
    this.audioMoore,
    this.audioDioula,
    this.audioFulfude,
    this.options = const [],
  });

  String enonceParLangue(String langue) {
    switch (langue) {
      case 'moore': return enonceMoore ?? enonceFr;
      case 'dioula': return enonceDioula ?? enonceFr;
      case 'fulfude': return enonceFulfude ?? enonceFr;
      default: return enonceFr;
    }
  }

  factory Question.fromMap(Map<String, dynamic> m) {
    List<OptionQuestion> options = [];
    if (m['options'] != null) {
      final raw = m['options'];
      if (raw is String && raw.isNotEmpty) {
        try {
          final list = jsonDecode(raw) as List;
          options = list
              .map((o) => OptionQuestion.fromMap(Map<String, dynamic>.from(o)))
              .toList();
        } catch (_) {}
      } else if (raw is List) {
        options = raw
            .map((o) => OptionQuestion.fromMap(Map<String, dynamic>.from(o)))
            .toList();
      }
    }

    return Question(
      id: m['id'] ?? 0,
      ordre: m['ordre'] ?? 0,
      poidsMax: m['poids_max'] ?? 3,
      typeReponse: m['type_reponse'] ?? 'choix_multiple',
      enonceFr: m['enonce_fr'] ?? '',
      enonceMoore: m['enonce_moore'],
      enonceDioula: m['enonce_dioula'],
      enonceFulfude: m['enonce_fulfude'],
      audioFr: m['audio_fr'],
      audioMoore: m['audio_moore'],
      audioDioula: m['audio_dioula'],
      audioFulfude: m['audio_fulfude'],
      options: options,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'ordre': ordre,
    'poids_max': poidsMax,
    'type_reponse': typeReponse,
    'enonce_fr': enonceFr,
    'enonce_moore': enonceMoore,
    'enonce_dioula': enonceDioula,
    'enonce_fulfude': enonceFulfude,
    'audio_fr': audioFr,
    'audio_moore': audioMoore,
    'audio_dioula': audioDioula,
    'audio_fulfude': audioFulfude,
    'options': jsonEncode(options.map((o) => o.toMap()).toList()),
  };
}
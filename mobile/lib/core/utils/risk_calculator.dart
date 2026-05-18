import '../constants/db_constants.dart';

class RiskCalculator {
  RiskCalculator._();

  // Seuils de risque
  static const double seuilFaible = 0.33;   // 33% = faible
  static const double seuilModere = 0.66;   // 66% = modéré, au-delà = élevé

  static String calculerNiveau({
    required int scoreTotal,
    required int scoreMax,
  }) {
    if (scoreMax == 0) return DbConstants.risqueFaible;
    final ratio = scoreTotal / scoreMax;
    if (ratio < seuilFaible) return DbConstants.risqueFaible;
    if (ratio < seuilModere) return DbConstants.risqueModere;
    return DbConstants.risqueEleve;
  }

  static String messageOrientation({
    required String niveau,
    required String langue,
  }) {
    final map = _messages[niveau] ?? _messages[DbConstants.risqueFaible]!;
    return map[langue] ?? map[DbConstants.langFr]!;
  }

  static const Map<String, Map<String, String>> _messages = {
    'faible': {
      'fr':
          'Vos réponses ne montrent pas de facteur de risque particulier. Continuez à pratiquer l\'auto-examen chaque mois.',
      'moore': 'F leokr ka tara bũmb sẽn gũbgd. Gũus f mens fãa.',
      'dioula': 'I jaabi ma a fɔ ko sɔrɔw tɛ. I ka i yɛrɛ lajɛ kɔ kɔ kelen.',
      'fulfude':
          'Jaɓɓooji maa hollaay ko addana maa e dow. Taƴtu hoore maa kala lewru.',
    },
    'modere': {
      'fr':
          'Vos réponses indiquent quelques facteurs à surveiller. Consultez un professionnel de santé dans les 3 mois.',
      'moore':
          'F leokr tara bũmba nins sẽn be tɩ d gũud. Kẽng-y laafi rogem dãmb sẽn da tõog tɩ yʋʋm a tãab.',
      'dioula':
          'I jaabi b\'a fɔ ko dɔ de sé k\'a filɛ. Taa lafiɲɛ mɔgɔ dɔ wele saan 3 kɔnɔ.',
      'fulfude':
          'Jaɓɓooji maa hollitiima ko addana maa e hakkunde. Yah e dow boo e lewru 3.',
    },
    'eleve': {
      'fr':
          'Vos réponses indiquent plusieurs facteurs de risque importants. Consultez un professionnel de santé le plus tôt possible.',
      'moore':
          'F leokr tara bũmb wʋsg sẽn gũbgd. Kẽng-y laafi rogem dãmb ziiri-ziiri.',
      'dioula':
          'I jaabi b\'a fɔ ko sɔrɔw caman bɛ. Taa lafiɲɛ mɔgɔ dɔ wele joona.',
      'fulfude':
          'Jaɓɓooji maa hollitiima ko addana maa e dow mawngo. Yah e gollirde laamu jooni.',
    },
  };
}
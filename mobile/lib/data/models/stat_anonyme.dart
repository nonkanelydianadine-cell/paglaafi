class StatAnonyme {
  final int? id;
  final String periode;
  final int nbEvaluations;
  final int nbFaible;
  final int nbModere;
  final int nbEleve;
  final int nbRappelsActifs;
  final bool synchronise;
  final String? dateMaj;

  const StatAnonyme({
    this.id,
    required this.periode,
    this.nbEvaluations = 0,
    this.nbFaible = 0,
    this.nbModere = 0,
    this.nbEleve = 0,
    this.nbRappelsActifs = 0,
    this.synchronise = false,
    this.dateMaj,
  });

  factory StatAnonyme.fromMap(Map<String, dynamic> m) => StatAnonyme(
        id: m['id'],
        periode: m['periode'],
        nbEvaluations: m['nb_evaluations'] ?? 0,
        nbFaible: m['nb_faible'] ?? 0,
        nbModere: m['nb_modere'] ?? 0,
        nbEleve: m['nb_eleve'] ?? 0,
        nbRappelsActifs: m['nb_rappels_actifs'] ?? 0,
        synchronise: (m['synchronise'] ?? 0) == 1,
        dateMaj: m['date_maj'],
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'periode': periode,
        'nb_evaluations': nbEvaluations,
        'nb_faible': nbFaible,
        'nb_modere': nbModere,
        'nb_eleve': nbEleve,
        'nb_rappels_actifs': nbRappelsActifs,
        'synchronise': synchronise ? 1 : 0,
        'date_maj': dateMaj,
      };
}

class AutoEvaluation {
  final int? id;
  final String profilId;
  final String dateEvaluation;
  final int scoreTotal;
  final String niveauRisque;
  final String messageOrientation;
  final int? dureeSecondes;

  const AutoEvaluation({
    this.id,
    required this.profilId,
    required this.dateEvaluation,
    required this.scoreTotal,
    required this.niveauRisque,
    required this.messageOrientation,
    this.dureeSecondes,
  });

  factory AutoEvaluation.fromMap(Map<String, dynamic> m) => AutoEvaluation(
        id: m['id'],
        profilId: m['profil_id'],
        dateEvaluation: m['date_evaluation'],
        scoreTotal: m['score_total'] ?? 0,
        niveauRisque: m['niveau_risque'],
        messageOrientation: m['message_orientation'],
        dureeSecondes: m['duree_secondes'],
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'profil_id': profilId,
        'date_evaluation': dateEvaluation,
        'score_total': scoreTotal,
        'niveau_risque': niveauRisque,
        'message_orientation': messageOrientation,
        'duree_secondes': dureeSecondes,
      };
}

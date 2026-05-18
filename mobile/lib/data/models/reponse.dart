class Reponse {
  final int? id;
  final int evaluationId;
  final int questionId;
  final String valeurReponse;
  final int poidsObtenu;
  final int? ordre;

  const Reponse({
    this.id,
    required this.evaluationId,
    required this.questionId,
    required this.valeurReponse,
    required this.poidsObtenu,
    this.ordre,
  });

  factory Reponse.fromMap(Map<String, dynamic> m) => Reponse(
        id: m['id'],
        evaluationId: m['evaluation_id'],
        questionId: m['question_id'],
        valeurReponse: m['valeur_reponse'],
        poidsObtenu: m['poids_obtenu'] ?? 0,
        ordre: m['ordre'],
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'evaluation_id': evaluationId,
        'question_id': questionId,
        'valeur_reponse': valeurReponse,
        'poids_obtenu': poidsObtenu,
        if (ordre != null) 'ordre': ordre,
      };
}

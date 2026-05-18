import '../../core/constants/db_constants.dart';

class ProfilLocal {
  final String id;
  final String languePreferee;
  final bool rappelsActives;
  final String frequenceRappel;
  final String dateCreation;

  const ProfilLocal({
    required this.id,
    required this.languePreferee,
    this.rappelsActives = true,
    this.frequenceRappel = 'mensuel',
    required this.dateCreation,
  });

  factory ProfilLocal.fromMap(Map<String, dynamic> m) => ProfilLocal(
        id: m['id'],
        languePreferee: m['langue_preferee'] ?? DbConstants.langFr,
        rappelsActives: (m['rappels_actives'] ?? 1) == 1,
        frequenceRappel: m['frequence_rappel'] ?? 'mensuel',
        dateCreation: m['date_creation'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'langue_preferee': languePreferee,
        'rappels_actives': rappelsActives ? 1 : 0,
        'frequence_rappel': frequenceRappel,
        'date_creation': dateCreation,
      };

  ProfilLocal copyWith({
    String? languePreferee,
    bool? rappelsActives,
    String? frequenceRappel,
  }) =>
      ProfilLocal(
        id: id,
        languePreferee: languePreferee ?? this.languePreferee,
        rappelsActives: rappelsActives ?? this.rappelsActives,
        frequenceRappel: frequenceRappel ?? this.frequenceRappel,
        dateCreation: dateCreation,
      );
}

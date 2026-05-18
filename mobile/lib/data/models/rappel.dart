import '../../core/constants/db_constants.dart';

class Rappel {
  final int? id;
  final String profilId;
  final String typeRappel;
  final String messageFr;
  final String? messageMoore;
  final String heureEnvoi;
  final String frequence;
  final bool actif;
  final String? derniereNotification;

  const Rappel({
    this.id,
    required this.profilId,
    required this.typeRappel,
    required this.messageFr,
    this.messageMoore,
    required this.heureEnvoi,
    required this.frequence,
    this.actif = true,
    this.derniereNotification,
  });

  String messageParLangue(String langue) {
    if (langue == DbConstants.langMoore && messageMoore != null) {
      return messageMoore!;
    }
    return messageFr;
  }

  factory Rappel.fromMap(Map<String, dynamic> m) => Rappel(
        id: m['id'],
        profilId: m['profil_id'],
        typeRappel: m['type_rappel'],
        messageFr: m['message_fr'],
        messageMoore: m['message_moore'],
        heureEnvoi: m['heure_envoi'],
        frequence: m['frequence'],
        actif: (m['actif'] ?? 1) == 1,
        derniereNotification: m['derniere_notification'],
      );

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'profil_id': profilId,
        'type_rappel': typeRappel,
        'message_fr': messageFr,
        'message_moore': messageMoore,
        'heure_envoi': heureEnvoi,
        'frequence': frequence,
        'actif': actif ? 1 : 0,
        'derniere_notification': derniereNotification,
      };

  Rappel copyWith({
    int? id,
    String? profilId,
    String? typeRappel,
    String? messageFr,
    String? messageMoore,
    String? heureEnvoi,
    String? frequence,
    bool? actif,
    String? derniereNotification,
  }) =>
      Rappel(
        id: id ?? this.id,
        profilId: profilId ?? this.profilId,
        typeRappel: typeRappel ?? this.typeRappel,
        messageFr: messageFr ?? this.messageFr,
        messageMoore: messageMoore ?? this.messageMoore,
        heureEnvoi: heureEnvoi ?? this.heureEnvoi,
        frequence: frequence ?? this.frequence,
        actif: actif ?? this.actif,
        derniereNotification: derniereNotification ?? this.derniereNotification,
      );
}
class DbConstants {
  static const String dbName = 'pag_laafi.db';
  static const int dbVersion = 3; // ← AUGMENTÉ de 2 à 3

  // Langues
  static const String langFr = 'fr';
  static const String langMoore = 'moore';
  static const String langDioula = 'dioula';
  static const String langFulfude = 'fulfude';

  // Niveaux de risque
  static const String risqueFaible = 'faible';
  static const String risqueModere = 'modere';
  static const String risqueEleve = 'eleve';

  // Seuils de risque (pour RiskCalculator)
  static const double seuilFaible = 0.33;
  static const double seuilModere = 0.66;

  // Tables
  static const String tableProfil = 'profil_local';
  static const String tableUtilisateur = 'utilisateur';
  static const String tableCentre = 'centre_sante';
  static const String tableQuestion = 'question';
  static const String tableContenu = 'contenu_educatif';
  static const String tableSymptome = 'symptome';
  static const String tableDepistage = 'depistage';
  static const String tableRappel = 'rappel';
  static const String tableEvaluation = 'auto_evaluation';
  static const String tableReponse = 'reponse';
  static const String tableEtape = 'etape_auto_examen';
  static const String tableStat = 'stat_anonyme';
}
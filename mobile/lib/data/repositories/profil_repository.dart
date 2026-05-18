import 'package:uuid/uuid.dart';
import '../database/database_helper.dart';
import '../models/profil_local.dart';
import '../../core/constants/db_constants.dart';

class ProfilRepository {
  final DatabaseHelper _db;
  ProfilRepository(this._db);

  /// Vérifie si c'est le premier lancement (pas encore de profil)
  Future<bool> estPremierLancement() async {
    final count = await _db.count(DbConstants.tableProfil);
    return count == 0;
  }

  /// Récupère le profil existant, ou crée un profil par défaut
  Future<ProfilLocal> getProfil() async {
    final rows = await _db.getAll(DbConstants.tableProfil, limit: 1);
    if (rows.isNotEmpty) return ProfilLocal.fromMap(rows.first);

    // Crée un profil par défaut
    final profil = ProfilLocal(
      id: const Uuid().v4(),
      languePreferee: DbConstants.langFr,
      rappelsActives: false,
      frequenceRappel: 'quotidien',
      dateCreation: DateTime.now().toIso8601String(),
    );
    await _db.insert(DbConstants.tableProfil, profil.toMap());
    return profil;
  }

  /// Met à jour la langue préférée
  Future<void> mettreAJourLangue(String profilId, String langue) async {
    await _db.update(
      DbConstants.tableProfil,
      {'langue_preferee': langue},
      where: 'id = ?',
      whereArgs: [profilId],
    );
  }

  /// Active/désactive les rappels
  Future<void> mettreAJourRappels(
    String profilId, {
    required bool actives,
    required String frequence,
  }) async {
    await _db.update(
      DbConstants.tableProfil,
      {
        'rappels_actives': actives ? 1 : 0,
        'frequence_rappel': frequence,
      },
      where: 'id = ?',
      whereArgs: [profilId],
    );
  }
}
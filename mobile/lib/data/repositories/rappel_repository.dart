import 'package:flutter/foundation.dart';  // 
import '../database/database_helper.dart';
import '../models/rappel.dart';
import '../../core/constants/db_constants.dart';

class RappelRepository {
  final DatabaseHelper _db;
  RappelRepository(this._db);

  Future<List<Rappel>> getRappels(String profilId) async {
    try {
      final rows = await _db.getAll(
        DbConstants.tableRappel,
        where: 'profil_id = ?',
        whereArgs: [profilId],
      );
      return rows.map((r) => Rappel.fromMap(r)).toList();
    } catch (e) {
      debugPrint('RappelRepository.getRappels erreur: $e');
      return [];
    }
  }

  Future<int> inserer(Rappel rappel) async =>
      await _db.insert(DbConstants.tableRappel, rappel.toMap());

  Future<void> mettreAJour(Rappel rappel) async {
    await _db.update(
      DbConstants.tableRappel,
      rappel.toMap(),
      where: 'id = ?',
      whereArgs: [rappel.id],
    );
  }

  Future<void> toggleActif(int rappelId, bool actif) async {
    await _db.update(
      DbConstants.tableRappel,
      {'actif': actif ? 1 : 0},
      where: 'id = ?',
      whereArgs: [rappelId],
    );
  }

  Future<void> mettreAJourRappel(
    int rappelId, {
    required String frequence,
    required String heure,
  }) async {
    await _db.update(
      DbConstants.tableRappel,
      {'frequence': frequence, 'heure_envoi': heure},
      where: 'id = ?',
      whereArgs: [rappelId],
    );
  }

  Future<void> supprimerRappel(int rappelId) async {
    await _db.delete(
      DbConstants.tableRappel,
      where: 'id = ?',
      whereArgs: [rappelId],
    );
  }

  Future<List<Rappel>> creerRappelsParDefaut(String profilId) async {
    final rappels = [
      Rappel(
        profilId: profilId,
        typeRappel: 'auto_examen',
        messageFr: 'Il est temps de pratiquer votre auto-examen mammaire.',
        messageMoore: 'Wakat la n tara f mens auto-examen.',
        heureEnvoi: '09:00',
        frequence: 'mensuel',
        actif: true,
      ),
      Rappel(
        profilId: profilId,
        typeRappel: 'consultation',
        messageFr: 'Pensez à consulter un professionnel de santé.',
        messageMoore: 'Kẽng-y laafi rogem dãmba.',
        heureEnvoi: '09:00',
        frequence: 'mensuel',
        actif: false,
      ),
    ];
    
    for (final r in rappels) {
      await inserer(r);
    }
    
    return getRappels(profilId);
  }
}
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../database/database_helper.dart';
import '../../core/constants/db_constants.dart';

class SeedService {
  final DatabaseHelper _db;
  SeedService(this._db);

  Future<void> initialiser() async {
    // Force le rechargement des données statiques
    // à chaque lancement en mode développement
    await _seeder(DbConstants.tableQuestion,   'assets/data/questions.json');
    await _seeder(DbConstants.tableCentre,     'assets/data/centres.json');
    await _seeder(DbConstants.tableContenu,    'assets/data/contenus.json');
    await _seeder(DbConstants.tableEtape,      'assets/data/etapes_examen.json');
  }

  Future<void> _seeder(String table, String assetPath) async {
    // Vide la table et réinsère depuis le JSON
    // Cela garantit que les données sont toujours à jour
    await _db.rawQuery('DELETE FROM $table');

    try {
      final jsonStr = await rootBundle.loadString(assetPath);
      final List<dynamic> items = jsonDecode(jsonStr);
      if (items.isEmpty) return;
      for (final item in items) {
        await _db.insert(table, Map<String, dynamic>.from(item));
      }
      debugPrint('SeedService : $table chargé (${items.length} items)');
    } catch (e) {
      debugPrint('SeedService erreur $table : $e');
    }
  }
}
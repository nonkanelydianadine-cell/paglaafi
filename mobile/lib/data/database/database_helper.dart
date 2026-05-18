import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/db_constants.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), DbConstants.dbName);
    return await openDatabase(
      path,
      version: DbConstants.dbVersion,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('🔧 Migration DB: $oldVersion → $newVersion');

    if (oldVersion < 2) {
      await _migrationV2(db);
    }

    if (oldVersion < 3) {
      await _migrationV3(db);
    }
  }

  Future<void> _migrationV2(Database db) async {
    debugPrint('🔧 Migration V2...');
    await _tryAlter(db, 'ALTER TABLE centre_sante ADD COLUMN ville TEXT');
    await _tryAlter(db, 'ALTER TABLE centre_sante ADD COLUMN telephone TEXT');
    await _tryAlter(db, 'ALTER TABLE centre_sante ADD COLUMN horaires TEXT');
    await _tryAlter(db, 'ALTER TABLE centre_sante ADD COLUMN distance_km REAL');
    await _tryAlter(db, 'ALTER TABLE centre_sante ADD COLUMN actif INTEGER DEFAULT 1');
    await _tryAlter(db, 'ALTER TABLE centre_sante ADD COLUMN audio_fr TEXT');
    await _tryAlter(db, 'ALTER TABLE centre_sante ADD COLUMN audio_moore TEXT');
  }

  Future<void> _migrationV3(Database db) async {
    debugPrint('🔧 Migration V3: table question...');

    try {
      final tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='question'"
      );

      if (tables.isEmpty) {
        debugPrint('ℹ️ Table question n\'existe pas encore');
        return;
      }

      final columns = await db.rawQuery('PRAGMA table_info(question)');
      final hasOptions = columns.any((c) => c['name'] == 'options');

      if (hasOptions) {
        debugPrint('ℹ️ Colonne options existe déjà');
        return;
      }

      debugPrint('📝 Migration table question...');

      await db.execute('ALTER TABLE question RENAME TO question_old');
      debugPrint('✅ Renommée en question_old');

      await db.execute('''
        CREATE TABLE question (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          ordre INTEGER NOT NULL UNIQUE,
          type_reponse TEXT NOT NULL DEFAULT 'choix_multiple',
          poids_max INTEGER NOT NULL DEFAULT 3,
          enonce_fr TEXT NOT NULL,
          enonce_moore TEXT,
          enonce_dioula TEXT,
          enonce_fulfude TEXT,
          audio_fr TEXT,
          audio_moore TEXT,
          audio_dioula TEXT,
          audio_fulfude TEXT,
          options TEXT
        );
      ''');
      debugPrint('✅ Nouvelle table créée');

      await db.execute('''
        INSERT INTO question (
          id, ordre, type_reponse, poids_max,
          enonce_fr, enonce_moore, enonce_dioula, enonce_fulfude,
          audio_fr, audio_moore, audio_dioula, audio_fulfude,
          options
        )
        SELECT
          id,
          COALESCE(ordre, id) as ordre,
          COALESCE(type_reponse, 'choix_multiple') as type_reponse,
          COALESCE(poids_max, 3) as poids_max,
          COALESCE(enonce_fr, titre, '') as enonce_fr,
          enonce_moore,
          enonce_dioula,
          enonce_fulfude,
          audio_fr,
          audio_moore,
          audio_dioula,
          audio_fulfude,
          NULL as options
        FROM question_old;
      ''');
      debugPrint('✅ Données migrées');

      await db.execute('DROP TABLE question_old');
      debugPrint('✅ question_old supprimée');

    } catch (e, stack) {
      debugPrint('❌ Erreur migration V3: $e');
      debugPrint(stack.toString());

      try {
        final oldTables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='question_old'"
        );
        if (oldTables.isNotEmpty) {
          await db.execute('DROP TABLE IF EXISTS question');
          await db.execute('ALTER TABLE question_old RENAME TO question');
          debugPrint('⚠️ Restauration effectuée');
        }
      } catch (restoreError) {
        debugPrint('❌ Restauration impossible: $restoreError');
      }
      rethrow;
    }
  }

  Future<void> _tryAlter(Database db, String sql) async {
    try {
      await db.execute(sql);
    } catch (e) {
      debugPrint('⚠️ Alter ignoré: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    debugPrint('🆕 Création base v$version');

    await db.execute('''
      CREATE TABLE profil_local (
        id TEXT PRIMARY KEY,
        langue_preferee TEXT,
        rappels_actives INTEGER,
        frequence_rappel TEXT,
        date_creation TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE utilisateur (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        email TEXT,
        age INTEGER,
        sexe TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE centre_sante (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        adresse TEXT,
        contact TEXT,
        ville TEXT,
        telephone TEXT,
        horaires TEXT,
        distance_km REAL,
        actif INTEGER,
        audio_fr TEXT,
        audio_moore TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE question (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ordre INTEGER NOT NULL UNIQUE,
        type_reponse TEXT NOT NULL DEFAULT 'choix_multiple',
        poids_max INTEGER NOT NULL DEFAULT 3,
        enonce_fr TEXT NOT NULL,
        enonce_moore TEXT,
        enonce_dioula TEXT,
        enonce_fulfude TEXT,
        audio_fr TEXT,
        audio_moore TEXT,
        audio_dioula TEXT,
        audio_fulfude TEXT,
        options TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE contenu_educatif (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        ordre INTEGER,
        categorie TEXT,
        titre_fr TEXT,
        titre_moore TEXT,
        titre_dioula TEXT,
        titre_fulfude TEXT,
        texte_fr TEXT,
        texte_moore TEXT,
        texte_dioula TEXT,
        texte_fulfude TEXT,
        illustration_path TEXT,
        audio_fr TEXT,
        audio_moore TEXT,
        audio_dioula TEXT,
        audio_fulfude TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE symptome (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        description TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE depistage (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        utilisateur_id INTEGER,
        resultat TEXT,
        date TEXT,
        FOREIGN KEY(utilisateur_id) REFERENCES utilisateur(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE rappel (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profil_id TEXT NOT NULL,
        type_rappel TEXT NOT NULL,
        message_fr TEXT NOT NULL,
        message_moore TEXT,
        heure_envoi TEXT NOT NULL DEFAULT '09:00',
        frequence TEXT NOT NULL DEFAULT 'mensuel',
        actif INTEGER NOT NULL DEFAULT 1,
        derniere_notification TEXT,
        FOREIGN KEY (profil_id) REFERENCES profil_local(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE auto_evaluation (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        profil_id TEXT,
        date_evaluation TEXT,
        score_total INTEGER,
        niveau_risque TEXT,
        message_orientation TEXT,
        duree_secondes INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE reponse (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        evaluation_id INTEGER NOT NULL,
        question_id INTEGER NOT NULL,
        valeur_reponse TEXT NOT NULL,
        poids_obtenu INTEGER DEFAULT 0,
        ordre INTEGER DEFAULT 0,
        FOREIGN KEY (evaluation_id) REFERENCES auto_evaluation(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE etape_auto_examen (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero_etape INTEGER,
        titre_fr TEXT,
        titre_moore TEXT,
        titre_dioula TEXT,
        titre_fulfude TEXT,
        description_fr TEXT,
        description_moore TEXT,
        description_dioula TEXT,
        description_fulfude TEXT,
        illustration_path TEXT,
        audio_fr TEXT,
        audio_moore TEXT,
        audio_dioula TEXT,
        audio_fulfude TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE stat_anonyme (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        periode TEXT,
        nb_evaluations INTEGER,
        nb_faible INTEGER,
        nb_modere INTEGER,
        nb_eleve INTEGER,
        nb_rappels_actifs INTEGER,
        synchronise INTEGER,
        date_maj TEXT
      );
    ''');

    debugPrint('✅ Base créée');
  }

  Future<int> insert(String table, Map<String, dynamic> data) async =>
      (await database)
          .insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);

  Future<List<Map<String, dynamic>>> getAll(String table,
          {String? where,
          List<dynamic>? whereArgs,
          String? orderBy,
          int? limit}) async =>
      (await database).query(table,
          where: where, whereArgs: whereArgs, orderBy: orderBy, limit: limit);

  Future<int> update(String table, Map<String, dynamic> data,
          {required String where, required List<dynamic> whereArgs}) async =>
      (await database).update(table, data, where: where, whereArgs: whereArgs);

  Future<int> delete(String table,
          {required String where, required List<dynamic> whereArgs}) async =>
      (await database).delete(table, where: where, whereArgs: whereArgs);

  Future<List<Map<String, dynamic>>> rawQuery(String sql,
          [List<dynamic>? args]) async =>
      (await database).rawQuery(sql, args);

  Future<int> count(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    final r = await (await database).rawQuery(
        'SELECT COUNT(*) as c FROM $table'
        '${where != null ? ' WHERE $where' : ''}',
        whereArgs);
    return r.first['c'] as int? ?? 0;
  }

  Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }
}
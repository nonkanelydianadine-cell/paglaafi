import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../database/database_helper.dart';
import '../models/question.dart';
import '../models/auto_evaluation.dart';
import '../models/reponse.dart';
import '../models/stat_anonyme.dart';
import '../../core/constants/db_constants.dart';

class EvaluationRepository {
  final DatabaseHelper _db;
  EvaluationRepository(this._db);

  Future<List<Question>> getQuestions() async {
    debugPrint('📥 getQuestions() appelé');

    try {
      final rows = await _db.getAll(
        DbConstants.tableQuestion,
        orderBy: 'ordre ASC',
      );
      debugPrint('📊 Rows dans DB: ${rows.length}');

      if (rows.isNotEmpty) {
        debugPrint('✅ DB non vide, parsing...');
        final questions = rows.map((r) {
          try {
            return Question.fromMap(r);
          } catch (e) {
            debugPrint('❌ Erreur parsing: $e');
            debugPrint('   Row: $r');
            return null;
          }
        }).whereType<Question>().toList();

        debugPrint('✅ Parsées: ${questions.length}');
        return questions;
      }

      debugPrint('⚠️ DB vide, chargement assets...');
      return await _chargerQuestionsDepuisAssets();

    } catch (e, stack) {
      debugPrint('❌ ERREUR getQuestions(): $e');
      debugPrint(stack.toString());
      return [];
    }
  }

  Future<List<Question>> _chargerQuestionsDepuisAssets() async {
    try {
      debugPrint('📂 Lecture assets/data/questions.json...');
      final jsonString = await rootBundle.loadString('assets/data/questions.json');
      debugPrint('📄 JSON lu: ${jsonString.length} caractères');

      final List<dynamic> jsonList = jsonDecode(jsonString);
      debugPrint('📋 JSON décodé: ${jsonList.length} questions');

      for (final q in jsonList) {
        final Map<String, dynamic> questionMap = Map<String, dynamic>.from(q);

        if (questionMap['options'] != null) {
          questionMap['options'] = jsonEncode(questionMap['options']);
        }

        debugPrint('💾 Insertion Q${questionMap['ordre']}');
        await _db.insert(DbConstants.tableQuestion, questionMap);
      }

      final newRows = await _db.getAll(
        DbConstants.tableQuestion,
        orderBy: 'ordre ASC',
      );
      debugPrint('✅ Insertion: ${newRows.length} questions');

      return newRows.map((r) => Question.fromMap(r)).toList();

    } on FlutterError catch (e) {
      debugPrint('❌ FlutterError (assets manquant?): $e');
      return [];
    } catch (e, stack) {
      debugPrint('❌ ERREUR _chargerQuestionsDepuisAssets: $e');
      debugPrint(stack.toString());
      return [];
    }
  }

  Future<List<Reponse>> getReponses(int evaluationId) async {
    final maps = await _db.rawQuery('''
      SELECT * FROM ${DbConstants.tableReponse}
      WHERE evaluation_id = ?
      ORDER BY ordre ASC
    ''', [evaluationId]);

    return maps.map((m) => Reponse.fromMap(m)).toList();
  }

  Future<int> sauvegarderEvaluation(
    AutoEvaluation evaluation,
    List<Reponse> reponses,
  ) async {
    final evalId = await _db.insert(
      DbConstants.tableEvaluation,
      evaluation.toMap(),
    );
    for (final r in reponses) {
      await _db.insert(
          DbConstants.tableReponse,
          Reponse(
            evaluationId: evalId,
            questionId: r.questionId,
            valeurReponse: r.valeurReponse,
            poidsObtenu: r.poidsObtenu,
          ).toMap());
    }
    await _incrementerStat(evaluation.niveauRisque);
    return evalId;
  }

  Future<List<AutoEvaluation>> getHistorique(String profilId) async {
    final rows = await _db.getAll(
      DbConstants.tableEvaluation,
      where: 'profil_id = ?',
      whereArgs: [profilId],
      orderBy: 'date_evaluation DESC',
    );
    return rows.map((r) => AutoEvaluation.fromMap(r)).toList();
  }

  Future<void> _incrementerStat(String niveau) async {
    final now = DateTime.now();
    final periode = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final rows = await _db.getAll(
      DbConstants.tableStat,
      where: 'periode = ?',
      whereArgs: [periode],
    );
    if (rows.isEmpty) {
      await _db.insert(
          DbConstants.tableStat,
          StatAnonyme(
            periode: periode,
            nbEvaluations: 1,
            nbFaible: niveau == DbConstants.risqueFaible ? 1 : 0,
            nbModere: niveau == DbConstants.risqueModere ? 1 : 0,
            nbEleve: niveau == DbConstants.risqueEleve ? 1 : 0,
            dateMaj: DateTime.now().toIso8601String(),
          ).toMap());
    } else {
      final stat = StatAnonyme.fromMap(rows.first);
      await _db.update(
        DbConstants.tableStat,
        {
          'nb_evaluations': stat.nbEvaluations + 1,
          'nb_faible':
              stat.nbFaible + (niveau == DbConstants.risqueFaible ? 1 : 0),
          'nb_modere':
              stat.nbModere + (niveau == DbConstants.risqueModere ? 1 : 0),
          'nb_eleve':
              stat.nbEleve + (niveau == DbConstants.risqueEleve ? 1 : 0),
          'date_maj': DateTime.now().toIso8601String(),
        },
        where: 'periode = ?',
        whereArgs: [periode],
      );
    }
  }
}
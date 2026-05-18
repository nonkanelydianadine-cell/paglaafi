import 'package:flutter/foundation.dart';
import '../../data/models/question.dart';
import '../../data/models/auto_evaluation.dart';
import '../../data/models/reponse.dart';
import '../../data/repositories/evaluation_repository.dart';
import '../../data/repositories/profil_repository.dart';
import '../../data/services/audio_service.dart';
import '../../core/utils/risk_calculator.dart';

class EvaluationViewModel extends ChangeNotifier {
  final EvaluationRepository _evalRepo;
  final ProfilRepository _profilRepo;
  EvaluationViewModel(this._evalRepo, this._profilRepo);

  List<Question> _questions = [];
  int _questionCourante = 0;
  final Map<int, Map<String, dynamic>> _reponses = {};
  bool _chargement = false;
  bool _termine = false;
  DateTime? _debut;

  List<Question> get questions => _questions;
  int get questionCourante => _questionCourante;
  int get nombreQuestions => _questions.length;
  bool get chargement => _chargement;
  bool get termine => _termine;
  bool get estPremiere => _questionCourante == 0;
  bool get estDerniere => _questionCourante == _questions.length - 1;
  double get progression =>
      _questions.isEmpty ? 0 : (_questionCourante + 1) / _questions.length;
  Question? get questionActive =>
      _questions.isNotEmpty ? _questions[_questionCourante] : null;

  bool get aRepondu =>
      questionActive != null && _reponses.containsKey(questionActive!.id);

  String? reponseChoisie(int questionId) =>
      _reponses[questionId]?['texte'] as String?;

  int get scoreTotal => _reponses.values
      .fold(0, (sum, r) => sum + (r['poids'] as int));
  int get scoreMax => _questions.fold(0, (sum, q) => sum + q.poidsMax);

  Future<void> charger() async {
    _chargement = true;
    notifyListeners();

    try {
      debugPrint('🔄 Début chargement questions...');
      _questions = await _evalRepo.getQuestions();
      debugPrint('✅ Questions reçues: ${_questions.length}');

      if (_questions.isEmpty) {
        debugPrint('⚠️ LISTE VIDE');
      } else {
        for (final q in _questions) {
          final enonce = q.enonceFr.length > 40
              ? '${q.enonceFr.substring(0, 40)}...'
              : q.enonceFr;
          debugPrint('  Q${q.id}: $enonce | options: ${q.options.length}');
        }
      }
    } catch (e, stack) {
      debugPrint('❌ ERREUR charger(): $e');
      debugPrint(stack.toString());
      _questions = [];
    }

    _questionCourante = 0;
    _reponses.clear();
    _termine = false;
    _debut = DateTime.now();

    _chargement = false;
    notifyListeners();
  }

  void repondre({
    required int questionId,
    required String texte,
    required int poids,
  }) {
    _reponses[questionId] = {'texte': texte, 'poids': poids};
    notifyListeners();
  }

  void suivante() {
    if (!estDerniere && aRepondu) {
      AudioService.instance.arreter();
      _questionCourante++;
      notifyListeners();
    }
  }

  void precedente() {
    if (!estPremiere) {
      AudioService.instance.arreter();
      _questionCourante--;
      notifyListeners();
    }
  }

  Future<void> ecouterQuestion(String langue) async {
    final q = questionActive;
    if (q == null) return;
    await AudioService.instance.jouerParLangue(
      langue: langue,
      audioFr: q.audioFr,
      audioMoore: q.audioMoore,
      audioDioula: q.audioDioula,
      audioFulfude: q.audioFulfude,
    );
  }

  Future<AutoEvaluation?> valider(String langue) async {
    _chargement = true;
    notifyListeners();

    try {
      final profil = await _profilRepo.getProfil();
      final duree = _debut != null
          ? DateTime.now().difference(_debut!).inSeconds
          : null;
      final niveau = RiskCalculator.calculerNiveau(
        scoreTotal: scoreTotal,
        scoreMax: scoreMax,
      );
      final message = RiskCalculator.messageOrientation(
        niveau: niveau,
        langue: langue,
      );

      final evaluation = AutoEvaluation(
        profilId: profil.id,
        dateEvaluation: DateTime.now().toIso8601String(),
        scoreTotal: scoreTotal,
        niveauRisque: niveau,
        messageOrientation: message,
        dureeSecondes: duree,
      );

      final reponses = _questions.map((q) => Reponse(
        evaluationId: 0,
        questionId: q.id,
        valeurReponse: _reponses[q.id]?['texte'] ?? '',
        poidsObtenu: _reponses[q.id]?['poids'] ?? 0,
      )).toList();

      await _evalRepo.sauvegarderEvaluation(evaluation, reponses);
      _termine = true;
      _chargement = false;
      notifyListeners();
      return evaluation;
    } catch (e) {
      debugPrint('EvaluationViewModel.valider() erreur : $e');
      _chargement = false;
      notifyListeners();
      return null;
    }
  }

  void reinitialiser() {
    _questionCourante = 0;
    _reponses.clear();
    _termine = false;
    _debut = null;
    AudioService.instance.arreter();
    notifyListeners();
  }
}
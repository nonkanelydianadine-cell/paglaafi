import 'package:flutter/foundation.dart';
import '../../data/models/auto_evaluation.dart';
import '../../data/repositories/evaluation_repository.dart';
//import '../../core/constants/db_constants.dart';

class HistoriqueViewModel extends ChangeNotifier {
  final EvaluationRepository _evalRepo;
  HistoriqueViewModel(this._evalRepo);

  List<AutoEvaluation> _evaluations = [];
  bool _chargement = false;

  List<AutoEvaluation> get evaluations => _evaluations;
  bool get chargement => _chargement;
  bool get estVide => _evaluations.isEmpty && !_chargement;
  int get nombre => _evaluations.length;

  Future<void> charger(String profilId) async {
    _chargement = true;
    notifyListeners();

    _evaluations = await _evalRepo.getHistorique(profilId);

    _chargement = false;
    notifyListeners();
  }

  static String formaterDate(String dateIso) {
    try {
      final date = DateTime.parse(dateIso);
      const mois = ['', 'jan', 'fév', 'mar', 'avr', 'mai', 'jun',
                    'jul', 'aoû', 'sep', 'oct', 'nov', 'déc'];
      return '${date.day} ${mois[date.month]} ${date.year}';
    } catch (_) {
      return dateIso;
    }
  }

  static String labelNiveau(String niveau, String langue) {
    const labels = {
      'faible': {'fr': 'Faible',  'moore': 'Bɩɩmé',    'dioula': 'Dɔgɔ',   'fulfude': 'Famɗi'},
      'modere': {'fr': 'Modéré',  'moore': 'Cɛngẽ',    'dioula': 'Cɛmana', 'fulfude': 'Hakkunde'},
      'eleve':  {'fr': 'Élevé',   'moore': 'Beoog',     'dioula': 'Gɛlɛya', 'fulfude': 'Mawngo'},
    };
    return labels[niveau]?[langue] ?? labels[niveau]?['fr'] ?? niveau;
  }

  static String avertissement(String langue) {
    const messages = {
      'fr':      'Ces résultats ne sont pas des diagnostics médicaux. Consultez un professionnel de santé.',
      'moore':   'Leokr kãng ka yaa laafi rogem dãmb leokr ye. Kẽng-y laafi rogem dãmba.',
      'dioula':  'Nin jaabi tɔnw tɛ fura ye. Taa lafiɲɛ mɔgɔ dɔ wele.',
      'fulfude': 'Jaɓɓooji ɗii ngoni diagnosi. Yah e gollirde laamu.',
    };
    return messages[langue] ?? messages['fr']!;
  }
}
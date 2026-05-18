import 'package:flutter/foundation.dart';
import '../../data/models/etape_auto_examen.dart';
import '../../data/repositories/contenu_repository.dart';
import '../../data/services/audio_service.dart';

class AutoExamenViewModel extends ChangeNotifier {
  final ContenuRepository _contenuRepo;
  AutoExamenViewModel(this._contenuRepo);

  List<EtapeAutoExamen> _etapes = [];
  int _etapeCourante = 0;
  bool _chargement = false;

  // ── Getters ──
  List<EtapeAutoExamen> get etapes => _etapes;
  int get etapeCourante => _etapeCourante;
  int get nombreEtapes => _etapes.length; // sera 8
  bool get chargement => _chargement;
  bool get estPremiere => _etapeCourante == 0;
  bool get estDerniere => _etapeCourante == _etapes.length - 1;

  // Progression de 0.0 à 1.0
  double get progression =>
      _etapes.isEmpty ? 0 : (_etapeCourante + 1) / _etapes.length;

  // Pourcentage lisible ex: "3 / 8"
  String get progressionLabel =>
      '${_etapeCourante + 1} / ${_etapes.length}';

  EtapeAutoExamen? get etapeActive =>
      _etapes.isNotEmpty ? _etapes[_etapeCourante] : null;

  /// Charge les 8 étapes depuis SQLite
  Future<void> charger() async {
    _chargement = true;
    notifyListeners();

    _etapes = await _contenuRepo.getEtapes();
    _etapeCourante = 0;

    _chargement = false;
    notifyListeners();
  }

  /// Passe à l'étape suivante
  void suivante() {
    if (!estDerniere) {
      AudioService.instance.arreter();
      _etapeCourante++;
      notifyListeners();
    }
  }

  /// Revient à l'étape précédente
  void precedente() {
    if (!estPremiere) {
      AudioService.instance.arreter();
      _etapeCourante--;
      notifyListeners();
    }
  }

  /// Saute directement à une étape (clic sur un point)
  void allerAEtape(int index) {
    if (index >= 0 && index < _etapes.length) {
      AudioService.instance.arreter();
      _etapeCourante = index;
      notifyListeners();
    }
  }

  /// Écoute l'audio de l'étape courante
  Future<void> ecouterEtape(String langue) async {
    final etape = etapeActive;
    if (etape == null) return;
    await AudioService.instance.jouerParLangue(
      langue: langue,
      audioFr:      etape.audioFr,
      audioMoore:   etape.audioMoore,
      audioDioula:  etape.audioDioula,
      audioFulfude: etape.audioFulfude,
    );
  }

  /// Remet à zéro et retourne à l'étape 1
  void reinitialiser() {
    AudioService.instance.arreter();
    _etapeCourante = 0;
    notifyListeners();
  }
}
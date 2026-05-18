import 'package:flutter/foundation.dart';
import '../../data/models/contenu_educatif.dart';
import '../../data/repositories/contenu_repository.dart';
import '../../data/services/audio_service.dart';

class InformationsViewModel extends ChangeNotifier {
  final ContenuRepository _contenuRepo;
  InformationsViewModel(this._contenuRepo);

  List<ContenuEducatif> _contenus = [];
  String _categorieActive = 'cancer';
  bool _chargement = false;

  List<ContenuEducatif> get contenus => _contenus;
  String get categorieActive => _categorieActive;
  bool get chargement => _chargement;
  bool get estVide => _contenus.isEmpty && !_chargement;

  Future<void> charger(String langue) async {
    _chargement = true;
    notifyListeners();

    _contenus = await _contenuRepo.getContenus(_categorieActive);

    _chargement = false;
    notifyListeners();
  }

  Future<void> changerCategorie(String categorie, String langue) async {
    if (_categorieActive == categorie) return;
    _categorieActive = categorie;
    await charger(langue);
  }

  Future<void> ecouterContenu(ContenuEducatif contenu, String langue) async {
    await AudioService.instance.jouerParLangue(
      langue: langue,
      audioFr:      contenu.audioFr,
      audioMoore:   contenu.audioMoore,
      audioDioula:  contenu.audioDioula,
      audioFulfude: contenu.audioFulfude,
    );
  }

  Future<void> arreterAudio() async {
    await AudioService.instance.arreter();
  }

  // Labels des onglets selon la langue
  static String labelCategorie(String categorie, String langue) {
    const labels = {
      'cancer':     {'fr': "C'est quoi ?", 'moore': 'Bõna?',   'dioula': 'Mun ye?',   'fulfude': 'Ko honɗum?'},
      'signes':     {'fr': 'Signes',        'moore': 'Yĩnda',   'dioula': 'Ciiɲɛ',     'fulfude': 'Suɓe'},
      'prevention': {'fr': 'Prévention',    'moore': 'Sugs',    'dioula': 'Kɛnɛya',    'fulfude': 'Jarmital'},
      'risques':    {'fr': 'Risques',       'moore': 'Wẽnnɛ',   'dioula': 'Kɔfɛrɛ',   'fulfude': 'Kalfinoji'},
    };
    return labels[categorie]?[langue] ?? labels[categorie]?['fr'] ?? categorie;
  }
}
import 'package:flutter/foundation.dart';
import '../../data/models/centre_sante.dart';
import '../../data/repositories/centre_repository.dart';
import '../../data/services/audio_service.dart';

class CentresViewModel extends ChangeNotifier {
  final CentreRepository _centreRepo;
  CentresViewModel(this._centreRepo);

  List<CentreSante> _tousLesCentres = [];
  List<CentreSante> _centresFiltres = [];
  List<String> _villes = [];
  String _villeActive = 'Tous';
  String _recherche = '';
  bool _chargement = false;

  List<CentreSante> get centres => _centresFiltres;
  List<String> get villes => ['Tous', ..._villes];
  String get villeActive => _villeActive;
  bool get chargement => _chargement;
  bool get estVide => _centresFiltres.isEmpty && !_chargement;

  Future<void> charger() async {
    _chargement = true;
    notifyListeners();

    _tousLesCentres = await _centreRepo.getCentres();
    _villes = await _centreRepo.getVilles();
    _appliquerFiltres();

    _chargement = false;
    notifyListeners();
  }

  void filtrerVille(String ville) {
    _villeActive = ville;
    _appliquerFiltres();
    notifyListeners();
  }

  void rechercher(String texte) {
    _recherche = texte.trim();
    _appliquerFiltres();
    notifyListeners();
  }

  Future<void> ecouterCentre(CentreSante centre, String langue) async {
    await AudioService.instance.jouerParLangue(
      langue: langue,
      audioFr:    centre.audioFr,
      audioMoore: centre.audioMoore,
    );
  }

  void _appliquerFiltres() {
    var liste = List<CentreSante>.from(_tousLesCentres);
    if (_villeActive != 'Tous') {
      liste = liste.where((c) => c.ville == _villeActive).toList();
    }
    if (_recherche.isNotEmpty) {
      final q = _recherche.toLowerCase();
      liste = liste.where((c) =>
        c.nom.toLowerCase().contains(q) ||
        c.adresse.toLowerCase().contains(q)
      ).toList();
    }
    _centresFiltres = liste;
  }
}
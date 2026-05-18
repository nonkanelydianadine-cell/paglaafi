import 'package:flutter/foundation.dart';
import '../../data/models/profil_local.dart';
import '../../data/repositories/profil_repository.dart';
import '../../data/services/audio_service.dart';
import '../../core/constants/db_constants.dart';

class LangueViewModel extends ChangeNotifier {
  final ProfilRepository _profilRepo;
  LangueViewModel(this._profilRepo);

  ProfilLocal? _profil;
  String _langueSelectionnee = DbConstants.langFr;
  bool _chargement = false;
  bool _estPremierLancement = false;

  ProfilLocal? get profil => _profil;
  String get langueSelectionnee => _langueSelectionnee;
  bool get chargement => _chargement;
  bool get estPremierLancement => _estPremierLancement;

 Future<void> initialiser() async {
  _chargement = true;
  notifyListeners();

  // Vérifie d'abord si c'est le premier lancement
  // AVANT que getProfil() crée automatiquement un profil
  _estPremierLancement = await _profilRepo.estPremierLancement();

  // Ensuite charge ou crée le profil
  _profil = await _profilRepo.getProfil();
  _langueSelectionnee = _profil!.languePreferee;

  _chargement = false;
  notifyListeners();
}
  void selectionnerLangue(String langue) {
    _langueSelectionnee = langue;
    notifyListeners();
  }

  Future<void> ecouterLangue(String langue) async {
    final chemins = {
      'fr':      'assets/audio/fr/langue_fr.mp3',
      'moore':   'assets/audio/moore/langue_moore.mp3',
      'dioula':  'assets/audio/dioula/langue_dioula.mp3',
      'fulfude': 'assets/audio/fulfude/langue_fulfude.mp3',
    };
    final chemin = chemins[langue];
    if (chemin != null) {
      await AudioService.instance.jouer(chemin);
    }
  }

  Future<void> confirmerLangue() async {
    if (_profil == null) return;
    _chargement = true;
    notifyListeners();

    await _profilRepo.mettreAJourLangue(_profil!.id, _langueSelectionnee);
    _profil = _profil!.copyWith(languePreferee: _langueSelectionnee);

    _chargement = false;
    notifyListeners();
  }

  // Labels affichés sur l'écran de choix de langue
  static const Map<String, Map<String, String>> labelsLangues = {
    'fr':      {'nom': 'Français',  'nomLocal': 'Français'},
    'moore':   {'nom': 'Mooré',     'nomLocal': 'Mooré'},
    'dioula':  {'nom': 'Dioula',    'nomLocal': 'Julakan'},
    'fulfude': {'nom': 'Fulfuldé',  'nomLocal': 'Fulfuldé'},
  };

}
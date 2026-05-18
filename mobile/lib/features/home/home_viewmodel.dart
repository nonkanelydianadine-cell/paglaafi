import 'package:flutter/foundation.dart';
import '../../data/models/profil_local.dart';
import '../../data/repositories/profil_repository.dart';
import '../../core/constants/db_constants.dart';

class HomeViewModel extends ChangeNotifier {
  final ProfilRepository _profilRepo;
  HomeViewModel(this._profilRepo);

  ProfilLocal? _profil;
  bool _chargement = false;
  int _indexNavigation = 0;

  ProfilLocal? get profil => _profil;
  bool get chargement => _chargement;
  int get indexNavigation => _indexNavigation;
  String get langueActive => _profil?.languePreferee ?? DbConstants.langFr;

  Future<void> charger() async {
    _chargement = true;
    notifyListeners();

    _profil = await _profilRepo.getProfil();

    _chargement = false;
    notifyListeners();
  }

  void changerOnglet(int index) {
    _indexNavigation = index;
    notifyListeners();
  }

  Future<void> changerLangue(String langue) async {
    if (_profil == null) return;
    await _profilRepo.mettreAJourLangue(_profil!.id, langue);
    _profil = _profil!.copyWith(languePreferee: langue);
    notifyListeners();
  }

  // Message de bienvenue selon la langue
  String get messageAccueil {
    switch (langueActive) {
      case 'moore':   return 'Tɩ d wilg-y laafi';
      case 'dioula':  return 'I ni sɔrɔ';
      case 'fulfude': return 'Jam waɗi';
      default:        return 'Bienvenue sur Pag Laafi';
    }
  }

  String get sousMessage {
    switch (langueActive) {
      case 'moore':   return 'Tɩ d sõng-y f laafi taoor';
      case 'dioula':  return 'An bɛ i kɛnɛya ka kɔlɔsi';
      case 'fulfude': return 'Min mballitoo maa e cellal';
      default:        return 'Choisissez un module ci-dessous';
    }
  }
}
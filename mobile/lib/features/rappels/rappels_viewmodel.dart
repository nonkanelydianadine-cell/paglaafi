import 'package:flutter/foundation.dart';
import '../../data/models/rappel.dart';
import '../../data/models/profil_local.dart';
import '../../data/repositories/rappel_repository.dart';
import '../../data/repositories/profil_repository.dart';
import '../../data/services/notification_service.dart';

class RappelsViewModel extends ChangeNotifier {
  final RappelRepository _rappelRepo;
  final ProfilRepository _profilRepo;
  RappelsViewModel(this._rappelRepo, this._profilRepo);

  List<Rappel> _rappels = [];
  ProfilLocal? _profil;
  bool _chargement = false;
  bool _enregistrement = false;
  String? _erreur;

  List<Rappel> get rappels => _rappels;
  ProfilLocal? get profil => _profil;
  bool get chargement => _chargement;
  bool get enregistrement => _enregistrement;
  String? get erreur => _erreur;

  Future<void> charger() async {
    _chargement = true;
    _erreur = null;
    notifyListeners();

    try {
      _profil = await _profilRepo.getProfil();

      if (_profil == null) {
        _erreur = 'Aucun profil trouvé';
        _rappels = [];
        _chargement = false;
        notifyListeners();
        return;
      }

      _rappels = await _rappelRepo.getRappels(_profil!.id);

      if (_rappels.isEmpty) {
        await _rappelRepo.creerRappelsParDefaut(_profil!.id);
        _rappels = await _rappelRepo.getRappels(_profil!.id);
      }
    } catch (e, stackTrace) {
      debugPrint('RappelsViewModel.charger() erreur : $e');
      debugPrint(stackTrace.toString());
      _erreur = 'Erreur de chargement: $e';
      _rappels = [];
    } finally {
      _chargement = false;
      notifyListeners();
    }
  }

  /// Active ou désactive un rappel
  Future<void> toggleRappel(Rappel rappel) async {
    final nouvelEtat = !rappel.actif;
    
    await _rappelRepo.toggleActif(rappel.id!, nouvelEtat);

    final index = _rappels.indexWhere((r) => r.id == rappel.id);
    if (index != -1) {
      _rappels[index] = _rappels[index].copyWith(actif: nouvelEtat);
    }

    if (nouvelEtat && rappel.id != null) {
      await NotificationService.instance.programmerRappel(_rappels[index]);
    } else if (rappel.id != null) {
      await NotificationService.instance.annulerRappel(rappel.id!);
    }

    notifyListeners();
  }

  /// Change la fréquence d'un rappel spécifique
  Future<void> changerFrequenceRappel(int rappelId, String frequence) async {
    final index = _rappels.indexWhere((r) => r.id == rappelId);
    if (index == -1) return;

    final rappel = _rappels[index];
    
    await _rappelRepo.mettreAJourRappel(
      rappelId,
      frequence: frequence,
      heure: rappel.heureEnvoi,
    );

    _rappels[index] = rappel.copyWith(frequence: frequence);
    notifyListeners();
  }

  /// Change l'heure d'un rappel spécifique
  Future<void> changerHeureRappel(int rappelId, String heure) async {
    final index = _rappels.indexWhere((r) => r.id == rappelId);
    if (index == -1) return;

    final rappel = _rappels[index];
    
    await _rappelRepo.mettreAJourRappel(
      rappelId,
      frequence: rappel.frequence,
      heure: heure,
    );

    _rappels[index] = rappel.copyWith(heureEnvoi: heure);
    notifyListeners();
  }

  /// Enregistre tous les rappels actifs et reprogramme les notifications
  Future<void> enregistrer() async {
    _enregistrement = true;
    notifyListeners();

    try {
      for (final rappel in _rappels) {
        if (rappel.id == null) {
          await _rappelRepo.inserer(rappel);
        } else {
          await _rappelRepo.mettreAJour(rappel);
        }
      }
      
      await NotificationService.instance.reprogrammerTous(_rappels);
      debugPrint('RappelsViewModel : ${_rappels.where((r) => r.actif).length} rappels programmés');
    } catch (e) {
      debugPrint('RappelsViewModel.enregistrer() erreur : $e');
    } finally {
      _enregistrement = false;
      notifyListeners();
    }
  }

  static String labelType(String type, String langue) {
    const labels = {
      'auto_examen': {
        'fr': 'Auto-examen mensuel',
        'moore': 'Auto-examen mens-mens',
      },
      'consultation': {
        'fr': 'Consultation médicale',
        'moore': 'Kẽng laafi rogem',
      },
      'info': {
        'fr': 'Lire une info santé',
        'moore': 'Karm laafi kõ',
      },
    };
    return labels[type]?[langue] ?? labels[type]?['fr'] ?? type;
  }

  static String labelFrequence(String frequence, String langue) {
    const labels = {
      'quotidien': {'fr': 'Quotidien',    'moore': 'Rasem'},
      'hebdo':     {'fr': 'Hebdomadaire', 'moore': 'Vʋʋs fãa'},
      'mensuel':   {'fr': 'Mensuel',      'moore': 'Yʋʋm-vʋʋs'},
    };
    return labels[frequence]?[langue] ?? labels[frequence]?['fr'] ?? frequence;
  }
}
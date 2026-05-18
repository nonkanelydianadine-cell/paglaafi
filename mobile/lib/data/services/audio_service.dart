import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  AudioPlayer? _player;
  String? _cheminCourant;
  bool _enLecture = false;

  bool get enLecture => _enLecture;

  Future<void> initialiser() async {
    _player = AudioPlayer();
    _player!.playerStateStream.listen((state) {
      _enLecture = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _enLecture = false;
        _cheminCourant = null;
      }
    });
  }

  Future<bool> _assetExiste(String chemin) async {
    try {
      final data = await rootBundle.load(chemin);
      return data.lengthInBytes > 0;
    } catch (_) {
      return false;
    }
  }

  Future<void> jouer(String chemin) async {
    if (_player == null) await initialiser();
    try {
      // Vérifier que le fichier audio existe et n'est pas vide
      if (!await _assetExiste(chemin)) {
        debugPrint('AudioService : fichier introuvable ou vide : "$chemin"');
        return;
      }
      // Si même fichier en cours → on arrête
      if (_cheminCourant == chemin && _enLecture) {
        await arreter();
        return;
      }
      if (_enLecture) await arreter();
      _cheminCourant = chemin;
      await _player!.setAsset(chemin);
      await _player!.play();
      _enLecture = true;
    } catch (e) {
      debugPrint('AudioService erreur : $e');
      _enLecture = false;
      _cheminCourant = null;
    }
  }

  Future<void> jouerParLangue({
    required String langue,
    String? audioFr,
    String? audioMoore,
    String? audioDioula,
    String? audioFulfude,
  }) async {
    String? chemin;
    switch (langue) {
      case 'moore':   chemin = audioMoore   ?? audioFr; break;
      case 'dioula':  chemin = audioDioula  ?? audioFr; break;
      case 'fulfude': chemin = audioFulfude ?? audioFr; break;
      default:        chemin = audioFr;
    }
    if (chemin != null && chemin.isNotEmpty) {
      await jouer(chemin);
    }
  }

  Future<void> arreter() async {
    await _player?.stop();
    _enLecture = false;
    _cheminCourant = null;
  }

  Future<void> dispose() async {
    await _player?.dispose();
    _player = null;
  }
}
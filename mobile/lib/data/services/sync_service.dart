import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../repositories/stat_repository.dart';

class SyncService {
  final StatRepository _statRepo;
  SyncService(this._statRepo);

  // À remplacer par l'URL réelle de votre backend Django
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<bool> estConnecte() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Future<void> synchroniserSiConnecte() async {
    if (!await estConnecte()) return;
    await _envoyerStats();
  }

  Future<void> _envoyerStats() async {
    try {
      final stats = await _statRepo.getStatsNonSync();
      if (stats.isEmpty) return;

      final payload = {
        'stats': stats.map((s) => {
          'periode': s.periode,
          'nb_evaluations': s.nbEvaluations,
          'nb_faible': s.nbFaible,
          'nb_modere': s.nbModere,
          'nb_eleve': s.nbEleve,
        }).toList(),
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/stats/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final ids = stats
            .where((s) => s.id != null)
            .map((s) => s.id!)
            .toList();
        await _statRepo.marquerSynchronise(ids);
        debugPrint('SyncService : ${stats.length} stats envoyées');
      }
    } catch (e) {
      // Échec silencieux, retry au prochain lancement
      debugPrint('SyncService erreur : $e');
    }
  }
}
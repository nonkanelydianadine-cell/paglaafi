import '../database/database_helper.dart';
import '../models/centre_sante.dart';
import '../../core/constants/db_constants.dart';

class CentreRepository {
  final DatabaseHelper _db;
  CentreRepository(this._db);

  Future<List<CentreSante>> getCentres({String? ville}) async {
    final rows = await _db.getAll(
      DbConstants.tableCentre,
      where: ville != null ? 'actif = 1 AND ville = ?' : 'actif = 1',
      whereArgs: ville != null ? [ville] : null,
      orderBy: 'distance_km ASC',
    );
    return rows.map((r) => CentreSante.fromMap(r)).toList();
  }

  Future<List<CentreSante>> rechercher(String texte) async {
    final q = '%$texte%';
    final rows = await _db.rawQuery(
      'SELECT * FROM ${DbConstants.tableCentre} '
      'WHERE actif = 1 AND (nom LIKE ? OR adresse LIKE ? OR ville LIKE ?) '
      'ORDER BY distance_km ASC',
      [q, q, q],
    );
    return rows.map((r) => CentreSante.fromMap(r)).toList();
  }

  Future<List<String>> getVilles() async {
    final rows = await _db.rawQuery(
      'SELECT DISTINCT ville FROM ${DbConstants.tableCentre} '
      'WHERE actif = 1 ORDER BY ville ASC',
    );
    return rows.map((r) => r['ville'] as String).toList();
  }
}

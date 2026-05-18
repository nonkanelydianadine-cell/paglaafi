import '../database/database_helper.dart';
import '../models/stat_anonyme.dart';
import '../../core/constants/db_constants.dart';

class StatRepository {
  final DatabaseHelper _db;
  StatRepository(this._db);

  Future<List<StatAnonyme>> getStatsNonSync() async {
    final rows = await _db.getAll(
      DbConstants.tableStat,
      where: 'synchronise = 0',
      orderBy: 'periode DESC',
    );
    return rows.map((r) => StatAnonyme.fromMap(r)).toList();
  }

  Future<void> marquerSynchronise(List<int> ids) async {
    for (final id in ids) {
      await _db.update(
        DbConstants.tableStat,
        {'synchronise': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }
}
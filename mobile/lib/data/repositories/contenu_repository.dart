import '../database/database_helper.dart';
import '../models/contenu_educatif.dart';
import '../models/etape_auto_examen.dart';
import '../../core/constants/db_constants.dart';

class ContenuRepository {
  final DatabaseHelper _db;
  ContenuRepository(this._db);

  Future<List<ContenuEducatif>> getContenus(String categorie) async {
    final rows = await _db.getAll(
      DbConstants.tableContenu,
      where: 'categorie = ?',
      whereArgs: [categorie],
      orderBy: 'ordre ASC',
    );
    return rows.map((r) => ContenuEducatif.fromMap(r)).toList();
  }

  Future<List<EtapeAutoExamen>> getEtapes() async {
    final rows = await _db.getAll(
      DbConstants.tableEtape,
      orderBy: 'numero_etape ASC',
    );
    return rows.map((r) => EtapeAutoExamen.fromMap(r)).toList();
  }
}
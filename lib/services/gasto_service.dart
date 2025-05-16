import 'package:easy_growing/models/gasto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GastoService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    String path = join(await getDatabasesPath(), 'gastos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE gastos(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          descripcion TEXT,
          categoria TEXT,
          monto REAL,
          fecha TEXT,
          id_usuario   INTEGER
        )
      ''');
      },
    );
  }

  //  todas las operaciones del crud

  Future<int> agregarGasto(Gasto gasto) async {
    final db = await database;
    return await db.insert('gastos', gasto.toMap());
  }

  // Función para editar un gasto
  Future<int> editarGasto(Gasto gasto) async {
    final db = await database;
    return await db.update(
      'gastos',
      gasto.toMap(),
      where: 'id = ?',
      whereArgs: [gasto.id],
    );
  }

  Future<int> eliminarGasto(int id) async {
    final db = await database;
    return await db.delete('gastos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Gasto>> obtenerGastos() async {
    final prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('usuarioId');

    if (usuarioId == null) {
      return [];
    }

    final db = await database;

    // filtramos por el id del usuario
    final List<Map<String, dynamic>> maps = await db.query(
      'gastos',
      where: 'id_usuario = ?',
      whereArgs: [usuarioId],
    );

    return List.generate(maps.length, (i) {
      return Gasto.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> obtenerMontosPorCategoria() async {
    final prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('usuarioId');
    final db = await database;

    if (usuarioId == null) {
      return [];
    }

    return await db.rawQuery(
      'SELECT categoria, SUM(monto) as total FROM gastos WHERE id_usuario = ? GROUP BY categoria',
      [usuarioId],
    );
  }
}

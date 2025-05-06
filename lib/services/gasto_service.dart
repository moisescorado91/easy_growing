import 'package:easy_growing/models/gasto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
          fecha TEXT
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
    print("info llego");
    print(gasto);
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
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('gastos');

    return List.generate(maps.length, (i) {
      return Gasto.fromMap(maps[i]);
    });
  }
}

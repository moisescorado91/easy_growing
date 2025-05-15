import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "Gastos.db";
  static final _databaseVersion = 1;

  static final tableGastos = 'gastos';
  static final tableUsuario = 'usuario';

  // Columnas para gastos
  static final columnId = '_id';
  static final columnDescripcion = 'descripcion';
  static final columnCategoria = 'categoria';
  static final columnMonto = 'monto';
  static final columnFecha = 'fecha';
  static final columnGastoUsuarioId = 'id_usuario';

  // Columnas para  usuarios
  static final columnUsuarioId = 'id';
  static final columnNombre = 'usuario';
  static final columnCorreo = 'password';

  // Hace que la clase sea un Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Inicializa la base de datos
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Crea las tablas de gastos y usuario
  Future _onCreate(Database db, int version) async {
    // Crear tabla de gastos
    await db.execute('''
      CREATE TABLE $tableGastos (
        $columnId INTEGER PRIMARY KEY,
        $columnDescripcion TEXT NOT NULL,
        $columnCategoria TEXT NOT NULL,
        $columnMonto REAL NOT NULL,
        $columnFecha TEXT NOT NULL,
        $columnGastoUsuarioId INTEGER,
        FOREIGN KEY ($columnGastoUsuarioId) REFERENCES $tableUsuario ($columnUsuarioId)
      )
    ''');

    // Crear tabla de usuario
    await db.execute('''
      CREATE TABLE $tableUsuario (
        $columnUsuarioId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnNombre TEXT NOT NULL,
        $columnCorreo TEXT NOT NULL
      )
    ''');

    // insertamos un usuario de prueba
    await db.insert(tableUsuario, {
      columnNombre: 'developer',
      columnCorreo: 'developer',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    await db.insert(tableUsuario, {
      columnNombre: 'moises',
      columnCorreo: 'moises',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    await db.insert(tableUsuario, {
      columnNombre: 'jose',
      columnCorreo: 'jose',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    await db.insert(tableUsuario, {
      columnNombre: 'lina',
      columnCorreo: 'lina',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    await db.insert(tableUsuario, {
      columnNombre: 'alexandra',
      columnCorreo: 'alexandra',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    await db.insert(tableUsuario, {
      columnNombre: 'luis',
      columnCorreo: 'luis',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /**
 * todas las operaciones sobre la tabla gastos
 */
  // nuevo gasto
  Future<int> insertGasto(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableGastos, row);
  }

  // Obtener toda las filas
  Future<List<Map<String, dynamic>>> queryAllGastos() async {
    Database db = await instance.database;
    return await db.query(tableGastos);
  }

  // Obtener gasto por ID
  Future<Map<String, dynamic>?> queryGastoById(int id) async {
    Database db = await instance.database;
    var res = await db.query(
      tableGastos,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    return res.isNotEmpty ? res.first : null;
  }

  // Actualizar gasto
  Future<int> updateGasto(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(
      tableGastos,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Eliminar gasto
  Future<int> deleteGasto(int id) async {
    Database db = await instance.database;
    return await db.delete(
      tableGastos,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  /**
   * OPERACIONES SOBRE LA TABLA USUARIO
   */
  // registrar usuario
  Future<int> insertUsuario(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableUsuario, row);
  }

  // mostrar todos los usuarios
  Future<List<Map<String, dynamic>>> queryAllUsuarios() async {
    Database db = await instance.database;
    return await db.query(tableUsuario);
  }

  // Buscar por id
  Future<Map<String, dynamic>?> queryUsuarioById(int id) async {
    Database db = await instance.database;
    var res = await db.query(
      tableUsuario,
      where: '$columnUsuarioId = ?',
      whereArgs: [id],
    );
    return res.isNotEmpty ? res.first : null;
  }

  // Actualizar usuario
  Future<int> updateUsuario(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnUsuarioId];
    return await db.update(
      tableUsuario,
      row,
      where: '$columnUsuarioId = ?',
      whereArgs: [id],
    );
  }

  // Eliminar usuario
  Future<int> deleteUsuario(int id) async {
    Database db = await instance.database;
    return await db.delete(
      tableUsuario,
      where: '$columnUsuarioId = ?',
      whereArgs: [id],
    );
  }

  // validamos credenciales
  Future<Map<String, dynamic>?> queryUsuarioByCredentials(
    String usuario,
    String password,
  ) async {
    Database db = await instance.database;
    var res = await db.query(
      tableUsuario,
      where: '$columnNombre = ? AND $columnCorreo = ?',
      whereArgs: [usuario, password],
    );

    return res.isNotEmpty ? res.first : null;
  }
}

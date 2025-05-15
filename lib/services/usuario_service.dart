import 'package:easy_growing/db/database_helper.dart';
import 'package:easy_growing/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

// creamos un servicio que consuma todas las operaciones sobre la tabla usuarios
class UsuarioService {
  // Obtener todos los usuarios
  Future<List<Usuario>> obtenerUsuarios() async {
    final usuariosMap = await DatabaseHelper.instance.queryAllUsuarios();
    return usuariosMap
        .map((usuarioMap) => Usuario.fromMap(usuarioMap))
        .toList();
  }

  Future<Usuario?> obtenerUsuarioPorId(int id) async {
    final usuarioMap = await DatabaseHelper.instance.queryUsuarioById(id);
    if (usuarioMap != null) {
      return Usuario.fromMap(usuarioMap);
    }
    return null;
  }

  /**
 * todas las operaciones del crud
 */
  // Agregar un nuevo usuario
  Future<int> agregarUsuario(Usuario usuario) async {
    return await DatabaseHelper.instance.insertUsuario(usuario.toMap());
  }

  Future<int> actualizarUsuario(Usuario usuario) async {
    return await DatabaseHelper.instance.updateUsuario(usuario.toMap());
  }

  Future<int> eliminarUsuario(int id) async {
    return await DatabaseHelper.instance.deleteUsuario(id);
  }

  // Método que valida las credenciales
  Future<Usuario?> validarUsuario(String username, String password) async {
    final usuarioMap = await DatabaseHelper.instance.queryUsuarioByCredentials(
      username,
      password,
    );

    if (usuarioMap != null) {
      return Usuario.fromMap(usuarioMap);
    }
    return null;
  }

  Future<Usuario?> obtenerPerfil() async {
    final prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('usuarioId');
    if (usuarioId == null) {
      return null;
    }

    final usuarioMap = await DatabaseHelper.instance.queryUsuarioById(
      usuarioId,
    );
    if (usuarioMap != null) {
      return Usuario.fromMap(usuarioMap);
    }
    return null;
  }
}

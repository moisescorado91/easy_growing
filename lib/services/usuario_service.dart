import 'package:easy_growing/db/database_helper.dart';
import 'package:easy_growing/models/usuario.dart';

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
    // Consultamos el usuario directamente por el nombre de usuario y la contraseña
    final usuarioMap = await DatabaseHelper.instance.queryUsuarioByCredentials(
      username,
      password,
    );

    // Si encontramos un usuario, lo retornamos
    if (usuarioMap != null) {
      return Usuario.fromMap(usuarioMap);
    }

    // Si no se encuentra, retornamos null
    return null;
  }
}

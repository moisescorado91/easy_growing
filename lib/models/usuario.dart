/**
 * creamos un modelo que es la representacion de la tabla de la base de
 * datos creada
 */

class Usuario {
  int? id;
  String usuario;
  String password;

  Usuario({this.id, required this.usuario, required this.password});

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] != null ? map['id'] as int : null,
      usuario: map['usuario'] as String,
      password: map['password'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'usuario': usuario, 'password': password};
  }

  @override
  String toString() {
    return 'Usuario(id: $id, usuario: $usuario, password: $password)';
  }
}

/**
 * creamos un modelo llamado gasto que es la representacion de la tabla
 * antes creada
 */

class Gasto {
  final int? id;
  final String descripcion;
  final String categoria;
  final double monto;
  final String fecha;
  final int idUsuario; 

  Gasto({
    this.id,
    required this.descripcion,
    required this.categoria,
    required this.monto,
    required this.fecha,
    required this.idUsuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'categoria': categoria,
      'monto': monto,
      'fecha': fecha,
      'id_usuario': idUsuario,
    };
  }

  factory Gasto.fromMap(Map<String, dynamic> map) {
    return Gasto(
      id: map['id'],
      descripcion: map['descripcion'],
      categoria: map['categoria'],
      monto: map['monto'],
      fecha: map['fecha'],
      idUsuario: map['id_usuario'], 
    );
  }

  @override
  String toString() {
    return 'Gasto{id: $id, descripcion: $descripcion, categoria: $categoria, monto: \$${monto.toStringAsFixed(2)}, fecha: $fecha, idUsuario: $idUsuario}';
  }
}



// class Gasto {
//   final int? id;
//   final String descripcion;
//   final String categoria;
//   final double monto;
//   final String fecha;

//   Gasto({this.id, required this.descripcion, required this.categoria, required this.monto, required this.fecha});
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'descripcion': descripcion,
//       'categoria': categoria,
//       'monto': monto,
//       'fecha': fecha,
//     };
//   }

//   factory Gasto.fromMap(Map<String, dynamic> map) {
//     return Gasto(
//       id: map['id'],
//       descripcion: map['descripcion'],
//       categoria: map['categoria'],
//       monto: map['monto'],
//       fecha: map['fecha'],
//     );
//   }

//   @override
//   String toString() {
//     return 'Gasto{id: $id, descripcion: $descripcion, categoria: $categoria, monto: \$${monto.toStringAsFixed(2)}, fecha: $fecha}';
//   }
// }

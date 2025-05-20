class Municipio {
  final int id;
  final String nombre;
  final int estadoId;

  Municipio({required this.id, required this.nombre, required this.estadoId});

  factory Municipio.fromJson(Map<String, dynamic> json) {
    return Municipio(id: json['id'], nombre: json['nombre'], estadoId: json['estado_id']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'estado_id': estadoId};
  }
}

class Parking {
  final int id;
  final String nombre;
  final String? direccion;
  final double latitud;
  final double longitud;
  final int estadoId;
  final int municipioId;
  final String estado;
  final String municipio;

  Parking({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.latitud,
    required this.longitud,
    required this.estadoId,
    required this.municipioId,
    required this.estado,
    required this.municipio,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      latitud: double.tryParse(json['latitud'].toString()) ?? 0.0,
      longitud: double.tryParse(json['longitud'].toString()) ?? 0.0,
      estadoId: json['estado_id'],
      municipioId: json['municipio_id'],
      estado: json['estado']['nombre'],
      municipio: json['municipio']['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'latitud': latitud,
      'longitud': longitud,
      'estado_id': estadoId,
      'municipio_id': municipioId,
      'estado': estado,
      'municipio': municipio,
    };
  }
}

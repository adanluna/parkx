import 'package:parkx/models/parking.dart';

class Estado {
  final int id;
  final String nombre;
  final List<Parking> estacionamientos;

  Estado({required this.id, required this.nombre, required this.estacionamientos});

  factory Estado.fromJson(Map<String, dynamic> json) {
    return Estado(
      id: json['estado']['id'],
      nombre: json['estado']['nombre'],
      estacionamientos: (json['estacionamientos'] as List).map((e) => Parking.fromJson(e)).toList(),
    );
  }
}

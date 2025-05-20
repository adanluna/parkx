import 'pregunta.dart';

class PreguntaSeccion {
  final int id;
  final String nombre;
  final List<Pregunta> preguntas;

  PreguntaSeccion({required this.id, required this.nombre, required this.preguntas});

  factory PreguntaSeccion.fromJson(Map<String, dynamic> json) {
    return PreguntaSeccion(id: json['id'], nombre: json['nombre'], preguntas: (json['preguntas'] as List).map((e) => Pregunta.fromJson(e)).toList());
  }
}

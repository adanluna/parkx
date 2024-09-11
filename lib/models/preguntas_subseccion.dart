import 'package:parkx/models/pregunta.dart';

class PreguntasSubSeccion {
  String nombre;
  List<Pregunta>? preguntas;

  PreguntasSubSeccion({this.nombre = '', this.preguntas});

  factory PreguntasSubSeccion.fromJSON(Map<String, dynamic> json) {
    late List<Pregunta> preguntas = <Pregunta>[];

    if (json['preguntasFrecuentes'] != null) {
      json['preguntasFrecuentes'].forEach((json) {
        preguntas.add(Pregunta.fromJSON(json));
      });
    }

    return PreguntasSubSeccion(
      nombre: json["nombre"],
      preguntas: preguntas,
    );
  }
}

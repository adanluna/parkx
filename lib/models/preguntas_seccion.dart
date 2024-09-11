import 'package:parkx/models/preguntas_subseccion.dart';

class PreguntasSeccion {
  String nombre;
  List<PreguntasSubSeccion>? subsecciones;

  PreguntasSeccion({this.nombre = '', this.subsecciones});

  factory PreguntasSeccion.fromJSON(Map<String, dynamic> json) {
    late List<PreguntasSubSeccion> subsecciones = <PreguntasSubSeccion>[];

    if (json['subSecciones'] != null) {
      json['subSecciones'].forEach((json) {
        subsecciones.add(PreguntasSubSeccion.fromJSON(json));
      });
    }

    return PreguntasSeccion(
      nombre: json["nombre"],
      subsecciones: subsecciones,
    );
  }
}

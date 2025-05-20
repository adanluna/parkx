class Pregunta {
  final int id;
  final String titulo;
  final String texto;
  final int seccionId;

  Pregunta({required this.id, required this.titulo, required this.texto, required this.seccionId});

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(id: json['id'], titulo: json['titulo'], texto: json['texto'], seccionId: json['pregunta_seccion_id']);
  }
}

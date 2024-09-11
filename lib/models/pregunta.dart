class Pregunta {
  String texto;
  String titulo;

  Pregunta({this.texto = '', this.titulo = ''});

  factory Pregunta.fromJSON(Map<String, dynamic> json) {
    return Pregunta(
      texto: json["texto"],
      titulo: json["titulo"],
    );
  }
}

class Transaccion {
  int id;
  String? tipo;
  double? monto;
  DateTime? fechaCreacion;

  Transaccion({this.id = 0, this.tipo = '', this.monto = 0, this.fechaCreacion});

  factory Transaccion.fromJSON(Map<String, dynamic> json) {
    return Transaccion(id: json["id"], tipo: json['tipo'], monto: json['monto'].toDouble(), fechaCreacion: DateTime.parse(json['created_at']));
  }
}

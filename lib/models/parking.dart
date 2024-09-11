class Parking {
  int id;
  int distance;
  int lat;
  int lng;
  String name;

  Parking({this.id = 0, this.distance = 0, this.lat = 0, this.lng = 0, this.name = ''});

  factory Parking.fromJSON(Map<String, dynamic> json) {
    return Parking(
      id: json["id"],
      distance: json["distancia"],
      lat: json["lat"],
      lng: json["lng"],
      name: json["nombre"],
    );
  }
}

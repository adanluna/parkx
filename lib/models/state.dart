class StateModel {
  int id;
  String name;

  StateModel({this.id = 0, this.name = ''});

  factory StateModel.fromJSON(Map<String, dynamic> json) {
    return StateModel(
      id: json["id"],
      name: json["nombre"],
    );
  }
}

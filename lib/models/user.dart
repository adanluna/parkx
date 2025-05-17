class User {
  int id;
  String username;
  String firstName;
  String lastName;
  String email;
  bool activated;

  User({this.id = 0, this.username = '', this.firstName = '', this.lastName = '', this.email = '', this.activated = false});

  factory User.fromJSON(Map<String, dynamic> json) => User(
      id: json["id"],
      username: json["email"],
      firstName: json["name"],
      lastName: json["apellidos"],
      email: json["email"],
      activated: json["is_verified"]);
}

class User {
  int id;
  String login;
  String username;
  String firstName;
  String lastName;
  String email;
  bool activated;

  User({this.id = 0, this.login = '', this.username = '', this.firstName = '', this.lastName = '', this.email = '', this.activated = false});

  factory User.fromJSON(Map<String, dynamic> json) => User(
      id: json["id"],
      login: json["login"],
      username: json["login"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      activated: json["activated"]);
}

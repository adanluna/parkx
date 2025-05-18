class User {
  int id;
  String username;
  String firstName;
  String lastName;
  String email;
  bool activated;
  double balance;

  User({this.id = 0, this.username = '', this.firstName = '', this.lastName = '', this.email = '', this.activated = false, this.balance = 0.0});

  factory User.fromJSON(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["email"],
        firstName: json["name"],
        lastName: json["apellidos"],
        email: json["email"],
        activated: (json["is_verified"] == 1),
        balance: double.tryParse(json["balance"].toString()) ?? 0.0,
      );
}

class Wallet {
  String id;
  int balance;

  Wallet({this.id = '', this.balance = 0});

  factory Wallet.fromJSON(Map<String, dynamic> json) {
    return Wallet(
      id: json["id"],
      balance: json["balance"],
    );
  }
}

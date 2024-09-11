import 'package:parkx/models/credit_card.dart';

class Wallet {
  String id;
  int balance;
  String name;
  List<CreditCard>? cards;

  Wallet({this.id = '', this.balance = 0, this.name = '', this.cards});

  factory Wallet.fromJSON(Map<String, dynamic> json) {
    late List<CreditCard> cards = <CreditCard>[];

    if (json['cards'] != null) {
      json['cards'].forEach((json) {
        cards.add(CreditCard.fromJSON(json));
      });
    }

    return Wallet(
      id: json["id"],
      balance: json["balance"],
      name: json["name"],
      cards: cards,
    );
  }
}

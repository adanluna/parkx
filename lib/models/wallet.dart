import 'package:parkx/models/credit_card.dart';
import 'package:intl/intl.dart';

class Wallet {
  int id;
  double balance;
  List<CreditCard>? cards;

  Wallet({this.id = 0, this.balance = 0, this.cards});

  factory Wallet.fromJSON(Map<String, dynamic> json) {
    late List<CreditCard> cards = <CreditCard>[];

    if (json['cards'] != null) {
      json['cards'].forEach((json) {
        cards.add(CreditCard.fromJSON(json));
      });
    }

    double balance = 0.0;
    if (json["balance"] is num) {
      balance = (json["balance"] as num).toDouble();
    } else if (json["balance"] is String) {
      balance = double.tryParse(json["balance"]) ?? 0.0;
    }

    return Wallet(id: json["id"], balance: balance, cards: cards);
  }

  String get formattedBalance => NumberFormat.currency(locale: 'es_MX', symbol: '', decimalDigits: 0).format(balance).trim();
}

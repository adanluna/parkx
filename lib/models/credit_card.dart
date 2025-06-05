class CreditCard {
  String id;
  String brand;
  int expMonth;
  int expYear;
  String last4;

  CreditCard({this.id = '', this.brand = '', this.expMonth = 0, this.expYear = 0, this.last4 = ''});

  factory CreditCard.fromJSON(Map<String, dynamic> json) => CreditCard(
    id: json["id"],
    brand: json["card"]["brand"],
    expMonth: json["card"]["exp_month"],
    expYear: json["card"]["exp_year"],
    last4: json["card"]["last4"],
  );
}

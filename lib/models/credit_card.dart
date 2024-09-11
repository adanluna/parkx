class CreditCard {
  //int id;
  String brand;
  int expMonth;
  int expYear;
  String last4;

  CreditCard({this.brand = '', this.expMonth = 0, this.expYear = 0, this.last4 = ''});

  factory CreditCard.fromJSON(Map<String, dynamic> json) => CreditCard(
        //id: json["id"],
        brand: json["brand"],
        expMonth: json["expMonth"],
        expYear: json["expYear"],
        last4: json["last4"],
      );
}

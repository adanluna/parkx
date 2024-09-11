class WalletTransfer {
  String bankCode;
  String bankName;
  String clabe;
  String country;
  String currency;

  WalletTransfer({
    this.bankCode = '',
    this.bankName = '',
    this.clabe = '',
    this.country = '',
    this.currency = '',
  });

  factory WalletTransfer.fromJSON(Map<String, dynamic> json) {
    return WalletTransfer(
      bankCode: json["bankCode"],
      bankName: json["bankName"],
      clabe: json["clabe"],
      country: json["country"],
      currency: json["currency"],
    );
  }
}

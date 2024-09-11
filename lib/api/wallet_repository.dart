import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:parkx/api/config/api_base_helper.dart';
import 'package:parkx/api/config/api_exception.dart';
import 'package:parkx/models/user.dart';
import 'package:parkx/models/wallet.dart';
import 'package:parkx/models/wallet_transfer.dart';
import 'package:parkx/utils/account_manager.dart';

class WalletRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final User user = AccountManager.instance.user;

  Future<Wallet?> wallet() async {
    try {
      final response = await _helper.get(path: '/mobile/wallet');
      print(response);
      return Wallet.fromJSON(response);
    } on UnauthorizedException catch (_) {
      return null;
    }
  }

  Future<WalletTransfer?> getTransfer() async {
    try {
      final response = await _helper.get(path: '/mobile/wallet/funding-info');
      return WalletTransfer.fromJSON(response);
    } on UnauthorizedException catch (_) {
      return null;
    }
  }

  Future<bool> saveCreditCard() async {
    final response = await _helper.get(path: '/mobile/wallet/create-card-init');
    //{clientSecret: seti_1Px9sEDFtmWA3nAxYEpMu6Nt_secret_QonTwKqiOacZ0fa8q6bBQEjH0xVyvMG, customerSessionClientSecret: cuss_secret_QonTRwAn3zLIEEF7GyvNhln2xhTr3iwRo36KLiT8j4oKnSb}
    final clientSecret = response['clientSecret'];

    final billingDetails = BillingDetails(
      email: user.email,
    );

    try {
      await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );
      await Stripe.instance.confirmSetupIntent(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
        paymentIntentClientSecret: clientSecret,
      );
      return true;
    } on UnauthorizedException catch (_) {
      return false;
    }
  }
}

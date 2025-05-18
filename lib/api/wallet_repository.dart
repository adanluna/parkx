import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:parkx/api/config/api_base_helper.dart';
import 'package:parkx/models/user.dart';
import 'package:parkx/models/wallet.dart';
import 'package:parkx/models/wallet_transfer.dart';
import 'package:parkx/utils/account_manager.dart';

class WalletRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final User? user = AccountManager.instance.user;

  Future<Wallet?> wallet() async {
    try {
      final response = await _helper.get(path: '/wallets/${user!.id}');
      return Wallet.fromJSON(response);
    } catch (e) {
      return null;
    }
  }

  Future<WalletTransfer?> getTransfer() async {
    try {
      final response = await _helper.get(path: '/mobile/wallet/funding-info');
      return WalletTransfer.fromJSON(response);
    } catch (e) {
      return null;
    }
  }

  Future<bool> initOxxoPayment() async {
    try {
      final response = await _helper.get(path: '/mobile/wallet/payment/oxxo');
      //final clientSecret = response['clientSecret'];
      //final customerSessionClientSecret = response['customerSessionClientSecret'];
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> saveCreditCard() async {
    final response = await _helper.get(path: '/mobile/wallet/create-card-init');
    final clientSecret = response['clientSecret'];

    final billingDetails = BillingDetails(
      email: user?.email,
    );
    if (user?.email == null) {
      throw Exception('El usuario no tiene un correo electrónico registrado.');
    }
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
    } catch (e) {
      return false;
    }
  }
}

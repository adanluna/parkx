import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:parkx/api/config/api_base_helper.dart';
import 'package:parkx/models/user.dart';
import 'package:parkx/models/wallet.dart';
import 'package:parkx/models/wallet_transfer.dart';
import 'package:parkx/utils/account_manager.dart';

class WalletRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final User? user = AccountManager.instance.user;

  Future<Wallet> wallet() async {
    final response = await _helper.get(path: '/wallet');
    return Wallet.fromJSON(response['data']);
  }

  Future<WalletTransfer?> getTransfer() async {
    final response = await _helper.get(path: '/wallet/funding-info');
    return WalletTransfer.fromJSON(response);
  }

  Future<bool> deleteCard(String card) async {
    await _helper.post(path: '/stripe/delete-card', body: {'card': card});
    return true;
  }

  Future<String> saveCreditCard() async {
    final response = await _helper.get(path: '/stripe/create-intent-card');
    final clientSecret = response['data']['clientSecret'];

    final billingDetails = BillingDetails(
      name: (user?.name?.isNotEmpty ?? false) ? user!.name : 'Usuario Parkx',
      email: (user?.email.isNotEmpty ?? false) ? user!.email : 'soporte@parkx.mx',
    );
    try {
      await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(paymentMethodData: PaymentMethodData(billingDetails: billingDetails)),
      );

      await Stripe.instance.confirmSetupIntent(
        params: PaymentMethodParams.card(paymentMethodData: PaymentMethodData(billingDetails: billingDetails)),
        paymentIntentClientSecret: clientSecret,
      );
    } on StripeException catch (e) {
      return e.error.message!;
    } catch (e) {
      return ('$e');
    }
    return '';
  }

  Future<bool> addFunds({required String amount, required String cardId}) async {
    await _helper.post(path: '/stripe/payment', body: {'total': amount, 'card': cardId});
    return true;
  }

  Future<Map<String, dynamic>?> initiatePayment({
    required String amount,
    required String paymentMethod, // 'oxxo' o 'spei'
  }) async {
    try {
      final response = await _helper.post(path: '/stripe/create-payment-intent', body: {'amount': amount, 'method': paymentMethod});
      final dataStripe = response['data'];
      final clientSecret = dataStripe?['client_secret'];
      if (clientSecret == null) {
        throw Exception('No se pudo obtener el clientSecret de Stripe.');
      }

      final billingDetails = BillingDetails(
        name: (user?.name?.isNotEmpty ?? false) ? user!.name : 'Usuario Parkx',
        email: (user?.email.isNotEmpty ?? false) ? user!.email : 'soporte@parkx.mx',
      );

      if (paymentMethod == 'oxxo') {
        try {
          await Stripe.instance.createPaymentMethod(
            params: PaymentMethodParams.oxxo(paymentMethodData: PaymentMethodData(billingDetails: billingDetails)),
          );

          final paymentIntent = await Stripe.instance.confirmPayment(
            paymentIntentClientSecret: clientSecret,
            data: PaymentMethodParams.oxxo(paymentMethodData: PaymentMethodData(billingDetails: billingDetails)),
          );

          // Acceso correcto a nextAction y detalles de OXXO
          final nextAction = paymentIntent.nextAction;
          final nextActionMap = nextAction?.toJson();
          if (nextActionMap == null || nextActionMap['voucherURL'] == null || nextActionMap['expiration'] == null) {
            throw Exception('No se pudo obtener los detalles de OXXO.');
          }
          final data = {'clientSecret': clientSecret, 'voucherUrl': nextActionMap['voucherURL'], 'expiresAt': nextActionMap['expiration']};
          return data;
        } on StripeException catch (e) {
          print('StripeException: ${e.error.localizedMessage ?? e.error.message}');
          throw Exception(e.error.localizedMessage ?? e.error.message ?? 'Error de Stripe');
        } catch (e) {
          print('Error OXXO: $e');
          throw Exception('Error al procesar el pago OXXO: $e');
        }
      } else if (paymentMethod == 'spei') {
        try {
          final bankInstructions = dataStripe['next_action']?['display_bank_transfer_instructions'];
          if (bankInstructions == null) {
            throw Exception('No se pudo obtener las instrucciones bancarias.');
          }
          final speiDetails = bankInstructions['financial_addresses'].firstWhere((fa) => fa['type'] == 'spei', orElse: () => null)?['spei'];
          if (speiDetails == null) {
            throw Exception('No se pudo obtener los detalles de SPEI.');
          }
          final data = {
            'clientSecret': clientSecret,
            'clabe': speiDetails['clabe'],
            'bankName': speiDetails['bank_name'],
            'reference': bankInstructions['reference'],
            'amount': bankInstructions['amount_remaining'],
            'currency': bankInstructions['currency'],
            'hostedInstructionsUrl': bankInstructions['hosted_instructions_url'],
          };
          return data;
        } catch (e) {
          print('Error SPEI: $e');
          throw Exception('Error al procesar el pago SPEI: $e');
        }
      } else {
        throw Exception('Método de pago no soportado.');
      }
    } on StripeException catch (e) {
      print('StripeException: ${e.error.localizedMessage ?? e.error.message}');
      throw Exception(e.error.localizedMessage ?? e.error.message ?? 'Error de Stripe');
    } catch (e) {
      print('Error initiating payment: $e');
      throw Exception('Error iniciando el pago: $e');
    }
  }
}

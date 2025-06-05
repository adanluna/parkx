import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:parkx/api/wallet_repository.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

class OxxoAddScreen extends StatefulWidget {
  const OxxoAddScreen({super.key});

  static const routeName = '/oxxo_add';

  @override
  State<OxxoAddScreen> createState() => _OxxoAddScreenState();
}

class _OxxoAddScreenState extends State<OxxoAddScreen> {
  TextEditingController amountController = TextEditingController();
  bool validAmount = false;
  num amount = 0;
  num minAmount = 15;

  @override
  void initState() {
    amountController.text = '';
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Abona saldo',
        withBackButton: true,
        function: () {
          Navigator.of(context).pop('');
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Text('Efectivo en OXXO', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Text('Ingresa el monto en pesos', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: TextFormField(
                      controller: amountController,
                      textAlign: TextAlign.center,
                      style: AppTheme.theme.textTheme.bodyMedium,
                      decoration: const InputDecoration(hintText: "\$"),
                      inputFormatters: [
                        CurrencyInputFormatter(
                          leadingSymbol: CurrencySymbols.DOLLAR_SIGN,
                          useSymbolPadding: true,
                          mantissaLength: 0,
                          onValueChange: (num value) {
                            setState(() {
                              validAmount = (value >= minAmount) ? true : false;
                              amount = value;
                            });
                          },
                        ),
                      ],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'La cantidad mínima es de \$$minAmount pesos, además OXXO te cobrará una comisión extra.',
                      style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: ButtonSecondary(title: 'Generar referencia para abonar', function: () => _generateReference(context), active: validAmount),
            ),
          ],
        ),
      ),
    );
  }

  void _generateReference(BuildContext context) async {
    if (amount == 0 && validAmount == false) {
      showErrorDialog(context, message: 'Necesitas ingresar el monto a abonar.');
    } else if (!validAmount) {
      showErrorDialog(context, message: 'El monto mínimo para abonar es de \$$minAmount pesos.');
    } else {
      context.loaderOverlay.show();
      try {
        final walletRepository = WalletRepository();
        final paymentData = await walletRepository.initiatePayment(amount: amount.toString(), paymentMethod: 'oxxo');

        if (paymentData != null) {
          final voucherUrl = paymentData['voucherUrl'];
          final expiresAt = paymentData['expiresAt'];
          String expiresAtHuman = '';
          if (expiresAt != null) {
            final date = DateTime.fromMillisecondsSinceEpoch(expiresAt is int ? expiresAt * 1000 : int.parse(expiresAt.toString()) * 1000);
            expiresAtHuman = DateFormat('dd/MM/yyyy HH:mm').format(date);
          }

          Navigator.of(
            context,
          ).pushReplacementNamed('/oxxo_finish', arguments: {'voucherUrl': voucherUrl, 'expiresAt': expiresAtHuman, 'amount': amount.toString()});
        } else {
          showErrorDialog(context, message: 'No se pudo generar la referencia. Intenta de nuevo.');
        }
      } catch (error) {
        showErrorDialog(context, message: error is Exception && (error as dynamic).message != null ? (error as dynamic).message : error.toString());
      } finally {
        if (mounted) context.loaderOverlay.hide();
      }
    }
  }
}

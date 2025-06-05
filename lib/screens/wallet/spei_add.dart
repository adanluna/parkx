import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:parkx/api/wallet_repository.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';

class SpeiAddScreen extends StatefulWidget {
  const SpeiAddScreen({super.key});
  static const routeName = '/spei_add';

  @override
  State<SpeiAddScreen> createState() => _SpeiAddScreenState();
}

class _SpeiAddScreenState extends State<SpeiAddScreen> {
  late String amountString = '';
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
      appBar: const AppBarWidget(title: 'Abona saldo', withBackButton: false, function: null),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  'Transferencia por SPEI',
                  textAlign: TextAlign.center,
                  style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Ingresa el monto en pesos',
                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
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
                  'El monto mínimo para abonar es de \$$minAmount pesos.',
                  style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: ButtonSecondary(title: 'Generar Referencia', function: () => _generateReference(context), active: validAmount),
              ),
            ],
          ),
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
        final paymentData = await walletRepository.initiatePayment(amount: amount.toString(), paymentMethod: 'spei');

        if (paymentData != null) {
          final urlPayment = paymentData['hostedInstructionsUrl'];
          Navigator.of(context).pushReplacementNamed('/spei_finish', arguments: {'urlPayment': urlPayment, 'amount': amount.toString()});
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

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:parkx/api/wallet_repository.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/alert_box.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:parkx/utils/wallet_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CreditCardAddScreen extends StatefulWidget {
  const CreditCardAddScreen({super.key});
  static const routeName = '/credit_card_add';

  @override
  State<CreditCardAddScreen> createState() => _CreditCardAddScreenState();
}

class _CreditCardAddScreenState extends State<CreditCardAddScreen> {
  //CardSystemData? _cardSystemData;
  String numeroTarjeta = '';
  String fechaTarjeta = '';
  String ccv = '';
  final controller = CardFormEditController();

  @override
  void initState() {
    controller.addListener(update);
    super.initState();
  }

  void update() => setState(() {});

  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
            title: 'Agregar tarjeta',
            withBackButton: true,
            function: () {
              Navigator.of(context).pop('');
            }),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                color: AppTheme.accentColor,
                child: Container(
                  height: 150,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/credit_card.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10, left: 20, right: 20),
                child: CardFormField(
                  autofocus: true,
                  controller: controller,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: AlertBox(
                    text:
                        'Por tu seguridad realizaremos un cargo de centavos (menos de \$1 peso) a tu tarjeta. Este monto se reembolsará de automáticamente entre 1 y 1o días hábiles dependiendo de tu banco.'),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
                  child: ButtonSecondary(
                    title: 'Guardar tarjeta',
                    function: () => _saveCard(),
                    active: controller.details.complete,
                  )),
            ],
          ),
        ));
  }

  void _saveCard() async {
    context.loaderOverlay.show();

    WalletRepository().saveCreditCard().then((value) async {
      context.loaderOverlay.hide();

      // Update Wallet
      await getWallet(context);

      if (!mounted) return;

      if (value) {
        showAceptDialog(context, message: "Tarjeta guardada", onConfirm: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      } else {
        showErrorDialog(context, message: "No se pudo agregar tarjeta");
      }
    }, onError: (error) {
      context.loaderOverlay.hide();
      print(error);
      showErrorDialog(context, message: error.error.message);
    });
  }
}

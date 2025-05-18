import 'package:flutter/material.dart';
import 'package:parkx/models/credit_card.dart';
import 'package:parkx/providers/wallet_provider.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  static const routeName = '/wallet';

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  TextEditingController codigoController = TextEditingController();

  @override
  void dispose() {
    codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    showCupon(BuildContext context) async {
      await showGeneralDialog(
        barrierLabel: "Label",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.6),
        transitionDuration: const Duration(milliseconds: 300),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(child: Text('Abona saldo', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
                            ButtonSecondary(title: 'Efectivo en OXXO', function: _goOxxoAdd),
                            ButtonSecondary(title: 'Transferencia vía SPEI', function: _goSpeiAdd),
                            ButtonSecondary(title: 'Tarjeta de Crédito o Débito', function: _goPrepaidAdd)
                          ],
                        )))),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
    }

    return Scaffold(
        appBar: const AppBarWidget(title: 'Billetera', withBackButton: false, function: null),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Saldo en Prepago',
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                      ),
                      Text(
                        (walletProvider.wallet != null) ? "\$${walletProvider.wallet?.balance}" : '\$0.0',
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.white24,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ButtonSecondary(
                            title: 'Recargar Saldo',
                            function: () async {
                              await showCupon(context);
                            }),
                      ),
                      Text(
                        '¿Cómo recargar prepago?',
                        textAlign: TextAlign.center,
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
                      ),
                      Text(
                        'Abona con métodos diferentes en OXXO (Efectivo), SPEI (Transferencia) y Tarjetas (Débito y Crédito)',
                        textAlign: TextAlign.center,
                        style: AppTheme.theme.textTheme.bodySmall!.copyWith(fontSize: 11, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
              /*Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  'Pago predeterminado',
                  textAlign: TextAlign.center,
                  style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, mainAxisSize: MainAxisSize.max, children: [
                        const Text(
                          'Pago con Apple Pay',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        IconButton(padding: const EdgeInsets.all(0), icon: const Icon(Icons.arrow_forward_outlined), onPressed: _goPrepaidAdd),
                      ]),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.black26,
                        ),
                      ),
                    ],
                  )),*/
              Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 30),
                child: Text(
                  'Mis tarjetas',
                  textAlign: TextAlign.center,
                  style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              /*Column(
                children: walletProvider.wallet!.cards!.map((CreditCard card) {
                  return SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: AppTheme.primaryColor),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${card.brand.toUpperCase()}/----${card.last4}',
                                        style: const TextStyle(
                                            color: AppTheme.primaryColor, fontFamily: 'Roboto', fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Vencimiento: ${(card.expMonth < 10) ? '0' : ''}${card.expMonth}/${card.expYear}',
                                        style: const TextStyle(color: AppTheme.primaryColor, fontFamily: 'Roboto', fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_outlined,
                                    size: 25,
                                    color: AppTheme.primaryColor,
                                  ),
                                ],
                              ))),
                    ),
                  );
                }).toList(),
              ),*/
              ButtonSecondary(title: 'Añadir tarjeta', function: _goCreditCardAdd),
            ],
          ),
        )));
  }

  void _goOxxoAdd() {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed('/oxxo_add');
  }

  void _goSpeiAdd() {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed('/spei_add');
  }

  void _goCreditCardAdd() {
    Navigator.of(context).pushNamed('/credit_card_add');
  }

  void _goPrepaidAdd() {
    Navigator.of(context).pushNamed('/prepaid_add');
  }
}

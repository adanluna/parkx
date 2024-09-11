import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/alert_box.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/ol_item.dart';

class OxxoFinishScreen extends StatefulWidget {
  final num amount;
  const OxxoFinishScreen({super.key, required this.amount});
  static const routeName = '/oxxo_finish';

  @override
  State<OxxoFinishScreen> createState() => _OxxoFinishScreenState();
}

class _OxxoFinishScreenState extends State<OxxoFinishScreen> {
  late String amountString = '';

  @override
  void initState() {
    amountString = widget.amount.toCurrencyString(mantissaLength: 0);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(title: 'Oxxo referencia', withBackButton: false, function: null),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        'Monto a pagar en OXXO',
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 13, color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "\$$amountString",
                            style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                          ),
                          Text(
                            " + Comisión",
                            style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 18, color: Colors.white),
                          ),
                        ],
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
                        child: Text(
                          'Referencia 9300-2344-9819-09',
                          textAlign: TextAlign.center,
                          style:
                              AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.accentColor),
                        ),
                      ),
                      Text(
                        'OXXO de cobrará la comisión y no será parte de tu abono a tu cuenta de Parkx',
                        textAlign: TextAlign.center,
                        style: AppTheme.theme.textTheme.bodySmall!.copyWith(fontSize: 11, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  'Instrucciones de pago',
                  textAlign: TextAlign.center,
                  style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const Column(
                children: [
                  OrderedListItem('1', 'Acude a una tienda OXXO.'),
                  OrderedListItem('2', 'En caja indica que harás un pago por medio de OXXO Pay.'),
                  OrderedListItem('3', 'Muestra la referencia generada en la parte de arriba en color Aqua.'),
                  OrderedListItem('4', 'Haz el pago en efectivo.'),
                  OrderedListItem('5', 'Guarda el comprobante para alguna aclaración.'),
                  OrderedListItem('6', 'Listo!.'),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: AlertBox(text: 'Parkx te enviará una notificación de tu pago a tu correo electrónico.'),
              )
            ],
          ),
        )));
  }
}

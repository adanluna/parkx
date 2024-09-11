import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_outline.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:parkx/widgets/ol_item.dart';

class SpeiAddScreen extends StatefulWidget {
  const SpeiAddScreen({super.key});
  static const routeName = '/spei_add';

  @override
  State<SpeiAddScreen> createState() => _SpeiAddScreenState();
}

class _SpeiAddScreenState extends State<SpeiAddScreen> {
  late String amountString = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                  OrderedListItem('1',
                      '<b>Genera la CLABE Interbancaria</b> para dar de alta en tu banca electrónica o App por única vez y se utilizará para futuros abonos.'),
                  OrderedListItem('2',
                      'Da de alta la CLABE generada dentro de tu banca electrónica o App por única vez, utiliza como banco receptor a <b>STP Sistema de Transferencia y Pagos</b>.'),
                  OrderedListItem('3', 'Utiliza los <b>18 dígitos de la CLABE Interbancaria</b>.'),
                  OrderedListItem('4', '<b>Ingresa el monto</b> que deseas abonar a tu cuenta de Parkx.'),
                  OrderedListItem('5', '<b>Envía la transferencia</b>.'),
                  OrderedListItem('6', 'Listo!.'),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30), child: ButtonSecondary(title: 'Generar CLABE', function: _goFinish)),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ButtonOutline(title: 'Ya tengo CLABE y quiero verla', function: _goFinish)),
            ],
          ),
        )));
  }

  void _goFinish() {
    Navigator.of(context).pushNamed('/spei_finish');
  }
}

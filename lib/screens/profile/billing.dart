import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/border_decoration.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  static const routeName = '/billing';

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
            title: 'Datos fiscales',
            withBackButton: true,
            function: () {
              Navigator.of(context).pop();
            }),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Datos de facturación',
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: boxDecoration(),
                        child: Column(
                          children: [
                            _row('Razón Social', 'Gustavo Julián Lara Ruiz'),
                            _row('RFC', 'LARG8106196D5'),
                            _row('Domicilo', 'Cd Marbella 1205'),
                            _row('Colonia', 'Cumbres San Agustín'),
                            _row('Código', '64346'),
                            _row('Uso de CFDI', '03 Gastos en General'),
                            _row('Régimen Fiscal', 'Física con Actividad Empresarial'),
                          ],
                        )),
                    Padding(padding: const EdgeInsets.only(top: 20), child: ButtonSecondary(title: 'Editar datos fiscales', function: _goUpdate))
                  ],
                ))));
  }

  _goUpdate() {
    Navigator.of(context).pushNamed('/billing_update');
  }

  Widget _row(String text1, String text2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14, color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
            child: Text(
          text2,
          style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14, color: AppTheme.primaryColor),
        ))
      ],
    );
  }
}

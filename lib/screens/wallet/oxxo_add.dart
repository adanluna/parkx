import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

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
            }),
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
                      child: Text(
                        'Efectivo en OXXO',
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'Ingresa el monto en pesos',
                      style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: TextFormField(
                          controller: amountController,
                          textAlign: TextAlign.center,
                          style: AppTheme.theme.textTheme.bodyMedium,
                          decoration: const InputDecoration(
                            hintText: "\$",
                          ),
                          inputFormatters: [
                            CurrencyInputFormatter(
                                leadingSymbol: CurrencySymbols.DOLLAR_SIGN,
                                useSymbolPadding: true,
                                mantissaLength: 0,
                                onValueChange: (num value) {
                                  setState(() {
                                    validAmount = (value >= 15) ? true : false;
                                    amount = value;
                                  });
                                })
                          ],
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 30, left: 20, right: 20),
                      child: Text(
                        'La cantidad mínima es de \$15 pesos, además OXXO te cobrará una comisión de \$12 pesos.',
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: ButtonSecondary(
                    title: 'Generar referencia para abonar',
                    function: _goFinish,
                    active: validAmount,
                  )),
            ],
          ),
        ));
  }

  void _goFinish() {
    Navigator.of(context).pushReplacementNamed('/oxxo_finish', arguments: {'amount': amount});
  }
}

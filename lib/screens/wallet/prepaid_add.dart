import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_prepaid.dart';
import 'package:parkx/widgets/button_secondary.dart';

class PrepaidAddScreen extends StatefulWidget {
  const PrepaidAddScreen({super.key});

  static const routeName = '/prepaid_add';

  @override
  State<PrepaidAddScreen> createState() => _PrepaidAddScreenState();
}

class _PrepaidAddScreenState extends State<PrepaidAddScreen> {
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
            title: 'Abona a prepago',
            withBackButton: true,
            function: () {
              Navigator.of(context).pop('');
            }),
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Selecciona la cantidad a abonar a tu cuenta Parkx',
                      textAlign: TextAlign.center,
                      style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold, height: 1.1),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: const BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        'Recibe un 5% en tu primer abono',
                        style: AppTheme.theme.textTheme.bodyMedium!
                            .copyWith(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primaryColor, height: 1.1),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                      child: Container(
                          color: AppTheme.primaryColor,
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: SingleChildScrollView(
                              child: Padding(
                                  padding: const EdgeInsets.only(bottom: 130),
                                  child: Column(
                                    children: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                                        .map((index) => ButtonPrepaid(
                                            title: '\$${index * 100}', subtitle: '(\$${(index * 100) + 100} + \$5 GRATIS) ', function: () {}))
                                        .toList(),
                                  ))))),
                ],
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Método de pago:'),
                                  Text(
                                    'Apple Pay',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                            ButtonSecondary(title: 'Abonar a mi cuenta Parkx', function: _goFinish)
                          ],
                        ))),
              ),
            ),
          ],
        ));
  }

  void _goFinish() {
    Navigator.of(context).pushReplacementNamed('/prepaid_finish', arguments: {'amount': amount});
  }
}

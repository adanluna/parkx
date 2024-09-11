import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';

class PrepaidFinishScreen extends StatefulWidget {
  const PrepaidFinishScreen({super.key});

  static const routeName = '/prepaid_finish';

  @override
  State<PrepaidFinishScreen> createState() => _PrepaidFinishScreenState();
}

class _PrepaidFinishScreenState extends State<PrepaidFinishScreen> {
  TextEditingController codigoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
            title: 'Recarga exitosa',
            withBackButton: true,
            function: () {
              Navigator.of(context).pop();
            }),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: AppTheme.accentColor,
                child: Column(
                  children: [
                    Text(
                      'Se ha abonado a tu cuenta',
                      style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.primaryColor),
                    ),
                    Text(
                      '\$300.00',
                      style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 30, color: AppTheme.primaryColor),
                    ),
                  ],
                )),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 6, color: const Color(0xFF4D4D4D)),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    height: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                    decoration: const BoxDecoration(color: Colors.white, border: Border.symmetric(vertical: BorderSide(color: AppTheme.gray))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text('Resumen',
                              style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tipo de abono',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 14,
                                )),
                            Text('Tarjeta',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Fecha',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 14,
                                )),
                            Text('27/12/2024',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Hora',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 14,
                                )),
                            Text('10:45 am',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Costo',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 14,
                                )),
                            Text('\$300.00',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 14,
                                )),
                            Text('\$300.00',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Comisión Parkx',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 14,
                                )),
                            Text('\$0.00',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black26,
                          ),
                        ),
                        Text('Pagaste con Apple Pay',
                            style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black26,
                          ),
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Text(
                                  'Saldo en tu cuenta',
                                  style: AppTheme.theme.textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.primaryColor),
                                ),
                                Text(
                                  '\$300.00',
                                  style: AppTheme.theme.textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold, fontSize: 30, color: AppTheme.primaryColor),
                                ),
                                Text(
                                  'PUNTOS',
                                  style: AppTheme.theme.textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.primaryColor),
                                ),
                                const SizedBox(height: 15),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                    width: double.infinity,
                    child: Image(
                      image: AssetImage('assets/images/boleto_abajo.png'),
                      fit: BoxFit.cover,
                    )))
          ],
        )));
  }
}

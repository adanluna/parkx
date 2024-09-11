import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  static const routeName = '/payment_success';

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  TextEditingController codigoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
            title: 'Pago Exitoso',
            withBackButton: true,
            function: () {
              Navigator.of(context).pushReplacementNamed('/home');
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
                      'Se ha pagado',
                      style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.primaryColor),
                    ),
                    Text(
                      '\$85.00',
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
                            Text('Forma de pago',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 14,
                                )),
                            Text('Cuenta ParkX',
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
                            Text('\$75.00',
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
                            Text('\$75.00',
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
                            Text('\$10.00',
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
                                  '\$15.00',
                                  style: AppTheme.theme.textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold, fontSize: 30, color: AppTheme.primaryColor),
                                ),
                                Text(
                                  'PUNTOS',
                                  style: AppTheme.theme.textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold, fontSize: 20, color: AppTheme.primaryColor),
                                ),
                              ],
                            )),
                        ButtonSecondary(
                            title: 'Abonar a mi cuenta',
                            function: () {
                              Navigator.of(context).pushReplacementNamed('/home');
                            }),
                        const SizedBox(height: 15),
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

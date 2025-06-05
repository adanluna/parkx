import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkx/providers/wallet_provider.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_primary.dart';
import 'package:provider/provider.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final int total;
  final int comision;
  final int subtotal;
  final int descuento;
  final String cupon;
  const PaymentSuccessScreen({
    super.key,
    required this.total,
    required this.comision,
    required this.subtotal,
    required this.descuento,
    required this.cupon,
  });

  static const routeName = '/payment_success';

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  TextEditingController codigoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Pago Exitoso',
        withBackButton: true,
        function: () {
          Navigator.of(context).pushReplacementNamed('/home');
        },
      ),
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
                    '\$${_convertoMoney(widget.total)}',
                    style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 30, color: AppTheme.primaryColor),
                  ),
                ],
              ),
            ),
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
                          child: Text('Resumen', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Forma de pago', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14)),
                            Text('Cuenta ParkX', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Fecha', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14)),
                            Text(
                              DateFormat('dd/MM/yyyy').format(DateTime.now()),
                              style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Hora', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14)),
                            Text(
                              DateFormat('HH:mm').format(DateTime.now()),
                              style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Monto', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14)),
                            Text(
                              '\$${_convertoMoney(widget.subtotal)}',
                              style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Comisión Parkx', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14)),
                            Text(
                              '\$${_convertoMoney(widget.comision)}',
                              style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                        (widget.cupon != '')
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Cupón (${widget.cupon})', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14)),
                                Text(
                                  '-\$${_convertoMoney(widget.descuento)}',
                                  style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            )
                            : SizedBox.shrink(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total a pagar', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                              '\$${_convertoMoney(widget.total)}',
                              style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider(height: 1, thickness: 1, color: Colors.black26)),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Text(
                                'Saldo en tu cuenta',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              Text(
                                '\$${_convertoMoney((walletProvider.wallet?.balance ?? 0).toInt())}',
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ButtonPrimary(
                          title: 'Regresar',
                          function: () {
                            Navigator.of(context).pushReplacementNamed('/home');
                          },
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(width: double.infinity, child: Image(image: AssetImage('assets/images/boleto_abajo.png'), fit: BoxFit.cover)),
            ),
          ],
        ),
      ),
    );
  }

  String _convertoMoney(int value) {
    return NumberFormat.currency(locale: "es_MX", symbol: "", decimalDigits: 0).format(value);
  }
}

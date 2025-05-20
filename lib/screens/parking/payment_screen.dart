import 'package:flutter/material.dart';
import 'package:parkx/providers/parking_provider.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_applepay.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final String code;
  const PaymentScreen({super.key, required this.code});

  static const routeName = '/payment';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  TextEditingController codigoController = TextEditingController();
  String cuponCodigo = '';

  @override
  void dispose() {
    codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parkingProvier = Provider.of<ParkingProvider>(context);

    setCupon() {
      setState(() {
        cuponCodigo = codigoController.text;
        codigoController.text = '';
      });
      Navigator.pop(context);
    }

    removeCupon() {
      setState(() {
        cuponCodigo = '';
      });
    }

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
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(child: Text('Cupón', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold))),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: TextFormField(
                          controller: codigoController,
                          textCapitalization: TextCapitalization.characters,
                          style: AppTheme.theme.textTheme.bodyMedium,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Proporciona el cupón';
                            }
                            return null;
                          },
                        ),
                      ),
                      ButtonSecondary(
                        title: 'Aplicar cupón',
                        function: () {
                          (codigoController.text.length > 3) ? setCupon() : null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim1), child: child);
        },
      );
    }

    return Scaffold(
      appBar: AppBarWidget(title: 'Paga tu boleto', function: _returnHome, withBackButton: true),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: const BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Text(
                          'Estacionamiento',
                          style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                        ),
                        Text(
                          parkingProvier.parking.nombre,
                          style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                        ),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1, thickness: 1, color: Colors.white24)),
                        Text(
                          'No. Boleto:',
                          textAlign: TextAlign.center,
                          style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: AppTheme.accentColor,
                          ),
                        ),
                        Text(
                          widget.code,
                          textAlign: TextAlign.center,
                          style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: AppTheme.accentColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: IconButton(
                              onPressed: _returnHome,
                              style: IconButton.styleFrom(
                                backgroundColor: AppTheme.accentColor,
                                padding: const EdgeInsets.all(5),
                                elevation: 0,
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                              ),
                              iconSize: 20,
                              icon: const Icon(Icons.delete_forever_outlined, color: AppTheme.primaryColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Fecha', style: TextStyle(color: Colors.white, fontSize: 12)),
                            Text('Tiempo', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('30/01/2024', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('03h : 24m', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Subtotal', style: TextStyle(fontSize: 16)),
                            Text('\$100.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Costo del estacionamiento', style: TextStyle(fontSize: 16)),
                            Text('\$10.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Comisión PARKX', style: TextStyle(fontSize: 16)),
                            Text('\$2.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text('Prepago (Saldo \$105)', style: TextStyle(fontSize: 16)),
                            Text('\$-12.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Divider(height: 1, thickness: 1, color: Colors.black26)),
                  (cuponCodigo == '')
                      ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text('¿Tienes un cupón?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(Icons.arrow_forward_outlined),
                              onPressed: () {
                                showCupon(context);
                              },
                            ),
                          ],
                        ),
                      )
                      : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text('Cupón', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                Text(cuponCodigo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                                IconButton(
                                  padding: const EdgeInsets.all(0),
                                  icon: const Icon(Icons.delete_forever_outlined),
                                  onPressed: () {
                                    removeCupon();
                                  },
                                ),
                              ],
                            ),
                            const Text('\$-20.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Divider(height: 1, thickness: 1, color: Colors.black26)),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: ButtonApplePay(function: () {})),
                ],
              ),
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
                          children: [Text('Total a pagar:'), Text('\$100.00', style: TextStyle(fontWeight: FontWeight.w600))],
                        ),
                      ),
                      ButtonSecondary(title: 'Realizar el pago', function: _goPaymentSuccess),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goPaymentSuccess() {
    Navigator.of(context).pushReplacementNamed('/payment_success');
  }

  void _returnHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}

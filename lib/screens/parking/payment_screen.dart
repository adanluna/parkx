import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:parkx/api/payment_repository.dart';
import 'package:parkx/providers/parking_provider.dart';
import 'package:parkx/providers/wallet_provider.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
  int total = 50;
  int comision = 2;
  int totalAPagar = 0;
  int cuponDescuento = 0;
  Map<String, dynamic>? _cuponData;

  @override
  void dispose() {
    codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parkingProvier = Provider.of<ParkingProvider>(context, listen: false);
    final walletProvider = Provider.of<WalletProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBarWidget(title: 'Paga tu boleto', function: _returnHome, withBackButton: true),
      body: SingleChildScrollView(
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
                    '# Boleto:',
                    textAlign: TextAlign.center,
                    style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.accentColor),
                  ),
                  Text(
                    widget.code,
                    textAlign: TextAlign.center,
                    style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.accentColor),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('Hora Entrada', style: TextStyle(color: Colors.white, fontSize: 15)),
                          Text('21:34', style: TextStyle(color: Colors.white, fontSize: 15)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('Hora Salida', style: TextStyle(color: Colors.white, fontSize: 15)),
                          Text('23:45', style: TextStyle(color: Colors.white, fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Text('Tiempo', style: TextStyle(fontSize: 16)),
                      Text('2h:34m', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1, thickness: 1, color: Colors.black26)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('Total estacionamiento', style: TextStyle(fontSize: 16)),
                      Text('\$${_convertoMoney(total)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('Comisión ParkX', style: TextStyle(fontSize: 16)),
                      Text('\$${_convertoMoney(comision)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
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
                      Text('Cupón', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                      Text('-\$${_convertoMoney(cuponDescuento)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Divider(height: 1, thickness: 1, color: Colors.black26)),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 5, blurRadius: 7, offset: const Offset(0, 3))],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Saldo Prepago:'),
                    Text('\$${_convertoMoney((walletProvider.wallet?.balance ?? 0).toInt())}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total a pagar:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Text('\$${_calculateTotal()}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    style: AppTheme.theme.elevatedButtonTheme.style!.copyWith(
                      elevation: WidgetStateProperty.all(0),
                      shadowColor: WidgetStateProperty.all(Colors.transparent),
                      backgroundColor: WidgetStateProperty.all(AppTheme.accentColor),
                    ),
                    onPressed: _payment,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Text(
                        "Realizar pago con saldo",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.primaryColor, fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: ButtonSecondary(title: 'Aplicar cupón', function: () => setCupon(codigoController.text.trim())),
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

  void _payment() async {
    final parkingProvider = Provider.of<ParkingProvider>(context, listen: false);
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    if (walletProvider.wallet?.balance == null || walletProvider.wallet?.balance == 0 || walletProvider.wallet!.balance < totalAPagar) {
      showErrorDialog(context, message: 'No tienes saldo suficiente para realizar el pago.');
      return;
    }

    try {
      context.loaderOverlay.show();
      await PaymentRepository().createPayment(
        totalAPagar,
        comision,
        total,
        widget.code,
        _cuponData?['id'],
        cuponDescuento,
        parkingProvider.parking.id,
      );
      context.loaderOverlay.hide();

      walletProvider.wallet?.balance = (walletProvider.wallet?.balance ?? 0) - totalAPagar;
      _goPaymentSuccess();
    } catch (e) {
      context.loaderOverlay.hide();
      showErrorDialog(context, message: e is Exception && (e as dynamic).message != null ? (e as dynamic).message : 'Error al procesar el pago.');
    }
  }

  void _goPaymentSuccess() {
    Navigator.of(context).pushReplacementNamed(
      '/payment_success',
      arguments: {'cupon': cuponCodigo, 'descuento': cuponDescuento, 'total': totalAPagar, 'subtotal': total, 'comision': comision},
    );
    removeCupon();
    codigoController.clear();
    _cuponData = null;
  }

  void _returnHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  setCupon(String codigo) async {
    var parkingProvier = Provider.of<ParkingProvider>(context, listen: false);
    try {
      context.loaderOverlay.show();
      final cuponData = await PaymentRepository().findCupon(codigo, parkingProvier.parking.id);
      context.loaderOverlay.hide();
      Navigator.of(context).pop();
      setState(() {
        _cuponData = cuponData;
        cuponCodigo = cuponData['nombre'];
        if (cuponData['descuento'] == 'gratis') {
          cuponDescuento = total + comision; // Si es gratis, el descuento es el total a pagar
        } else {
          cuponDescuento = cuponData['monto'] ?? 0;
        }
      });
    } catch (e) {
      cuponCodigo = '';
      cuponDescuento = 0;
      context.loaderOverlay.hide();
      showErrorDialog(context, message: e is Exception && (e as dynamic).message != null ? (e as dynamic).message : 'Error al validar el cupón.');
    }
  }

  removeCupon() {
    setState(() {
      cuponCodigo = '';
      cuponDescuento = 0;
      codigoController.clear();
    });
  }

  String _calculateTotal() {
    totalAPagar = (total + comision) - cuponDescuento;
    return _convertoMoney(totalAPagar);
  }

  String _convertoMoney(int value) {
    return NumberFormat.currency(locale: "es_MX", symbol: "", decimalDigits: 0).format(value);
  }
}

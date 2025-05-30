import 'package:flutter/material.dart';
import 'package:parkx/providers/parking_provider.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:provider/provider.dart';

class ErrorParkingScreen extends StatefulWidget {
  const ErrorParkingScreen({super.key});

  static const routeName = '/error_parking';

  @override
  State<ErrorParkingScreen> createState() => _ErrorParkingScreenState();
}

class _ErrorParkingScreenState extends State<ErrorParkingScreen> {
  TextEditingController codigoController = TextEditingController();

  @override
  void dispose() {
    codigoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parkingProvier = Provider.of<ParkingProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Lo sentimos',
        withBackButton: true,
        function: () {
          Navigator.of(context).pop('');
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(height: 200, child: Image(image: AssetImage('assets/images/error.png'))),
                  ),
                  Text('Estacionamiento', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                  Text(
                    (parkingProvier.selected) ? parkingProvier.parking.nombre : '',
                    style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 40),
                    child: Text('Hacemos todo lo posible por reestablecerlo.', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                    child: Text(
                      'Te invitamos a realizar el pago en el cajero',
                      textAlign: TextAlign.center,
                      style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                        height: 1.1,
                        fontSize: 24,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.only(left: 20, right: 20, top: 10), child: ButtonSecondary(title: 'Cerrar', function: _goHome)),
          ],
        ),
      ),
    );
  }

  void _goHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}

import 'package:flutter/material.dart';
import 'package:parkx/providers/parking_provider.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_outline.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:provider/provider.dart';

class NotFoundParkingScreen extends StatefulWidget {
  const NotFoundParkingScreen({super.key});

  static const routeName = '/not_found_parking';

  @override
  State<NotFoundParkingScreen> createState() => _NotFoundParkingScreenState();
}

class _NotFoundParkingScreenState extends State<NotFoundParkingScreen> {
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
        title: 'No Encontrado',
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
                    child: SizedBox(height: 200, child: Image(image: AssetImage('assets/images/not_found.png'))),
                  ),
                  Text('No encontramos', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                  Text(
                    parkingProvier.parking.nombre,
                    style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text('dentro de la zona de cobertura', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.only(left: 20, right: 20, top: 30), child: ButtonSecondary(title: 'Reintentar', function: _goHome)),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ButtonOutline(title: 'Seleccionar otro estacionamiento', function: _goSearch),
            ),
          ],
        ),
      ),
    );
  }

  void _goSearch() {
    Navigator.of(context).pushReplacementNamed('/parking_search');
  }

  void _goHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}

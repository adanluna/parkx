import 'package:flutter/material.dart';
import 'package:parkx/providers/parking_provider.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:provider/provider.dart';

class ManualScannerScreen extends StatefulWidget {
  const ManualScannerScreen({super.key});

  static const routeName = '/manual_scanner';

  @override
  State<ManualScannerScreen> createState() => _ManualScannerScreenState();
}

class _ManualScannerScreenState extends State<ManualScannerScreen> {
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
        title: 'Captura Manual',
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
                  Text(
                    parkingProvier.parking.nombre,
                    style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(child: Image(image: AssetImage('assets/images/boleto.png'))),
                  ),
                  Text('Código del boleto', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 16)),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: TextFormField(
                      controller: codigoController,
                      style: AppTheme.theme.textTheme.bodyMedium,
                      decoration: const InputDecoration(hintText: "12 dígitos"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Proporciona el codigo';
                        }
                        if (value.length > 20) {
                          return 'Máximo 20 dígitos';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: ButtonSecondary(title: 'Buscar Boleto', function: _goPayment),
            ),
          ],
        ),
      ),
    );
  }

  void _goPayment() {
    if (codigoController.text.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed('/payment', arguments: {'code': codigoController.text});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proporciona el código del boleto')));
    }
  }
}

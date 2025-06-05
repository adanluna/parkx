import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:parkx/widgets/logo_background_padding.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  static const routeName = '/scanner';

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool isFlashOn = false;
  bool isScanned = false;
  String? code;
  String estacionamiento = 'Selecciona un Estacionamiento';
  MobileScannerController mobileScannerController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  void dispose() {
    mobileScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(child: _buildQrView(context)),
          const SizedBox(width: 200, height: 115, child: LogoBackgroundPadding()),
          Positioned(
            top: 150,
            child: Text('Escanéa tu boleto', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
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
                      color: Colors.grey.withAlpha(128), // 128 es aproximadamente 0.5 de opacidad (0-255)
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ButtonSecondary(title: 'Captura Manual', function: _goManualScanner),
                      ),
                      /*Text('Estacionamiento', style: AppTheme.theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          _goParkingSearch();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.gray, width: 1),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 270,
                                child: Text(
                                  (parkingProvier.selected) ? parkingProvier.parking.nombre : estacionamiento,
                                  style: AppTheme.theme.textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.edit, size: 23, color: Colors.black),
                            ],
                          ),
                        ),
                      ),*/
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(onTap: _goNotFound, child: Text('No Parking', style: AppTheme.theme.textTheme.bodySmall)),
                          GestureDetector(onTap: _goNoTicket, child: Text('No ticket', style: AppTheme.theme.textTheme.bodySmall)),
                          GestureDetector(onTap: _goError, child: Text('Error Parking', style: AppTheme.theme.textTheme.bodySmall)),
                        ],
                      ),*/
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            child: IconButton(
              onPressed: () async {
                await mobileScannerController.toggleTorch();
                setState(() {
                  isFlashOn = !isFlashOn;
                });
              },
              style: IconButton.styleFrom(
                backgroundColor: (!isFlashOn) ? AppTheme.accentColor : AppTheme.alert,
                padding: const EdgeInsets.all(5),
                elevation: 0,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
              iconSize: 30,
              icon: Icon((!isFlashOn) ? Icons.lightbulb : Icons.lightbulb_outline, color: AppTheme.primaryColor),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomPaint(painter: _CornersPainter()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height, // Ocupa el 100% de la pantalla
      child: MobileScanner(
        controller: mobileScannerController,
        fit: BoxFit.cover,
        onDetect: (capture) {
          if (!isScanned) {
            final barcodes = capture.barcodes;
            if (barcodes.isNotEmpty) {
              final String? code = barcodes.firstOrNull?.rawValue;
              if (code != null) {
                _onCodeDetected(code);
              }
            }
          }
        },
      ),
    );
  }

  void _onCodeDetected(String code) async {
    setState(() {
      this.code = code;
      isScanned = true;
    });
    _goPayment();
  }

  void _goManualScanner() async {
    _goParkingSearch(true, '');
    //await Navigator.of(context).pushNamed('/manual_scanner');
  }

  void _goPayment() async {
    _goParkingSearch(false, code as String);
    //Navigator.of(context).pushNamed('/payment', arguments: {'code': code as String});
  }

  void _goParkingSearch(bool manual, String code) async {
    await mobileScannerController.stop();
    Navigator.of(context).pushNamed('/parking_search', arguments: {'manual': manual, 'code': code});
  }

  /*void _goNotFound() async {
    await mobileScannerController.stop();
    final parkingProvier = Provider.of<ParkingProvider>(context, listen: false);
    if (!parkingProvier.selected) {
      _goParkingSearch();
    } else {
      await Navigator.of(context).pushNamed('/not_found_parking');
      await mobileScannerController.start();
    }
  }

  void _goNoTicket() async {
    await mobileScannerController.stop();
    final parkingProvier = Provider.of<ParkingProvider>(context, listen: false);
    if (!parkingProvier.selected) {
      _goParkingSearch();
    } else {
      await Navigator.of(context).pushNamed('/not_found_ticket');
      await mobileScannerController.start();
    }
  }

  void _goError() async {
    await mobileScannerController.stop();
    final parkingProvier = Provider.of<ParkingProvider>(context, listen: false);
    if (!parkingProvier.selected) {
      _goParkingSearch();
    } else {
      await Navigator.of(context).pushNamed('/error_parking');
      await mobileScannerController.start();
    }
  }*/
}

class _CornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    const cornerLength = 34.0;

    // Esquinas
    // Superior izquierda
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), paint);
    // Superior derecha
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);
    // Inferior izquierda
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    // Inferior derecha
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

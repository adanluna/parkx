import 'package:flutter/material.dart';
import 'package:parkx/providers/parking_provider.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:parkx/widgets/logo_background_padding.dart';
import 'package:provider/provider.dart';
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
    final parkingProvier = Provider.of<ParkingProvider>(context);
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
                      Text('Estacionamiento', style: AppTheme.theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          _goParkingSearch();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                const Icon(Icons.arrow_forward, size: 23, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ),
                      ButtonSecondary(title: 'Captura Manual', function: _goManualScanner),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(onTap: _goNotFound, child: Text('No Parking', style: AppTheme.theme.textTheme.bodySmall)),
                          GestureDetector(onTap: _goNoTicket, child: Text('No ticket', style: AppTheme.theme.textTheme.bodySmall)),
                          GestureDetector(onTap: _goError, child: Text('Error Parking', style: AppTheme.theme.textTheme.bodySmall)),
                        ],
                      ),
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
    final parkingProvier = Provider.of<ParkingProvider>(context, listen: false);
    setState(() {
      this.code = code;
      isScanned = true;
    });
    if (!parkingProvier.selected) {
      showErrorDialog(
        context,
        message: 'Necesitas seleccionar un estacionamiento',
        onConfirm: () {
          Navigator.of(context).pop();
          setState(() {
            isScanned = false;
          });
          //_goParkingSearch();
        },
      );
    } else {
      _goPayment();
    }
  }

  void _goManualScanner() async {
    await mobileScannerController.stop();
    final parkingProvier = Provider.of<ParkingProvider>(context, listen: false);
    if (!parkingProvier.selected) {
      _goParkingSearch();
    } else {
      await Navigator.of(context).pushNamed('/manual_scanner');
      await mobileScannerController.start();
    }
  }

  void _goPayment() {
    Navigator.of(context).pushNamed('/payment', arguments: {'code': code as String});
  }

  void _goParkingSearch() async {
    await mobileScannerController.stop();
    var response = await Navigator.of(context).pushNamed('/parking_search');
    await mobileScannerController.start();
    if (response != '') {
      setState(() {
        estacionamiento = response as String;
      });
    }
  }

  void _goNotFound() async {
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
  }
}

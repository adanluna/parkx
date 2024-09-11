import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:parkx/providers/parking_provider.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:parkx/widgets/logo_background_padding.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  static const routeName = '/scanner';

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  Barcode? result;
  String? code;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String estacionamiento = 'Selecciona un Estacionamiento';

  @override
  void initState() {
    EasyLoading.show(
        indicator: const Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 36,
            )),
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black);
    super.initState();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Future<void> dispose() async {
    if (controller != null) {
      //controller!.pauseCamera();
      controller!.dispose();
      controller = null;
    }
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
          Positioned(
              child: FutureBuilder(
            future: controller?.getFlashStatus(),
            builder: (context, snapshot) {
              return _buildQrView(context);
            },
          )),
          const SizedBox(
            width: 200,
            height: 115,
            child: LogoBackgroundPadding(),
          ),
          Positioned(
              top: 150,
              child: Text(
                'Escanéa tu boleto',
                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              )),
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
                          Text(
                            'Estacionamiento',
                            style: AppTheme.theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                                          (parkingProvier.selected) ? parkingProvier.parking.name : estacionamiento,
                                          style: AppTheme.theme.textTheme.bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward,
                                        size: 23,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          ButtonSecondary(title: 'Captura Manual', function: _goManualScanner),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: _goNotFound,
                                  child: Text(
                                    'No Parking',
                                    style: AppTheme.theme.textTheme.bodySmall,
                                  )),
                              GestureDetector(
                                  onTap: _goNoTicket,
                                  child: Text(
                                    'No ticket',
                                    style: AppTheme.theme.textTheme.bodySmall,
                                  )),
                              GestureDetector(
                                  onTap: _goError,
                                  child: Text(
                                    'Error Parking',
                                    style: AppTheme.theme.textTheme.bodySmall,
                                  ))
                            ],
                          )
                        ],
                      ))),
            ),
          ),
          Positioned(
              top: 200,
              child: FutureBuilder(
                future: controller?.getFlashStatus(),
                builder: (context, snapshot) {
                  return IconButton(
                    onPressed: () async {
                      await controller?.toggleFlash();
                      setState(() {});
                    },
                    style: IconButton.styleFrom(
                        backgroundColor: (snapshot.data != true) ? AppTheme.accentColor : Colors.yellow,
                        padding: const EdgeInsets.all(5),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                    iconSize: 30,
                    icon: const Icon(
                      Icons.lightbulb,
                      color: AppTheme.primaryColor,
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 220.0 : 320.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(borderColor: Colors.white, borderRadius: 10, borderLength: 15, borderWidth: 10, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      EasyLoading.dismiss();
    });

    controller.scannedDataStream.listen((scanData) {
      final parkingProvier = Provider.of<ParkingProvider>(context, listen: false);
      controller.pauseCamera();
      setState(() {
        result = scanData;
        if (result != null) {
          setState(() {
            code = result!.code;
          });
          if (!parkingProvier.selected) {
            showErrorDialog(context, message: 'Necesitas seleccionar un estacionamiento', onConfirm: () {
              Navigator.of(context).pop();
              _goParkingSearch();
              controller.resumeCamera();
            });
          } else {
            controller.dispose();
            _goPayment();
          }
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Se necesitan permisos para la cámara')),
      );
    }
  }

  void _goManualScanner() async {
    controller!.pauseCamera();
    final parkingProvier = Provider.of<ParkingProvider>(context, listen: false);
    if (!parkingProvier.selected) {
      _goParkingSearch();
    } else {
      await Navigator.of(context).pushNamed('/manual_scanner');
      controller!.resumeCamera();
    }
  }

  void _goPayment() {
    Navigator.of(context).pushNamed('/payment', arguments: {'code': code as String});
  }

  void _goParkingSearch() async {
    controller!.pauseCamera();
    var response = await Navigator.of(context).pushNamed('/parking_search');
    controller!.resumeCamera();
    if (response != '') {
      setState(() {
        estacionamiento = response as String;
      });
    }
  }

//////
  void _goNotFound() async {
    controller!.pauseCamera();
    final parkingProvier = Provider.of<ParkingProvider>(context, listen: false);
    if (!parkingProvier.selected) {
      _goParkingSearch();
    } else {
      await Navigator.of(context).pushNamed('/not_found_parking');
      controller!.resumeCamera();
    }
  }

  void _goNoTicket() async {
    controller!.pauseCamera();
    final parkingProvier = Provider.of<ParkingProvider>(context, listen: false);
    if (!parkingProvier.selected) {
      _goParkingSearch();
    } else {
      await Navigator.of(context).pushNamed('/not_found_ticket');
      controller!.resumeCamera();
    }
  }

  void _goError() async {
    controller!.pauseCamera();
    final parkingProvier = Provider.of<ParkingProvider>(context, listen: false);
    if (!parkingProvier.selected) {
      _goParkingSearch();
    } else {
      await Navigator.of(context).pushNamed('/error_parking');
      controller!.resumeCamera();
    }
  }
}

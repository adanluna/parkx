import 'package:flutter/material.dart';
import 'package:parkx/api/wallet_repository.dart';
import 'package:parkx/models/wallet_transfer.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:parkx/widgets/ol_item.dart';
import 'package:flutter/services.dart';

class SpeiFinishScreen extends StatefulWidget {
  const SpeiFinishScreen({super.key});
  static const routeName = '/spei_finish';

  @override
  State<SpeiFinishScreen> createState() => _SpeiFinishScreenState();
}

class _SpeiFinishScreenState extends State<SpeiFinishScreen> {
  WalletTransfer? infoTransfer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getTransfer();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(title: 'Abona saldo', withBackButton: false, function: null),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  'Transferencia por SPEI',
                  textAlign: TextAlign.center,
                  style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Recuerda en Banco Receptor escoger',
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "STP Sistema de Transferencia y Pagos",
                        textAlign: TextAlign.center,
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.white24,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              Text(
                                (infoTransfer != null) ? infoTransfer!.bankName : 'Cargando ...',
                                textAlign: TextAlign.center,
                                style: AppTheme.theme.textTheme.bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.accentColor),
                              ),
                              Text(
                                (infoTransfer != null) ? 'CLABE ${infoTransfer!.clabe}' : 'Cargando ...',
                                textAlign: TextAlign.center,
                                style: AppTheme.theme.textTheme.bodyMedium!
                                    .copyWith(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.accentColor),
                              ),
                            ],
                          )),
                    ],
                  )),
              ButtonSecondary(
                  title: 'Copiar CLABE',
                  function: (infoTransfer != null)
                      ? () {
                          Clipboard.setData(ClipboardData(text: infoTransfer!.clabe)).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Center(child: Text("CLABE copiada"))));
                          });
                        }
                      : () {}),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  'Instrucciones de pago',
                  textAlign: TextAlign.center,
                  style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const Column(
                children: [
                  OrderedListItem('1',
                      'Da de alta la CLABE generada dentro de tu banca electrónica o App por única vez, utiliza como banco receptor a <b>STP Sistema de Transferencia y Pagos</b>.'),
                  OrderedListItem('2', 'Utiliza los <b>18 dígitos de la CLABE Interbancaria</b>.'),
                  OrderedListItem('3', '<b>Ingresa el monto</b> que deseas abonar a tu cuenta de Parkx.'),
                  OrderedListItem('4', '<b>Envía la transferencia</b>.'),
                  OrderedListItem('5', 'Listo!.'),
                ],
              ),
            ],
          ),
        )));
  }

  _getTransfer() async {
    await WalletRepository().getTransfer().then((transfer) async {
      setState(() {
        infoTransfer = transfer!;
      });
    }, onError: (error) {
      showErrorDialog(context, message: error.message);
    });
  }
}

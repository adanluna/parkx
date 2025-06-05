import 'package:flutter/material.dart';
import 'package:parkx/models/wallet_transfer.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/wallet_functions.dart';
import 'package:parkx/widgets/alert_box.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/ol_item.dart';
import 'package:url_launcher/url_launcher.dart';

class SpeiFinishScreen extends StatefulWidget {
  final String urlPayment;
  final String? amount;
  const SpeiFinishScreen({super.key, required this.urlPayment, required this.amount});
  static const routeName = '/spei_finish';

  @override
  State<SpeiFinishScreen> createState() => _SpeiFinishScreenState();
}

class _SpeiFinishScreenState extends State<SpeiFinishScreen> {
  WalletTransfer? infoTransfer;

  @override
  void initState() {
    _initAsync();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initAsync() async {
    await getWallet(context);
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.open_in_new, color: AppTheme.primaryColor),
                  label: Text(
                    'Ver Información de la transferencia',
                    style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 17, color: AppTheme.primaryColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  onPressed: () async {
                    final url = Uri.parse(widget.urlPayment);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo abrir las instrucciones.')));
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  'Instrucciones de pago',
                  textAlign: TextAlign.center,
                  style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Column(
                children: [
                  const OrderedListItem('1', 'Usa el botón de "Ver información de la transferencia" para ver los datos para transferir.'),
                  const OrderedListItem('2', 'Utiliza los <b>18 dígitos de la CLABE Interbancaria</b>.'),
                  OrderedListItem('3', 'Ingresa el monto de <b>\$${widget.amount} MXN</b>.'),
                  const OrderedListItem('4', '<b>Envía la transferencia</b>.'),
                  const OrderedListItem('5', '¡Listo! Te enviaremos un correo electrónico con la confirmación de tu pago.'),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: AlertBox(text: 'Parkx te enviará la confirmación del pago a tu correo electrónico.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/wallet_functions.dart';
import 'package:parkx/widgets/alert_box.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/ol_item.dart';
import 'package:url_launcher/url_launcher.dart';

class OxxoFinishScreen extends StatefulWidget {
  final String amount;
  final String voucherUrl;
  final String expiresAt;
  const OxxoFinishScreen({super.key, required this.amount, required this.voucherUrl, required this.expiresAt});
  static const routeName = '/oxxo_finish';

  @override
  State<OxxoFinishScreen> createState() => _OxxoFinishScreenState();
}

class _OxxoFinishScreenState extends State<OxxoFinishScreen> {
  late String amountString = '';

  @override
  void initState() {
    amountString = widget.amount.toCurrencyString(mantissaLength: 0);
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
      appBar: const AppBarWidget(title: 'Oxxo referencia', withBackButton: false, function: null),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Text('Monto a pagar en OXXO', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 13, color: Colors.white)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "\$$amountString",
                          style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
                        ),
                        //Text(" + Comisión", style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 18, color: Colors.white)),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Divider(height: 1, thickness: 1, color: Colors.white24)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.open_in_new, color: AppTheme.primaryColor),
                        label: Text(
                          'Ver voucher OXXO',
                          style: AppTheme.theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        onPressed: () async {
                          final url = Uri.parse(widget.voucherUrl);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo abrir el voucher.')));
                          }
                        },
                      ),
                    ),
                    Text(
                      'IMPORTANTE',
                      textAlign: TextAlign.center,
                      style: AppTheme.theme.textTheme.bodySmall!.copyWith(fontSize: 12, color: Colors.yellowAccent, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'OXXO de cobrará la comisión y no será parte de tu abono a tu cuenta de Parkx',
                      textAlign: TextAlign.center,
                      style: AppTheme.theme.textTheme.bodySmall!.copyWith(fontSize: 12, color: Colors.white),
                    ),
                    const SizedBox(height: 11),
                  ],
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
              const Column(
                children: [
                  OrderedListItem('1', 'Enviamos la referencia de pago a tu correo electrónico.'),
                  OrderedListItem('2', 'Acude a una tienda OXXO.'),
                  OrderedListItem('3', 'En caja indica que harás un pago por medio de OXXO Pay.'),
                  OrderedListItem('4', 'Muestra la referencia que te enviamos por correo o directamente del link.'),
                  OrderedListItem('5', 'Haz el pago en efectivo.'),
                  OrderedListItem('6', 'Guarda el comprobante para alguna aclaración.'),
                  OrderedListItem('7', '¡Listo!. Te notificaremos cuando tu pago se haya procesado.'),
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

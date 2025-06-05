import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:parkx/api/user_repository.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';
import 'package:parkx/widgets/ol_item.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  static const routeName = '/delete_acount';

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool recibosAbonos = true;
  bool recibosPagos = false;

  final WidgetStateProperty<Icon?> thumbIcon = WidgetStateProperty.resolveWith<Icon?>((Set<MaterialState> states) {
    if (states.contains(WidgetState.selected)) {
      return const Icon(Icons.check, color: AppTheme.primaryColor);
    }
    return const Icon(Icons.close, color: Colors.white);
  });

  @override
  void initState() {
    super.initState();
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
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                child: Text(
                  'Eliminación de cuenta',
                  textAlign: TextAlign.center,
                  style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(color: AppTheme.errorColor, borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  children: [
                    const SizedBox(child: Image(image: AssetImage('assets/images/alert_white.png'))),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Al eliminar tu cuenta aceptas que el cierre de tu cuenta es permanente y no se podrá reestablecer.',
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14, color: Colors.white, height: 1.1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Column(
                children: [
                  OrderedListItem('1', 'Se eliminará todas la información de tus formas de pago, incluyendo tarjetas.'),
                  OrderedListItem('2', 'Requerirás crear una nueva cuenta si quieres volver a usar los servicios de Parkx.'),
                  OrderedListItem('3', 'Parkx podrá conservar alguna información personal según lo establece el Aviso de Privacidad.'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: ButtonSecondary(
                  title: 'Eliminar mi cuenta',
                  function: () {
                    _deteteAccount();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deteteAccount() async {
    try {
      context.loaderOverlay.show();
      final result = await UserRepository().deleteAccount();
      if (result == true) {
        context.loaderOverlay.hide();
        showSuccessDialog(
          context,
          message: 'Cuenta eliminada exitosamente.',
          onDismiss: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/login');
          },
        );
      } else {
        context.loaderOverlay.hide();
        showErrorDialog(context, message: 'No se pudo eliminar la cuenta. Intenta de nuevo.');
      }
    } catch (e) {
      context.loaderOverlay.hide();
      showErrorDialog(context, message: 'Error: ${e.toString()}');
    }
  }
}

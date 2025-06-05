import 'package:flutter/material.dart';
import 'package:parkx/api/user_repository.dart';
import 'package:parkx/providers/wallet_provider.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_outline_profile.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Perfil', withBackButton: false, function: null),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text('Mis datos', style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              ButtonOutlineProfile(
                title: 'Datos personales',
                subtitle: 'Tus datos personales',
                function: () {
                  _goPage('personal_data');
                },
              ),
              ButtonOutlineProfile(
                title: 'Abonos',
                subtitle: 'Todos tus abonos realizados',
                function: () {
                  _goPage('abonos');
                },
              ),
              ButtonOutlineProfile(
                title: 'Pagos',
                subtitle: 'Todos pagos de boletos',
                function: () {
                  _goPage('pagos');
                },
              ),
              /*ButtonOutlineProfile(
                title: 'Facturación',
                subtitle: 'Tus datos fiscales',
                function: () {
                  _goPage('billing');
                },
              ),*/
              ButtonOutlineProfile(
                title: 'Configuración',
                subtitle: 'Todo lo relacionado con esta app',
                function: () {
                  _goPage('settings');
                },
              ),
              ButtonOutlineProfile(title: 'Legales', subtitle: 'Documentos importantes de Parkx', function: () {}),
              ButtonOutlineProfile(
                title: 'Cerrar sesión',
                subtitle: 'Nos vemos pronto',
                function: () {
                  _logOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goPage(String page) {
    Navigator.of(context).pushNamed('/$page');
  }

  void _logOut() async {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    showConfirmDialog(
      context,
      message: '¿Quieres cerrar sesión?',
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () async {
        await UserRepository().logout();
        walletProvider.clear();
        Navigator.of(context).pushReplacementNamed('/login');
      },
    );
  }
}

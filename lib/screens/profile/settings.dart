import 'package:flutter/material.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_outline_profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
            title: 'Configuración',
            withBackButton: true,
            function: () {
              Navigator.of(context).pop();
            }),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    ButtonOutlineProfile(
                        title: 'Notificaciones',
                        subtitle: 'Alertas de tus movimientos',
                        function: () {
                          _goPage('notifications');
                        }),
                    ButtonOutlineProfile(
                        title: 'Sesiones',
                        subtitle: 'Revisa las sesiones activas de tu cuenta',
                        function: () {
                          _goPage('sessions');
                        }),
                    ButtonOutlineProfile(
                        title: 'Eliminar cuenta',
                        subtitle: 'Borra todo lo relacionado a tu cuenta',
                        function: () {
                          _goPage('delete_acount');
                        })
                  ],
                ))));
  }

  void _goPage(String page) {
    Navigator.of(context).pushNamed('/$page');
    //Navigator.of(context).pop();
  }
}

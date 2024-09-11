import 'package:flutter/material.dart';
import 'package:parkx/widgets/alert_box.dart';
import 'package:parkx/widgets/logo_background.dart';
import 'package:parkx/utils/app_theme.dart';

class PasswordSuccessScreen extends StatefulWidget {
  const PasswordSuccessScreen({super.key});

  static const routeName = '/password_success';

  @override
  State<PasswordSuccessScreen> createState() => _PasswordSuccessScreenState();
}

class _PasswordSuccessScreenState extends State<PasswordSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      return Column(
        children: <Widget>[
          const Expanded(
            flex: 1,
            child: LogoBackground(),
          ),
          Expanded(
              flex: 2,
              child: Container(
                color: AppTheme.primaryColor,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                    )),
                    Positioned.fill(
                        child: Column(children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 40,
                        height: 5,
                        decoration: const BoxDecoration(color: AppTheme.accentColor, borderRadius: BorderRadius.all(Radius.circular(50))),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              Text(
                                "Cambio de contraseña Autorizada",
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                  child: Text('Te enviamos un enlance a tu correo eléctronico para que puedas cambiar tu contraseña nuevamante.',
                                      textAlign: TextAlign.center, style: AppTheme.theme.textTheme.bodyMedium)),
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                                child: AlertBox(text: 'En enlace tendrá una duración válida de 30 minutos; después expirará.'),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: ElevatedButton(
                                        onPressed: _goLogin,
                                        child: const Text('Regresar a Ingresar'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                        ),
                      ))
                    ]))
                  ],
                ),
              )),
        ],
      );
    }));
  }

  void _goLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }
}

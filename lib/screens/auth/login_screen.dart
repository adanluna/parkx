import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:parkx/api/user_repository.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/utils/wallet_functions.dart';
import 'package:parkx/widgets/logo_background.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                                "Ingresa",
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 5),
                                          child: TextFormField(
                                            controller: emailController,
                                            style: AppTheme.theme.textTheme.bodyMedium,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: const InputDecoration(labelText: "Correo Electrónico"),
                                            validator: (value) {
                                              if (value == null || value.isEmpty || !EmailValidator.validate(value)) {
                                                return 'Proporciona un correo electrónico válido';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                                          child: TextFormField(
                                            controller: passwordController,
                                            style: AppTheme.theme.textTheme.bodyMedium,
                                            obscureText: true,
                                            decoration: const InputDecoration(labelText: "Contraseña"),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Proporciona una contraseña';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                              padding: const EdgeInsets.only(left: 10, top: 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  _goPasswordRecovery();
                                                },
                                                child: const Text('Olvidé mi contraseña'),
                                              )),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                                            child: ElevatedButton(
                                              style: AppTheme.theme.elevatedButtonTheme.style!
                                                  .copyWith(backgroundColor: MaterialStateProperty.all(AppTheme.accentColor)),
                                              onPressed: () {
                                                if (_formKey.currentState!.validate()) {
                                                  _login(context);
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Por favor revisa tus datos')),
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'Ingresar a mi cuenta',
                                                style: TextStyle(color: AppTheme.darkGray),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: ElevatedButton(
                                              onPressed: _goRegister,
                                              child: const Text('Aún no tengo una cuenta'),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                                            child: Center(
                                                child: Text(
                                              'Al ingresar aceptas nuestros Términos y condiciones, así como nuestro Aviso de Privacidad',
                                              textAlign: TextAlign.center,
                                              style: AppTheme.theme.textTheme.bodySmall!.copyWith(fontSize: 12),
                                            )))
                                      ],
                                    ),
                                  )),
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

  void _login(BuildContext context) {
    context.loaderOverlay.show();
    UserRepository().login(email: emailController.text, password: passwordController.text).then((value) async {
      _getUserData(context);
    }, onError: (error) {
      context.loaderOverlay.hide();
      showErrorDialog(context, message: error.message);
    });
  }

  void _getUserData(BuildContext context) {
    UserRepository().getCurrentUser().then((value) async {
      context.loaderOverlay.hide();
      await getWallet(context);
      _goHome();
    }, onError: (error) {
      context.loaderOverlay.hide();
      showErrorDialog(context, message: error.message);
    });
  }

  void _goPasswordRecovery() {
    Navigator.of(context).pushReplacementNamed('/password_recovery');
  }

  void _goHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _goRegister() {
    Navigator.of(context).pushReplacementNamed('/register');
  }
}

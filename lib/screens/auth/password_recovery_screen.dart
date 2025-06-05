import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:parkx/api/user_repository.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/logo_background.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:email_validator/email_validator.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  static const routeName = '/password_recovery';

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Column(
            children: <Widget>[
              const Expanded(flex: 1, child: LogoBackground()),
              Expanded(
                flex: 2,
                child: Container(
                  color: AppTheme.primaryColor,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
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
                                          "Olvidé mi contraseña",
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
                                                        return 'Proporciona un correo válido';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                                                    child: ElevatedButton(
                                                      style: AppTheme.theme.elevatedButtonTheme.style!.copyWith(
                                                        backgroundColor: MaterialStateProperty.all(AppTheme.accentColor),
                                                      ),
                                                      onPressed: () {
                                                        if (_formKey.currentState!.validate()) {
                                                          _goValidation(context);
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(const SnackBar(content: Text('Por favor revisa tus datos')));
                                                        }
                                                      },
                                                      child: const Text('Recuperar contraseña', style: TextStyle(color: AppTheme.darkGray)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    child: ElevatedButton(onPressed: _goLogin, child: const Text('Regresar a Ingresar')),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _goValidation(BuildContext context) {
    context.loaderOverlay.show();
    UserRepository()
        .recoveryPasswordStep1(email: emailController.text)
        .then(
          (value) async {
            context.loaderOverlay.hide();
            Navigator.of(context).pushReplacementNamed('/password_validation', arguments: {'email': emailController.text});
          },
          onError: (error) {
            context.loaderOverlay.hide();
            showErrorDialog(context, message: error.message);
          },
        );
  }

  void _goLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }
}

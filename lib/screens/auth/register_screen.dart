import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:parkx/api/user_repository.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/logo_background.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:parkx/utils/password_strings.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FlutterPwValidatorState> validatorKey = GlobalKey<FlutterPwValidatorState>();
  bool passwordPass = false;

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
                                "Registro",
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
                                            controller: nombreController,
                                            style: AppTheme.theme.textTheme.bodyMedium,
                                            decoration: const InputDecoration(labelText: "Nombre(s)"),
                                            keyboardType: TextInputType.text,
                                            textCapitalization: TextCapitalization.words,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Proporciona tu nombre(s)';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 5),
                                          child: TextFormField(
                                            controller: apellidoController,
                                            style: AppTheme.theme.textTheme.bodyMedium,
                                            decoration: const InputDecoration(labelText: "Apellidos"),
                                            keyboardType: TextInputType.text,
                                            textCapitalization: TextCapitalization.words,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Proporciona tus apellidos';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
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
                                          padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 10),
                                          child: TextFormField(
                                            controller: passwordController,
                                            style: AppTheme.theme.textTheme.bodyMedium,
                                            keyboardType: TextInputType.visiblePassword,
                                            obscureText: true,
                                            decoration: const InputDecoration(labelText: "Contraseña"),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Proporciona una contraseña';
                                              }
                                              if (value.length > 12) {
                                                return 'Máximo 12 caracteres';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        FlutterPwValidator(
                                          key: validatorKey,
                                          controller: passwordController,
                                          minLength: 8,
                                          uppercaseCharCount: 1,
                                          numericCharCount: 1,
                                          specialCharCount: 1,
                                          strings: PasswordStrings(),
                                          failureColor: AppTheme.errorColor,
                                          defaultColor: AppTheme.mediumGray,
                                          successColor: AppTheme.successColor,
                                          width: 300,
                                          height: 130,
                                          onSuccess: () {
                                            setState(() {
                                              passwordPass = true;
                                            });
                                          },
                                          onFail: () {
                                            setState(() {
                                              passwordPass = false;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                                            child: ElevatedButton(
                                              style: AppTheme.theme.elevatedButtonTheme.style!
                                                  .copyWith(backgroundColor: MaterialStateProperty.all(AppTheme.accentColor)),
                                              onPressed: () {
                                                if (_formKey.currentState!.validate() && passwordPass) {
                                                  _create(context);
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Por favor revisa tus datos')),
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'Crear Cuenta',
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
                                              onPressed: _goLogin,
                                              child: const Text('Ya tengo una cuenta'),
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

  void _create(BuildContext context) {
    context.loaderOverlay.show();
    UserRepository()
        .create(email: emailController.text, nombre: nombreController.text, apellidos: apellidoController.text, password: passwordController.text)
        .then((value) async {
      //analitycs.registerSignUp('Email');
      context.loaderOverlay.hide();
      _goCodeValidation();
    }, onError: (error) {
      context.loaderOverlay.hide();
      showErrorDialog(context, message: error.message);
    });
  }

  void _goLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _goCodeValidation() {
    Navigator.of(context).pushReplacementNamed('/code_validation');
  }
}

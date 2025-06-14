import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:parkx/api/user_repository.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/logo_background.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:parkx/utils/password_strings.dart';

class PasswordValidationScreen extends StatefulWidget {
  final String email;
  const PasswordValidationScreen({super.key, required this.email});

  static const routeName = '/password_validation';

  @override
  State<PasswordValidationScreen> createState() => _PasswordValidationScreenState();
}

class _PasswordValidationScreenState extends State<PasswordValidationScreen> {
  final _formKey = GlobalKey<FormState>();
  OtpTimerButtonController controller = OtpTimerButtonController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FlutterPwValidatorState> validatorKey = GlobalKey<FlutterPwValidatorState>();
  bool passwordPass = false;
  String verificationCode = '';
  bool _obscurePassword = true;

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
                  child: Form(
                    key: _formKey,
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
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Text(
                                              "Código de validación para cambio de contraseña",
                                              style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                            child: Text(
                                              'Por tu seguridad te enviamos un código de 5 dígitos a tu correo electrónico, este puede tardar hasta 1 minuto en llegar.',
                                              textAlign: TextAlign.center,
                                              style: AppTheme.theme.textTheme.bodyMedium,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                            child: PinCodeTextField(
                                              appContext: context,
                                              length: 5,
                                              controller: otpController,
                                              animationType: AnimationType.fade,
                                              keyboardType: TextInputType.number,
                                              pinTheme: PinTheme(
                                                shape: PinCodeFieldShape.box,
                                                borderRadius: BorderRadius.circular(10),
                                                fieldHeight: 70,
                                                fieldWidth: 50,
                                                activeFillColor: Colors.white,
                                              ),
                                              textStyle: const TextStyle(fontSize: 20),
                                              onChanged: (value) {},
                                              onCompleted: (code) {
                                                setState(() {
                                                  verificationCode = code;
                                                });
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 10),
                                            child: TextFormField(
                                              controller: passwordController,
                                              style: AppTheme.theme.textTheme.bodyMedium,
                                              keyboardType: TextInputType.visiblePassword,
                                              obscureText: _obscurePassword,
                                              decoration: InputDecoration(
                                                labelText: "Nueva Contraseña",
                                                suffixIcon: IconButton(
                                                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                                  onPressed: () {
                                                    setState(() {
                                                      _obscurePassword = !_obscurePassword;
                                                    });
                                                  },
                                                ),
                                              ),
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
                                          Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                                                  child: ElevatedButton(
                                                    style: AppTheme.theme.elevatedButtonTheme.style!.copyWith(
                                                      backgroundColor: WidgetStateProperty.all(AppTheme.accentColor),
                                                    ),
                                                    onPressed: () {
                                                      if (_formKey.currentState!.validate() && passwordPass) {
                                                        if (verificationCode.length == 5) {
                                                          _validate(context);
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(const SnackBar(content: Text('Proporciona el código de validación')));
                                                        }
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(const SnackBar(content: Text('Por favor revisa tus datos')));
                                                      }
                                                    },
                                                    child: const Text('Actualizar Contraseña', style: TextStyle(color: AppTheme.darkGray)),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 20),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                    child: ElevatedButton(onPressed: _goLogin, child: const Text('Regresar a Ingresar')),
                                                  ),
                                                ),
                                              ),
                                            ],
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
              ),
            ],
          );
        },
      ),
    );
  }

  void _validate(BuildContext context) async {
    context.loaderOverlay.show();
    try {
      await UserRepository().recoveryPasswordStep2(password: passwordController.text, email: widget.email, code: verificationCode);
      if (!mounted) return;
      context.loaderOverlay.hide();
      showSuccessDialog(
        context,
        message: 'Contraseña actualizada',
        onDismiss: () {
          Navigator.of(context).pushReplacementNamed('/login');
        },
      );
    } catch (error) {
      if (!mounted) return;
      context.loaderOverlay.hide();
      showErrorDialog(context, message: error is Exception && (error as dynamic).message != null ? (error as dynamic).message : error.toString());
    }
  }

  void _goLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }
}

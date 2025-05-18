import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:parkx/api/user_repository.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/logo_background.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:otp_timer_button/otp_timer_button.dart';

class CodeValidationScreen extends StatefulWidget {
  final String email;

  const CodeValidationScreen({super.key, required this.email});

  static const routeName = '/code_validation';

  @override
  State<CodeValidationScreen> createState() => _CodeValidationScreenState();
}

class _CodeValidationScreenState extends State<CodeValidationScreen> {
  OtpTimerButtonController controller = OtpTimerButtonController();
  TextEditingController otpController = TextEditingController();

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
                                "Código de validación",
                                style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                                  child: Text(
                                      'Por tu seguridad te enviamos un código de 5 dígitos a tu correo electrónico, este puede tardar hasta 1 minuto en llegar.',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.theme.textTheme.bodyMedium)),
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  child: PinCodeTextField(
                                    appContext: context,
                                    length: 5,
                                    controller: otpController,
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(10),
                                      fieldHeight: 50,
                                      fieldWidth: 50,
                                      activeFillColor: Colors.white,
                                    ),
                                    textStyle: const TextStyle(fontSize: 40),
                                    onCompleted: (verificationCode) {
                                      _validate(context, verificationCode);
                                    },
                                    onChanged: (value) {},
                                  )),
                              Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                                      child: OtpTimerButton(
                                        controller: controller,
                                        backgroundColor: AppTheme.accentColor,
                                        textColor: Colors.black,
                                        onPressed: () {},
                                        text: const Text('Reenviar código'),
                                        duration: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: ElevatedButton(
                                        onPressed: _goLogin,
                                        child: const Text('Regresar'),
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

  void _validate(BuildContext context, verificationCode) async {
    context.loaderOverlay.show();
    try {
      await UserRepository().confirmCode(email: widget.email, code: verificationCode);
      if (!mounted) return;
      context.loaderOverlay.hide();
      showSuccessDialog(context, message: 'Cuenta validada, usa tu correo y contraseña para entrar');
      _goLogin();
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

import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';

class ButtonApplePay extends StatelessWidget {
  final VoidCallback function;
  const ButtonApplePay({Key? key, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: AppTheme.theme.elevatedButtonTheme.style!.copyWith(
            elevation: MaterialStateProperty.all(0),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: MaterialStateProperty.all(const Color(0xFF545F71))),
        onPressed: function,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: SizedBox(
                  width: 10,
                  child: Icon(Icons.apple),
                )),
            Text(
              'Método de pago Apple Pay',
              style: TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';

class ButtonPrimary extends StatelessWidget {
  final String title;
  final VoidCallback function;
  const ButtonPrimary({Key? key, required this.title, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
        child: ElevatedButton(
          style: AppTheme.theme.elevatedButtonTheme.style!.copyWith(
              elevation: MaterialStateProperty.all(0),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor: MaterialStateProperty.all(AppTheme.primaryColor)),
          onPressed: function,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

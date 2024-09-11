import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';

class ButtonOutline extends StatelessWidget {
  final String title;
  final VoidCallback function;
  const ButtonOutline({Key? key, required this.title, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
        child: ElevatedButton(
          style: AppTheme.theme.outlinedButtonTheme.style!.copyWith(
              elevation: MaterialStateProperty.all(0),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor: MaterialStateProperty.all(Colors.white)),
          onPressed: function,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.primaryColor, fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';

class ButtonSecondary extends StatelessWidget {
  final String title;
  final VoidCallback function;
  final bool? active;
  const ButtonSecondary({Key? key, required this.title, required this.function, this.active = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = (active != false) ? AppTheme.primaryColor : AppTheme.disabledTextSecondary;
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ElevatedButton(
          style: AppTheme.theme.elevatedButtonTheme.style!.copyWith(
              elevation: MaterialStateProperty.all(0),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor: MaterialStateProperty.all(AppTheme.accentColor)),
          onPressed: (active != false) ? function : null,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

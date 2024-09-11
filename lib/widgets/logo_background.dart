import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';

class LogoBackground extends StatelessWidget {
  const LogoBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.primaryColor,
          AppTheme.primaryColor,
        ],
      )),
      child:
          const Padding(padding: EdgeInsets.only(top: 50), child: Center(child: SizedBox(child: Image(image: AssetImage('assets/images/logo.png'))))),
    );
  }
}

import 'package:flutter/material.dart';

class LogoBackgroundPadding extends StatelessWidget {
  const LogoBackgroundPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [SizedBox(child: Image(image: AssetImage('assets/images/logo-transparente.png')))],
        ));
  }
}

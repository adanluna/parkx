import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';

class AlertBox extends StatelessWidget {
  const AlertBox({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          color: AppTheme.darkGray,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            const SizedBox(child: Image(image: AssetImage('assets/images/alert_white.png'))),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              text,
              style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14, color: Colors.white, height: 1.1),
            ))
          ],
        ));
  }
}

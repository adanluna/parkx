import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';

class ButtonPrepaid extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback function;
  const ButtonPrepaid({Key? key, required this.title, this.subtitle, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton(
            style: AppTheme.theme.elevatedButtonTheme.style!.copyWith(
                elevation: MaterialStateProperty.all(0),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor: MaterialStateProperty.all(AppTheme.lightGray)),
            onPressed: function,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: AppTheme.primaryColor, fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    (subtitle != '')
                        ? Text(
                            subtitle ?? '',
                            style: const TextStyle(color: AppTheme.primaryColor, fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w600),
                          )
                        : Container()
                  ],
                ))),
      ),
    );
  }
}

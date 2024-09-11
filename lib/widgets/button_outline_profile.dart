import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';

class ButtonOutlineProfile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback function;
  const ButtonOutlineProfile({Key? key, required this.title, this.subtitle, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: ElevatedButton(
            style: AppTheme.theme.outlinedButtonTheme.style!.copyWith(
                elevation: MaterialStateProperty.all(0),
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: function,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text(
                            title,
                            style: const TextStyle(color: AppTheme.primaryColor, fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        (subtitle != '')
                            ? Text(
                                subtitle ?? '',
                                style:
                                    const TextStyle(color: AppTheme.primaryColor, fontFamily: 'Roboto', fontSize: 12, fontWeight: FontWeight.normal),
                              )
                            : Container()
                      ],
                    ),
                    const SizedBox(
                      width: 35,
                      child: Icon(
                        Icons.arrow_forward,
                        size: 35,
                      ),
                    )
                  ],
                ))),
      ),
    );
  }
}

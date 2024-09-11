import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';

class QuestionHelp extends StatefulWidget {
  final String title;
  final String description;
  const QuestionHelp({super.key, required this.title, required this.description});

  @override
  State<QuestionHelp> createState() => _QuestionHelpState();
}

class _QuestionHelpState extends State<QuestionHelp> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          active = (active) ? false : true;
        });
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryColor, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.left,
                      style: AppTheme.theme.textTheme.bodyMedium!.copyWith(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                    child: Icon(
                      (active) ? Icons.remove : Icons.add,
                      size: 25,
                      color: AppTheme.primaryColor,
                    ),
                  )
                ],
              ),
              (active)
                  ? Text(
                      widget.description,
                      textAlign: TextAlign.left,
                      style: AppTheme.theme.textTheme.bodySmall!.copyWith(color: AppTheme.primaryColor),
                    )
                  : Container()
            ]),
          )),
    );
  }
}

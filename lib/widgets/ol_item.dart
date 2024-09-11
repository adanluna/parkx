import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class OrderedListItem extends StatelessWidget {
  const OrderedListItem(this.number, this.text, {super.key});
  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
            width: 20,
            child: Text(
              '$number. ',
              style: AppTheme.theme.textTheme.bodySmall,
            )),
        Expanded(
          child: HtmlWidget(
            text,
            textStyle: AppTheme.theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

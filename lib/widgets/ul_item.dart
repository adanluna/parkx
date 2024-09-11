import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class UnorderedListItem extends StatelessWidget {
  const UnorderedListItem(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "• ",
          style: AppTheme.theme.textTheme.bodySmall,
        ),
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

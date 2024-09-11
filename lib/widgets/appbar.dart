import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? function;
  final bool withBackButton;
  const AppBarWidget({super.key, required this.title, required this.function, required this.withBackButton});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return (withBackButton)
        ? AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: function,
            ),
            title: Text(
              title,
              style: AppTheme.theme.textTheme.bodyMedium,
            ),
          )
        : AppBar(
            leading: null,
            title: Center(
                child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.theme.textTheme.bodyMedium,
            )),
          );
  }
}

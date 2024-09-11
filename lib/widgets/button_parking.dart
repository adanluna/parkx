import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';

class ButtonParking extends StatelessWidget {
  final String title;
  final String distance;
  final VoidCallback function;
  const ButtonParking({super.key, required this.title, required this.distance, required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primaryColor, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 270,
                      child: Text(
                        title,
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 270,
                      child: Text(
                        distance,
                        style: AppTheme.theme.textTheme.bodySmall!.copyWith(color: AppTheme.primaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward,
                  size: 35,
                  color: AppTheme.primaryColor,
                )
              ],
            ),
          )),
    );
  }
}

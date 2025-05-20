import 'package:flutter/material.dart';
import 'package:parkx/models/parking.dart';
import 'package:parkx/utils/app_theme.dart';

class ButtonParking extends StatelessWidget {
  final Parking parking;
  final VoidCallback function;
  const ButtonParking({super.key, required this.parking, required this.function});

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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parking.nombre,
                      style: AppTheme.theme.textTheme.bodyMedium!.copyWith(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      parking.estado,
                      style: AppTheme.theme.textTheme.bodyMedium!.copyWith(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      child: Text(
                        parking.direccion ?? '',
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(color: AppTheme.primaryColor, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward, size: 35, color: AppTheme.primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}

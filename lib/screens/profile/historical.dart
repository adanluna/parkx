import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/border_decoration.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_primary.dart';
import 'package:parkx/widgets/button_secondary.dart';

class HistoricalScreen extends StatefulWidget {
  const HistoricalScreen({super.key});

  static const routeName = '/historical';

  @override
  State<HistoricalScreen> createState() => _HistoricalScreenState();
}

class _HistoricalScreenState extends State<HistoricalScreen> {
  int showTab = 1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarWidget(
            title: 'Historial',
            withBackButton: true,
            function: () {
              Navigator.of(context).pop();
            }),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 130,
                          child: (showTab == 1)
                              ? ButtonSecondary(title: 'Abonos', function: () {})
                              : ButtonPrimary(
                                  title: 'Abonos',
                                  function: () {
                                    setState(() {
                                      showTab = 1;
                                    });
                                  }),
                        ),
                        SizedBox(
                          width: 130,
                          child: (showTab == 2)
                              ? ButtonSecondary(title: 'Pagos', function: () {})
                              : ButtonPrimary(
                                  title: 'Pagos',
                                  function: () {
                                    setState(() {
                                      showTab = 2;
                                    });
                                  }),
                        ),
                      ],
                    ),
                    (showTab == 1)
                        ? Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                                    children: [1, 2, 3, 4, 5, 6, 7, 8, 9]
                                        .map((index) =>
                                            _row('TRANSACCIÓN #012999393949', '12/09/2024 - 20:23 hrs', 'Recarga con Tarjeta de Crédito', '\$250'))
                                        .toList())))
                        : Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                                    children: [1, 2, 3, 4]
                                        .map((index) => _row('TRANSACCIÓN #1938488', '12/09/2024 - 20:23 hrs', 'Plaza Fiesta San Agustín', '\$300'))
                                        .toList())))
                  ],
                ))));
  }

  Widget _row(transaccion, fecha, lugar, monto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: boxDecoration(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaccion, style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(fecha, style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                    Text(lugar, style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.normal))
                  ],
                ),
              ),
              Text(monto, style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 18, fontWeight: FontWeight.bold))
            ],
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  static const routeName = '/sessions';

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  bool recibosAbonos = true;
  bool recibosPagos = false;

  final MaterialStateProperty<Icon?> thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(
          Icons.check,
          color: AppTheme.primaryColor,
        );
      }
      return const Icon(Icons.close, color: Colors.white);
    },
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
            title: 'Sesiones abiertas',
            withBackButton: true,
            function: () {
              Navigator.of(context).pop();
            }),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: AppTheme.primaryColor),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            'Apple - iPhone 14 Pro',
                                            style: TextStyle(
                                                color: AppTheme.primaryColor, fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: AppTheme.errorColor,
                                            borderRadius: BorderRadius.all(Radius.circular(50)),
                                          ),
                                          height: 30,
                                          width: 30,
                                          child: const Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ))
                                  ],
                                ))),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: AppTheme.primaryColor),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            'Samsung - Galaxy Note 3',
                                            style: TextStyle(
                                                color: AppTheme.primaryColor, fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: AppTheme.errorColor,
                                            borderRadius: BorderRadius.all(Radius.circular(50)),
                                          ),
                                          height: 30,
                                          width: 30,
                                          child: const Icon(
                                            Icons.close,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ))
                                  ],
                                ))),
                      ),
                    )
                  ],
                ))));
  }
}

import 'package:flutter/material.dart';
import 'package:parkx/models/user.dart';
import 'package:parkx/utils/account_manager.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/border_decoration.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';

class PersonalDataScreen extends StatefulWidget {
  const PersonalDataScreen({super.key});

  static const routeName = '/personal_data';

  @override
  State<PersonalDataScreen> createState() => _PersonalDataScreenState();
}

class _PersonalDataScreenState extends State<PersonalDataScreen> {
  final User? user = AccountManager.instance.user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
            title: 'Datos personales',
            withBackButton: true,
            function: () {
              Navigator.of(context).pop();
            }),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Mis datos',
                        style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: boxDecoration(),
                        child: Column(
                          children: [
                            _row('Nombre', '${user?.firstName} ${user?.lastName}'),
                            _row('Correo electrónico', user!.email),
                            _row('Género', 'Completar'),
                            _row('Cumpleaños', 'Completar'),
                          ],
                        )),
                    Padding(padding: const EdgeInsets.only(top: 20), child: ButtonSecondary(title: 'Editar datos personales', function: _goUpdate))
                  ],
                ))));
  }

  _goUpdate() {
    Navigator.of(context).pushNamed('/personal_data_update');
  }

  Widget _row(String text1, String text2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text1,
          style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14, color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
            child: Text(
          text2,
          style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14, color: AppTheme.primaryColor),
        ))
      ],
    );
  }
}

//import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:parkx/api/user_repository.dart';
import 'package:parkx/models/user.dart';
import 'package:parkx/utils/account_manager.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/utils/dialogs.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';

class PersonalDataUpdateScreen extends StatefulWidget {
  const PersonalDataUpdateScreen({super.key});

  static const routeName = '/personal_data_update';

  @override
  State<PersonalDataUpdateScreen> createState() => _PersonalDataUpdateScreenState();
}

class _PersonalDataUpdateScreenState extends State<PersonalDataUpdateScreen> {
  final User user = AccountManager.instance.user;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();

  @override
  void initState() {
    nombreController.text = user.firstName;
    apellidosController.text = user.lastName;
    super.initState();
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
            title: 'Editar datos personales',
            withBackButton: true,
            function: () {
              Navigator.of(context).pop();
            }),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Mis datos',
                      style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 20),
                              child: TextFormField(
                                autofocus: true,
                                controller: nombreController,
                                style: AppTheme.theme.textTheme.bodyMedium,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(labelText: "Nombre"),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Proporciona tu nombre';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 20),
                              child: TextFormField(
                                controller: apellidosController,
                                style: AppTheme.theme.textTheme.bodyMedium,
                                decoration: const InputDecoration(labelText: "Apellidos"),
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Proporciona tus apellidos';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            /*Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 20),
                              child: TextFormField(
                                controller: cvvController,
                                style: AppTheme.theme.textTheme.bodyMedium,
                                decoration: const InputDecoration(labelText: "Género"),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Proporciona el Género';
                                  }
                                  return null;
                                },
                              ),
                            ),*/
                            /*Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 20),
                              child: InputDatePickerFormField(
                                fieldLabelText: 'Cumpleaños',
                                keyboardType: TextInputType.datetime,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                onDateSubmitted: (date) {
                                  print(date);
                                  setState(() {
                                    //selectedDate = date;
                                  });
                                },
                                onDateSaved: (date) {
                                  print(date);
                                  setState(() {
                                    //selectedDate = date;
                                  });
                                },
                              ),
                            ),*/
                          ],
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
                      child: ButtonSecondary(
                        title: 'Guardar',
                        function: () {
                          if (_formKey.currentState!.validate()) {
                            _goUpdate(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Por favor revisa tus datos')),
                            );
                          }
                        },
                      )),
                ]))));
  }

  void _goUpdate(BuildContext context) {
    context.loaderOverlay.show();
    UserRepository().updatePersonalData(nombre: nombreController.text, apellidos: apellidosController.text).then((value) async {
      context.loaderOverlay.hide();
      _getUserData(context);
    }, onError: (error) {
      context.loaderOverlay.hide();
      showErrorDialog(context, message: error.message);
    });
  }

  void _getUserData(BuildContext context) {
    UserRepository().getCurrentUser().then((value) async {
      context.loaderOverlay.hide();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }, onError: (error) {
      context.loaderOverlay.hide();
      showErrorDialog(context, message: error.message);
    });
  }
}

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/button_secondary.dart';

class BillingUpdateScreen extends StatefulWidget {
  const BillingUpdateScreen({super.key});

  static const routeName = '/billing_update';

  @override
  State<BillingUpdateScreen> createState() => _BillingUpdateScreenState();
}

class _BillingUpdateScreenState extends State<BillingUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController numberController = TextEditingController();
  TextEditingController rfcController = TextEditingController();
  TextEditingController regimenController = TextEditingController();
  TextEditingController domicilioController = TextEditingController();
  TextEditingController coloniaController = TextEditingController();
  TextEditingController cpController = TextEditingController();
  TextEditingController usoController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWidget(
            title: 'Editar datos fiscales',
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
                      'Datos de facturaciòn',
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
                              controller: numberController,
                              style: AppTheme.theme.textTheme.bodyMedium,
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
                              controller: rfcController,
                              style: AppTheme.theme.textTheme.bodyMedium,
                              decoration: const InputDecoration(labelText: "RFC"),
                              validator: (value) {
                                if (value == null || value.isEmpty || !EmailValidator.validate(value)) {
                                  return 'Proporciona el RFC';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 20),
                            child: TextFormField(
                              controller: regimenController,
                              style: AppTheme.theme.textTheme.bodyMedium,
                              decoration: const InputDecoration(labelText: "Régimen fiscal"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Proporciona el Régimen fiscal';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 20),
                            child: TextFormField(
                              controller: domicilioController,
                              style: AppTheme.theme.textTheme.bodyMedium,
                              decoration: const InputDecoration(labelText: "Domicilio"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Proporciona el domicilio';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 20),
                            child: TextFormField(
                              controller: coloniaController,
                              style: AppTheme.theme.textTheme.bodyMedium,
                              decoration: const InputDecoration(labelText: "Colonia"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Proporciona la colonia';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 20),
                            child: TextFormField(
                              controller: cpController,
                              style: AppTheme.theme.textTheme.bodyMedium,
                              decoration: const InputDecoration(labelText: "Código Postal"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Proporciona el código postal';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 20),
                            child: TextFormField(
                              controller: usoController,
                              style: AppTheme.theme.textTheme.bodyMedium,
                              decoration: const InputDecoration(labelText: "Uso de CFDI"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Proporciona el Uso de CFDI';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
                      child: ButtonSecondary(
                        title: 'Guardar',
                        function: () {
                          if (_formKey.currentState!.validate()) {
                            _goUpdate();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Por favor revisa tus datos')),
                            );
                          }
                        },
                      )),
                ]))));
  }

  _goUpdate() {
    Navigator.of(context).pop();
  }
}

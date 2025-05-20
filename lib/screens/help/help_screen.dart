import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parkx/models/pregunta.dart';
import 'package:parkx/models/pregunta_seccion.dart';
import 'package:parkx/utils/app_theme.dart';
import 'package:parkx/widgets/appbar.dart';
import 'package:parkx/widgets/question_help.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:parkx/providers/preguntas_provider.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  static const routeName = '/help';

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController seccionController = TextEditingController();
  PreguntaSeccion? selectedSeccion;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    seccionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preguntasProvider = Provider.of<PreguntasProvider>(context);
    final secciones = preguntasProvider.secciones;

    return Scaffold(
      appBar: AppBarWidget(title: 'Ayuda', function: () {}, withBackButton: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16.0),
                child: ElevatedButton(
                  style: AppTheme.theme.elevatedButtonTheme.style!.copyWith(
                    elevation: MaterialStateProperty.all(0),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF25d366)),
                  ),
                  onPressed: _whatsapp,
                  child: const Text(
                    'Asistencia por Whatsapp',
                    style: TextStyle(color: Colors.black, fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              color: AppTheme.accentColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Preguntas Frecuentes',
                      textAlign: TextAlign.center,
                      style: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryColor),
                    ),
                    (secciones.isNotEmpty)
                        ? Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: SizedBox(
                            child: DropdownMenu<PreguntaSeccion>(
                              initialSelection: secciones[0],
                              controller: seccionController,
                              width: 300,
                              textStyle: AppTheme.theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                              inputDecorationTheme: InputDecorationTheme(
                                isDense: true,
                                fillColor: Colors.white,
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                constraints: BoxConstraints.tight(const Size.fromHeight(45)),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: AppTheme.primaryColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onSelected: (PreguntaSeccion? seccion) {
                                setState(() {
                                  selectedSeccion = seccion;
                                });
                              },
                              dropdownMenuEntries:
                                  secciones.map<DropdownMenuEntry<PreguntaSeccion>>((seccion) {
                                    return DropdownMenuEntry<PreguntaSeccion>(
                                      value: seccion,
                                      label: seccion.nombre,
                                      style: MenuItemButton.styleFrom(elevation: 0, textStyle: const TextStyle(fontSize: 14)),
                                    );
                                  }).toList(),
                            ),
                          ),
                        )
                        : const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
            (selectedSeccion != null && selectedSeccion!.preguntas != null)
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                        selectedSeccion!.preguntas!.map<Widget>((Pregunta item) {
                          return QuestionHelp(title: item.titulo, description: item.texto);
                        }).toList(),
                  ),
                )
                : Container(),
          ],
        ),
      ),
    );
  }

  _whatsapp() async {
    var phone = "+5218111868135";
    var texto = Uri.parse('Hola, me gustaría tener ayuda de la app Parkx');
    String url = "https://wa.me/$phone?text=$texto";
    await _launchInBrowser(url);
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}

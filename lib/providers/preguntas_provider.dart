import 'package:flutter/material.dart';
import 'package:parkx/api/config/api_base_helper.dart';
import 'package:parkx/models/pregunta_seccion.dart';

class PreguntasProvider with ChangeNotifier {
  final ApiBaseHelper _api = ApiBaseHelper();

  List<PreguntaSeccion> _secciones = [];
  List<PreguntaSeccion> get secciones => _secciones;

  Future<void> fetchPreguntas() async {
    try {
      final response = await _api.get(path: '/preguntas-frecuentes');

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        _secciones = data.map((item) => PreguntaSeccion.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Respuesta inválida del servidor');
      }
    } catch (e) {
      print('Error en PreguntasProvider: $e');
      rethrow;
    }
  }

  void clear() {
    _secciones.clear();
    notifyListeners();
  }
}

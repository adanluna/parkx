import 'package:flutter/material.dart';
import 'package:parkx/api/config/api_base_helper.dart';
import 'package:parkx/models/estado.dart';

class ParkingsProvider with ChangeNotifier {
  final ApiBaseHelper _api = ApiBaseHelper();

  List<Estado> _estados = [];
  List<Estado> get estados => _estados;

  Future<void> fetchEstados() async {
    try {
      final response = await _api.get(path: '/estados');

      if (response['status'] == true && response['estacionamiento'] != null) {
        final List<dynamic> data = response['estacionamiento'];
        _estados = data.map((e) => Estado.fromJson(e)).toList();

        notifyListeners();
      } else {
        throw Exception('Respuesta inválida del servidor');
      }
    } catch (e) {
      print('Error al cargar estados: $e');
      rethrow;
    }
  }

  void clear() {
    _estados.clear();
    notifyListeners();
  }
}

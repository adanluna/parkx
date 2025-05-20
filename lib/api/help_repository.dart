import 'package:parkx/api/config/api_base_helper.dart';
import 'package:parkx/models/pregunta_seccion.dart';

class HelpRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<PreguntaSeccion>> getPreguntasFrecuentes() async {
    try {
      final response = await _helper.get(path: '/preguntas-frecuentes');

      if (response is List) {
        return response.map((item) => PreguntaSeccion.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error en HelpRepository.getPreguntasFrecuentes: $e');
      return [];
    }
  }
}

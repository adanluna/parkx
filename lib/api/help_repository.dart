import 'package:parkx/api/config/api_base_helper.dart';
import 'package:parkx/models/preguntas_seccion.dart';

class HelpRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<PreguntasSeccion>> getPreguntasFrecuentes() async {
    try {
      final response = await _helper.get(path: '/mobile/preguntas-frecuentes');
      if (response is List) {
        return response.map((item) => PreguntasSeccion.fromJSON(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}

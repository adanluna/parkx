import 'package:parkx/api/config/api_base_helper.dart';

import 'package:parkx/models/state.dart';
import 'package:parkx/models/parking.dart';

class ParkingRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<StateModel>?> getStates() async {
    try {
      final response = await _helper.get(path: '/mobile/estados');
      return List.from(response.map((e) => StateModel.fromJSON(e)));
    } catch (e) {
      // Puedes agregar lógica específica si el error es de autorización
      return null;
    }
  }

  Future<List<Parking>?> searchState({required int estadoId, required int municipioId}) async {
    try {
      final response = await _helper.post(path: '/mobile/estacionamientos/encontrar/filtro', body: {
        'estadoId': estadoId,
        'municipioId': municipioId,
      });
      return List.from(response.map((e) => Parking.fromJSON(e)));
    } catch (e) {
      // Puedes agregar lógica específica si el error es de autorización
      return null;
    }
  }

  Future<List<Parking>?> searchGeo({required double lat, required double lng}) async {
    try {
      final response = await _helper.post(path: '/mobile/estacionamientos/encontrar', body: {"latitud": lat, "longitud": lng});
      return List.from(response.map((e) => Parking.fromJSON(e)));
    } catch (e) {
      // Puedes agregar lógica específica si el error es de autorización
      return null;
    }
  }
}

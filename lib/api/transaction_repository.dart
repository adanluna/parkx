import 'package:parkx/api/config/api_base_helper.dart';
import 'package:parkx/models/user.dart';
import 'package:parkx/utils/account_manager.dart';

class TransactionRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final User? user = AccountManager.instance.user;

  Future getAbonos(int pagina, int pageSize) async {
    try {
      final response = await _helper.post(path: '/transacciones/abonos', body: {'page': pagina.toString(), 'pagination': pageSize.toString()});
      return response['data'];
    } catch (e) {
      print('Error al obtener abonos: $e');
      rethrow;
    }
  }

  Future getPagos(int pagina, int pageSize) async {
    try {
      final response = await _helper.post(path: '/transacciones/pagos', body: {'page': pagina.toString(), 'pagination': pageSize.toString()});
      return response['data'];
    } catch (e) {
      print('Error al obtener pagos: $e');
      rethrow;
    }
  }
}

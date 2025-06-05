import 'package:parkx/api/config/api_base_helper.dart';
import 'package:parkx/models/user.dart';
import 'package:parkx/utils/account_manager.dart';

class PaymentRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();
  final User? user = AccountManager.instance.user;

  Future findCupon(String codigo, int estacionamientoId) async {
    try {
      final response = await _helper.post(path: '/cupon', body: {'codigo': codigo, 'estacionamiento_id': estacionamientoId});
      return response['data'];
    } catch (e) {
      print('Error al obtener el cupon: $e');
      rethrow;
    }
  }

  Future createPayment(total, comision, subtotal, boleto, cuponId, descuento, estacionamientoId) async {
    try {
      final response = await _helper.post(
        path: '/transacciones/create-payment',
        body: {
          'total': total,
          'comision': comision,
          'subtotal': subtotal,
          'descuento': descuento,
          'estacionamiento_id': estacionamientoId,
          'cupon': cuponId,
          'boleto': boleto,
        },
      );
      return response['data'];
    } catch (e) {
      print('Error al obtener pagos: $e');
      rethrow;
    }
  }
}

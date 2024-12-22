import 'package:parkx/api/config/api_base_helper.dart';
import 'package:parkx/api/config/api_exception.dart';
import 'package:parkx/models/user.dart';
import 'package:parkx/utils/account_manager.dart';

class UserRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<bool> login({
    required String username,
    required String password,
    required bool remember,
  }) async {
    AccountManager.instance.clearAuth();
    final response = await _helper.post(path: '/mobile/authenticate', body: {'username': username, 'password': password, 'rememberMe': remember});
    String token = response['id_token'];
    await AccountManager.instance.setAuth(user: User(), token: token);
    return true;
  }

  Future<bool> create({
    required String email,
    required String nombre,
    required String apellidos,
    required String password,
  }) async {
    await _helper.post(path: '/mobile/register', body: {
      'email': email,
      'firstName': nombre,
      'lastName': apellidos,
      'password': password,
      'login': email,
    });
    return true;
  }

  Future<bool> activate({
    required String code,
  }) async {
    await _helper.post(path: '/mobile/activate', body: {'key': code});
    return true;
  }

  Future<bool> updatePersonalData({
    required String nombre,
    required String apellidos,
    String? fechaNacimiento,
    int? estadoId,
    int? ciudadId,
    int? generoId,
  }) async {
    await _helper.post(path: '/mobile/account', body: {
      'firstName': nombre,
      'lastName': apellidos,
      /*'fecha_nacimiento': fechaNacimiento,
      'estado_id': estadoId,
      'ciudad_id': ciudadId,
      'genero_id': generoId,*/
    });
    return true;
  }

  Future<User> updatePassword({
    required String password,
  }) async {
    final response = await _helper.post(path: '/user/update', body: {
      'passord': password,
    });
    var data = response['data'];
    var user = User.fromJSON(data);
    return user;
  }

  Future<User> delete() async {
    final response = await _helper.post(path: '/user/delete');
    var data = response['data'];
    var user = User.fromJSON(data);
    return user;
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = await _helper.get(path: '/mobile/account');
      final user = User.fromJSON(response);
      AccountManager.instance.user = user;
      return user;
    } on UnauthorizedException catch (_) {
      return null;
    }
  }

  Future logout() async {
    try {
      await _helper.get(path: '/user/logout');
      return true;
    } on UnauthorizedException catch (_) {
      return null;
    }
  }

  Future<User> setPushToken({required String token}) async {
    final response = await _helper.post(path: '/user/fcm', body: {
      'token': token,
    });
    return User.fromJSON(response['data']);
  }

  Future<bool> recoveryPasswordStep1({
    required String email,
  }) async {
    AccountManager.instance.clearAuth();
    await _helper.post(path: '/mobile/account/reset-password/init', body: {'email': email});
    return true;
  }

  Future<bool> recoveryPasswordStep2({
    required String key,
    required String password,
  }) async {
    await _helper.post(path: '/mobile/account/reset-password/finish', body: {'key': key, 'newPassword': password});
    return true;
  }
}

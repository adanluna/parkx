import 'package:parkx/api/config/api_base_helper.dart';
import 'package:parkx/models/user.dart';
import 'package:parkx/utils/account_manager.dart';

class UserRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<bool> register({required String nombre, required String email, required String apellidos, required String password}) async {
    await _helper.post(
      path: '/register',
      body: {'name': nombre, 'apellidos': apellidos, 'email': email, 'password': password, 'password_confirmation': password},
    );
    return true;
  }

  Future<bool> sendVerificationCode({required String email}) async {
    await _helper.post(path: '/send-code', body: {'email': email});
    return true;
  }

  Future<bool> confirmCode({required String email, required String code}) async {
    await _helper.post(path: '/verify', body: {'email': email, 'code': code});
    return true;
  }

  Future<bool> login({required String email, required String password}) async {
    AccountManager.instance.clearAuth();
    final response = await _helper.post(path: '/login', body: {'email': email, 'password': password});
    String token = response['data']['token'];
    var user = User.fromJSON(response['data']['user']);
    await AccountManager.instance.setAuth(user: user, token: token);
    return true;
  }

  Future<bool> logout() async {
    try {
      await _helper.post(path: '/logout');
      await AccountManager.instance.clearAuth();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = await _helper.get(path: '/me');
      final user = User.fromJSON(response['user']);
      AccountManager.instance.user = user;
      return user;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<bool> updatePersonalData({
    required String name,
    required String apellidos,
    String? birthDate,
    int? stateId,
    int? cityId,
    int? genderId,
  }) async {
    await _helper.put(
      path: '/me',
      body: {
        'name': name,
        'apellidos': apellidos,
        if (birthDate != null) 'birth_date': birthDate,
        if (stateId != null) 'state_id': stateId,
        if (cityId != null) 'city_id': cityId,
        if (genderId != null) 'gender_id': genderId,
      },
    );
    return true;
  }

  Future<bool> updatePassword({required String password}) async {
    await _helper.put(path: '/me', body: {'password': password});
    return true;
  }

  Future<bool> deleteAccount() async {
    await _helper.delete(path: '/user');
    await AccountManager.instance.clearAuth();
    return true;
  }

  Future<bool> savePushToken({required String fcmToken}) async {
    await _helper.post(path: '/user/fcm', body: {'token': fcmToken});
    return true;
  }

  Future<bool> recoveryPasswordStep1({required String email}) async {
    await _helper.post(path: '/password/send-code', body: {'email': email});
    return true;
  }

  Future<bool> recoveryPasswordStep2({required String email, required String code, required String password}) async {
    await _helper.post(path: '/password/reset', body: {'code': code, 'email': email, 'password': password});
    return true;
  }

  Future<bool> resendVerificationCode({required String email}) async {
    await _helper.post(path: '/resend-code', body: {'email': email});
    return true;
  }
}

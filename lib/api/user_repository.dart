import 'package:parkx/api/config/api_base_helper.dart';
import 'package:parkx/models/user.dart';
import 'package:parkx/utils/account_manager.dart';

class UserRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<bool> register({required String nombre, required String email, required String apellidos, required String password}) async {
    try {
      await _helper.post(path: '/register', body: {
        'name': nombre,
        'apellidos': apellidos,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });
      return true;
    } catch (error) {
      print('Error en register: $error');
      return false;
    }
  }

  Future<bool> sendVerificationCode({required String email}) async {
    try {
      await _helper.post(path: '/send-code', body: {
        'email': email,
      });
      return true;
    } catch (error) {
      print('Error en sendVerificationCode: $error');
      return false;
    }
  }

  Future<bool> confirmCode({
    required String email,
    required String code,
  }) async {
    try {
      await _helper.post(path: '/verify', body: {
        'email': email,
        'code': code,
      });
      return true;
    } catch (error) {
      print('Error en confirmCode: $error');
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      AccountManager.instance.clearAuth();
      final response = await _helper.post(path: '/login', body: {
        'email': email,
        'password': password,
      });
      String token = response['data']['token'];
      var user = User.fromJSON(response['data']['user']);
      await AccountManager.instance.setAuth(user: user, token: token);
      return true;
    } catch (error) {
      print('Error en login: $error');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await _helper.post(path: '/logout');
      await AccountManager.instance.clearAuth();
      return true;
    } catch (error) {
      print('Error en logout: $error');
      return false;
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = await _helper.get(path: '/me');
      final user = User.fromJSON(response['user']);
      AccountManager.instance.user = user;
      return user;
    } catch (error) {
      print('Error en getCurrentUser: $error');
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
    try {
      await _helper.put(path: '/me', body: {
        'name': name,
        'apellidos': apellidos,
        if (birthDate != null) 'birth_date': birthDate,
        if (stateId != null) 'state_id': stateId,
        if (cityId != null) 'city_id': cityId,
        if (genderId != null) 'gender_id': genderId,
      });
      return true;
    } catch (error) {
      print('Error en updatePersonalData: $error');
      return false;
    }
  }

  Future<bool> updatePassword({required String password}) async {
    try {
      await _helper.put(path: '/me', body: {'password': password});
      return true;
    } catch (error) {
      print('Error en updatePassword: $error');
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      await _helper.delete(path: '/user');
      await AccountManager.instance.clearAuth();
      return true;
    } catch (error) {
      print('Error en deleteAccount: $error');
      return false;
    }
  }

  Future<bool> savePushToken({required String fcmToken}) async {
    try {
      await _helper.post(path: '/user/fcm', body: {
        'token': fcmToken,
      });
      return true;
    } catch (error) {
      print('Error en savePushToken: $error');
      return false;
    }
  }

  Future<bool> recoveryPasswordStep1({required String email}) async {
    try {
      await _helper.post(path: '/forgot-password', body: {
        'email': email,
      });
      return true;
    } catch (error) {
      print('Error en recoveryPasswordStep1: $error');
      return false;
    }
  }

  Future<bool> recoveryPasswordStep2({
    required String token,
    required String email,
    required String password,
  }) async {
    try {
      await _helper.post(path: '/reset-password', body: {
        'token': token,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });
      return true;
    } catch (error) {
      print('Error en recoveryPasswordStep2: $error');
      return false;
    }
  }

  Future<bool> resendVerificationCode({required String email}) async {
    try {
      await _helper.post(path: '/resend-code', body: {
        'email': email,
      });
      return true;
    } catch (error) {
      print('Error en resendVerificationCode: $error');
      return false;
    }
  }
}

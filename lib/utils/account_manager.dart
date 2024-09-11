import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parkx/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountManager {
  static final AccountManager instance = AccountManager._privateConstructor();

  final _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));
  late SharedPreferences _sharedPreferences;

  User? _user;
  String? _email;
  String? _authToken;

  AccountManager._privateConstructor();

  Future<String?> get authToken async {
    if (_authToken != null) return Future.value(_authToken);
    try {
      _authToken = await _secureStorage.read(key: 'authToken');
    } catch (e) {
      print(e);
      _authToken = null;
    }
    return _authToken;
  }

  set authToken(value) => _secureStorage.write(key: 'authToken', value: value);

  User get user => _user!;
  set user(value) => _user = value;

  String? get email {
    if (_email != null) {
      _email = _sharedPreferences.getString('email');
    }
    return _email;
  }

  Future configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future setAuth({required User user, required String token}) {
    _user = user;
    return Future.wait([_sharedPreferences.setString('email', user.email), _secureStorage.write(key: 'authToken', value: token)]);
  }

  Future clearAuth() async {
    _user = null;
    _authToken = null;
    return await _secureStorage.delete(key: 'authToken');
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parkx/models/estado.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parkx/models/user.dart';

class AccountManager {
  static final AccountManager instance = AccountManager._privateConstructor();

  final _secureStorage = const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
  late SharedPreferences _sharedPreferences;

  User? _user;
  String? _email;
  String? _authToken;
  Estado? _estado;

  AccountManager._privateConstructor();

  Future configure() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Get token (use this in ApiBaseHelper)
  Future<String?> getToken() async {
    if (_authToken != null) return _authToken;
    try {
      _authToken = await _secureStorage.read(key: 'authToken');
    } catch (e) {
      print("Token read error: $e");
    }
    return _authToken;
  }

  // Set token
  set authToken(String? value) {
    _authToken = value;
    if (value != null) {
      _secureStorage.write(key: 'authToken', value: value);
    } else {
      _secureStorage.delete(key: 'authToken');
    }
  }

  // Set auth (user + token)
  Future setAuth({required User user, required String token}) async {
    _user = user;
    _email = user.email;
    _authToken = token;
    await Future.wait([_sharedPreferences.setString('email', user.email), _secureStorage.write(key: 'authToken', value: token)]);
  }

  // Clear all auth info
  Future clearAuth() async {
    _user = null;
    _email = null;
    _authToken = null;
    await Future.wait([_secureStorage.delete(key: 'authToken'), _sharedPreferences.remove('email')]);
  }

  // Getters
  User? get user => _user;
  set user(User? value) => _user = value;

  String? get email => _email ?? _sharedPreferences.getString('email');

  // Set Estado (solo guarda el id)
  Future setEstado(Estado estado) async {
    _estado = estado;
    final estadoId = estado.id.toString();
    await Future.wait([_sharedPreferences.setString('estado_id', estadoId), _secureStorage.write(key: 'estado_id', value: estadoId)]);
  }

  Estado? get estado => _estado;

  // Get Estado id
  Future<int?> getEstadoId() async {
    String? idStr = _sharedPreferences.getString('estado_id');
    idStr ??= await _secureStorage.read(key: 'estado_id');
    if (idStr != null) {
      return int.tryParse(idStr);
    }
    return null;
  }
}

import 'package:dio/dio.dart';
import 'dart:io';
import 'package:parkx/utils/account_manager.dart';
import 'package:parkx/utils/flavor_config.dart';

class ApiBaseHelper {
  static final ApiBaseHelper _instance = ApiBaseHelper._internal();
  late final Dio _dio;

  factory ApiBaseHelper() {
    return _instance;
  }

  ApiBaseHelper._internal() {
    final flavor = FlavorConfig.instance.values;
    BaseOptions options = BaseOptions(
      baseUrl: "${flavor.scheme}://${flavor.hostName}/api",
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    );
    _dio = Dio(options);
  }

  Future<dynamic> get({required String path, Map<String, dynamic>? params}) => _request('GET', path, queryParameters: params);

  Future<dynamic> post({required String path, Map<String, dynamic>? body}) => _request('POST', path, data: body);

  Future<dynamic> patch({required String path, Map<String, dynamic>? body}) => _request('PATCH', path, data: body);

  Future<dynamic> delete({required String path, Map<String, dynamic>? body}) => _request('DELETE', path, data: body);

  Future<dynamic> put({required String path, Map<String, dynamic>? body}) => _request('PUT', path, data: body);

  Future<dynamic> _request(String method, String path, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data}) async {
    try {
      final token = await AccountManager.instance.getToken();
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final response = await _dio.request(path, data: data, queryParameters: queryParameters, options: Options(method: method));
      return response.data;
    } on SocketException catch (e) {
      // Captura errores de red como conexión rechazada
      throw Exception('Error de red: ${e.message}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 403 || e.response?.statusCode == 422 || e.response?.statusCode == 401) {
        throw ForbiddenException(e.response?.data);
      } else if (e.response?.statusCode == 500) {
        throw Exception('Error en el servidor: ${e.response?.data}');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Recurso no encontrado: ${e.response?.data}');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Error de solicitud: ${e.response?.data}');
      } else if (e.response?.statusCode == 402) {
        throw Exception('Error de solicitud: ${e.response?.data}');
      } else {
        throw Exception(e.toString());
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

class ForbiddenException implements Exception {
  final dynamic response;
  ForbiddenException(this.response);

  String get message {
    // Ajusta según la estructura de tu backend
    if (response is Map && response['message'] != null) {
      return response['message'];
    }
    return response.toString();
  }
}

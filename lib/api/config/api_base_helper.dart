import 'package:dio/dio.dart';
import 'package:parkx/utils/account_manager.dart';
import 'package:parkx/utils/flavor_config.dart';
import 'api_exception.dart';

class ApiBaseHelper {
  late Dio _dio;

  ApiBaseHelper() {
    final flavor = FlavorConfig.instance.values;

    BaseOptions options = BaseOptions(
      baseUrl: "${flavor.scheme}://${flavor.hostName}:${flavor.port}/api",
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _dio = Dio(options);
  }

  Future<dynamic> get({required String path, Map<String, dynamic>? params}) => _request('GET', path, queryParameters: params);

  Future<dynamic> post({required String path, Map<String, dynamic>? body}) => _request('POST', path, data: body);

  Future<dynamic> patch({required String path, Map<String, dynamic>? body}) => _request('PATCH', path, data: body);

  Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) async {
    try {
      final token = await AccountManager.instance.getToken();
      if (token != null) {
        _dio.options.headers['Authorization'] = 'Bearer $token';
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
      );

      return response.data;
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  dynamic _handleError(DioException e) {
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;

    switch (statusCode) {
      case 400:
        throw BadRequestException(responseJson: responseData);
      case 401:
      case 403:
        throw UnauthorizedException(responseJson: responseData);
      case 422:
        throw FailValidationRequestException(responseJson: responseData);
      case 500:
        throw InternalErrorException(responseJson: responseData);
      default:
        throw FetchDataException();
    }
  }
}

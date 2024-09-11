import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:parkx/api/config/api_exception.dart';
import 'package:parkx/utils/account_manager.dart';
import 'package:parkx/utils/flavor_config.dart';

class ApiBaseHelper {
  final _client = http.Client();
  final _accountManager = AccountManager.instance;

  Future<dynamic> get({required String path, Map<String, String>? params, Map<String, dynamic>? body}) =>
      request(method: 'GET', path: path, params: params, body: body);

  Future<dynamic> patch({required String path, Map<String, dynamic>? body}) => request(method: 'PATCH', path: path, body: body);

  Future<dynamic> post({required String path, Map<String, dynamic>? body}) => request(method: 'POST', path: path, body: body);

  Future<dynamic> request({
    required String method,
    required String path,
    Map<String, String>? params,
    Map<String, dynamic>? body,
  }) async {
    final authToken = await _accountManager.authToken;
    final uri = Uri(
        scheme: FlavorConfig.instance.values.scheme,
        host: FlavorConfig.instance.values.hostName,
        port: FlavorConfig.instance.values.port,
        path: "/api$path",
        queryParameters: params);

    var request = http.Request(method, uri);
    request.headers['Content-Type'] = 'application/json';
    request.headers['accept'] = 'application/json';
    if (authToken != null) {
      request.headers['Authorization'] = "Bearer $authToken";
    }
    if (body != null) {
      request.body = jsonEncode(body);
    }
    Future<dynamic> responseJson;
    try {
      final streamResponse = await _client.send(request).timeout(const Duration(seconds: 20));
      responseJson = _returnResponse(streamResponse);
      _updateAuthHeaders(streamResponse);
    } catch (e) {
      if (e is SocketException) {
        //treat SocketException
        print("Socket exception: ${e.toString()}");
        throw FetchDataException();
      } else if (e is TimeoutException) {
        //treat TimeoutException
        print("Timeout exception: ${e.toString()}");
        throw FetchDataException();
      } else {
        print("Unhandled exception: ${e.toString()}");
      }
      throw FetchDataException();
    }
    return responseJson;
  }

  dynamic _returnResponse(http.StreamedResponse response) async {
    final responseString = await response.stream.bytesToString();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(responseString);
      } on FormatException {
        print('JSON FormatException');
        return responseString;
      }
    } else {
      switch (response.statusCode) {
        case 302:
          print("BadRequest [${response.statusCode}]: $responseString");
          throw BadRequestException(responseJson: jsonDecode(responseString));
        case 400:
          print("BadRequest [${response.statusCode}]: $responseString");
          throw BadRequestException(responseJson: jsonDecode(responseString));
        case 401:
        case 403:
          print("Unauthorized [${response.statusCode}]: $responseString");
          throw UnauthorizedException(responseJson: jsonDecode(responseString));
        case 422:
          print("FailValidation [${response.statusCode}]: $responseString");
          throw FailValidationRequestException(responseJson: jsonDecode(responseString));
        case 500:
          print("FetchData [${response.statusCode}]: $responseString");
          throw InternalErrorException(responseJson: jsonDecode(responseString));
        default:
          print("FetchData [${response.statusCode}]: $responseString");
          throw FetchDataException();
      }
    }
  }

  void _updateAuthHeaders(http.StreamedResponse response) {
    if (response.headers.containsKey('Authorization')) {
      AccountManager.instance.authToken = response.headers['Authorization'];
    }
  }
}

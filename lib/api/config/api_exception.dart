abstract class ApiException implements Exception {
  Map<String, dynamic>? responseJson;

  String get message {
    var errors;
    if (responseJson!.containsKey('data')) {
      if (responseJson!['data'].containsKey('error')) {
        errors = responseJson!['data']['error'];
      }
    } else {
      if (responseJson!.containsKey('message')) {
        errors = responseJson!['message'];
      }

      if (responseJson!.containsKey('error')) {
        errors = responseJson!['error'];
      }
    }
    if (errors is List) {
      return errors[0].join(', ');
    }

    if (errors == null) {
      return responseJson!.values.join(', ');
    }

    return errors;
  }

  ApiException({this.responseJson});
}

class FetchDataException extends ApiException {
  @override
  String get message {
    return 'Ocurrió un error, contacta a soporte ';
  }
}

class InternalErrorException extends ApiException {
  InternalErrorException({required Map<String, dynamic> responseJson}) : super(responseJson: responseJson);
}

class BadRequestException extends ApiException {
  BadRequestException({required Map<String, dynamic> responseJson}) : super(responseJson: responseJson);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({required Map<String, dynamic> responseJson}) : super(responseJson: responseJson);
}

class InvalidInputException extends ApiException {
  InvalidInputException({required Map<String, dynamic> responseJson}) : super(responseJson: responseJson);
}

class ConnectionException extends ApiException {
  ConnectionException({required Map<String, dynamic> responseJson}) : super(responseJson: responseJson);
}

class FailValidationRequestException extends ApiException {
  FailValidationRequestException({required Map<String, dynamic> responseJson}) : super(responseJson: responseJson);
}

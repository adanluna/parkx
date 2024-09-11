import 'package:parkx/api/config/api_exception.dart';

class AppleException implements Exception {
  String message;

  AppleException({required this.message});
}

class AppleCancelledException extends ApiException {}

import 'dart:convert' as convert;

class ApiException implements Exception {
  final String? message;
  final int? statusCode;
  final String? body;

  ApiException([this.message, this.statusCode, this.body]);

  /// Get error code
  String? get errorCode {
    try {
      return body != null ? convert.jsonDecode(body!)['errorCode'] : null;
    } catch (e) {
      return null;
    }
  }

  @override

  /// Get exception message
  String toString() {
    return 'APIException: ${message ?? ""}\nStatus code: ${statusCode ?? ""}\nBody: ${body ?? ""}';
  }
}

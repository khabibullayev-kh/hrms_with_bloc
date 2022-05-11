enum ApiClientExceptionType { network, auth, other, sessionExpired, shiftIsWaiting }

class ApiClientException implements Exception {
  final ApiClientExceptionType type;
  final String? message;

  ApiClientException(this.type, {this.message = ''});
}
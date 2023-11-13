class NetworkException implements Exception {
  final String message;
  final String? statusCode;
  NetworkException(this.message, this.statusCode);

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}

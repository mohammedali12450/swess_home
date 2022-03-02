class ConnectionException implements Exception {
  final String errorMessage;

  ConnectionException({required this.errorMessage});
}

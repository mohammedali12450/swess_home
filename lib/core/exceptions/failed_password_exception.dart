// ignore_for_file: public_member_api_docs, sort_constructors_first
class FailedPasswordException implements Exception {
  final String? errorMessage;
  final int? statusCode;
  FailedPasswordException({
    this.errorMessage,
    this.statusCode,
  });
}

/// Custom exceptions for the application
/// Centralized error handling

/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => message;
}

/// Network-related exceptions
class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

/// Authentication exceptions
class AuthException extends AppException {
  AuthException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

/// Validation exceptions
class ValidationException extends AppException {
  ValidationException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

/// File upload exceptions
class FileUploadException extends AppException {
  FileUploadException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

/// Server exceptions
class ServerException extends AppException {
  ServerException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

/// Not found exceptions
class NotFoundException extends AppException {
  NotFoundException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

/// Unauthorized exceptions
class UnauthorizedException extends AppException {
  UnauthorizedException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

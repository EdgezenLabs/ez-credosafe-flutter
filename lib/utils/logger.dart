import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

/// Application logger utility
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to be displayed
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      dateTimeFormat: DateTimeFormat.none, // No timestamp in logs
    ),
    level: kDebugMode ? Level.debug : Level.info,
  );

  /// Log debug messages (only in debug mode)
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info messages
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning messages
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error messages
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal error messages
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
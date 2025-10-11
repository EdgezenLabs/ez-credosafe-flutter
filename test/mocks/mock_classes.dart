import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ez_credosafe_flutter/services/api_service.dart';
import 'package:ez_credosafe_flutter/providers/auth_provider.dart';
import 'package:ez_credosafe_flutter/models/otp.dart';

// Mock API Service
class MockApiService extends Mock implements ApiService {}

// Mock FlutterSecureStorage
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

// Mock Auth Provider
class MockAuthProvider extends Mock implements AuthProvider {}

// Mock OTP Response
class MockOtpResponse extends Mock implements OtpResponse {}

// Mock OTP Verification Response
class MockOtpVerificationResponse extends Mock implements OtpVerificationResponse {}

// Test data utilities
class TestDataUtils {
  static OtpResponse successOtpResponse() => OtpResponse(
    success: true,
    message: 'OTP sent successfully',
  );
  
  static OtpResponse failureOtpResponse() => OtpResponse(
    success: false,
    message: 'Failed to send OTP',
  );
  
  static OtpVerificationResponse successVerificationResponse() => OtpVerificationResponse(
    success: true,
    message: 'OTP verified successfully',
    token: 'test-token-123',
    user: {'id': 1, 'email': 'test@example.com'},
  );
  
  static OtpVerificationResponse failureVerificationResponse() => OtpVerificationResponse(
    success: false,
    message: 'Invalid OTP',
    token: null,
    user: null,
  );
}
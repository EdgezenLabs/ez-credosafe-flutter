import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ez_credosafe_flutter/providers/auth_provider.dart';
import 'package:ez_credosafe_flutter/models/otp.dart';
import '../mocks/mock_classes.dart';
import '../helpers/test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  group('AuthProvider Unit Tests', () {
    late MockApiService mockApiService;
    late MockFlutterSecureStorage mockStorage;
    late AuthProvider authProvider;

    setUp(() {
      mockApiService = MockApiService();
      mockStorage = MockFlutterSecureStorage();
      authProvider = AuthProvider(mockApiService, storage: mockStorage);
      
      // Setup default mock behavior for storage
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});
      when(() => mockStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async {});
    });

    tearDown(() {
      reset(mockApiService);
      reset(mockStorage);
    });

    group('Initial State', () {
      test('should have correct initial state', () {
        expect(authProvider.isLoggedIn, false);
        expect(authProvider.token, null);
        expect(authProvider.user, null);
        expect(authProvider.isLoading, false);
        expect(authProvider.error, null);
      });
    });

    group('Login', () {
      test('should login successfully with valid credentials', () async {
        // Arrange
        const email = TestData.validEmail;
        const password = TestData.validPassword;
        const token = TestData.validToken;
        
        when(() => mockApiService.login(email, password))
            .thenAnswer((_) async => {
                  'token': token,
                  'user': {'id': 1, 'email': email, 'name': 'Test User'}
                });

        // Act
        await authProvider.login(email, password);

        // Assert
        expect(authProvider.isLoggedIn, true);
        expect(authProvider.token, token);
        expect(authProvider.user?.email, email);
        expect(authProvider.isLoading, false);
        expect(authProvider.error, null);
        
        verify(() => mockApiService.login(email, password)).called(1);
      });

      test('should handle login failure', () async {
        // Arrange
        const email = TestData.validEmail;
        const password = 'wrongpassword';
        
        when(() => mockApiService.login(email, password))
            .thenThrow(Exception('Invalid credentials'));

        // Act & Assert
        expect(
          () => authProvider.login(email, password),
          throwsA(isA<Exception>()),
        );

        expect(authProvider.isLoggedIn, false);
        expect(authProvider.token, null);
        expect(authProvider.isLoading, false);
        expect(authProvider.error, isNotNull);
      });
    });

    group('Send OTP', () {
      test('should send OTP successfully', () async {
        // Arrange
        const email = TestData.validEmail;
        final otpResponse = OtpResponse(
          success: true,
          message: 'OTP sent successfully',
          sessionId: 'test-session-123',
        );
        
        when(() => mockApiService.sendOtp(email))
            .thenAnswer((_) async => otpResponse);

        // Act
        final result = await authProvider.sendOtp(email);

        // Assert
        expect(result.success, true);
        expect(result.message, 'OTP sent successfully');
        expect(authProvider.isLoading, false);
        expect(authProvider.error, null);
        
        verify(() => mockApiService.sendOtp(email)).called(1);
      });

      test('should handle OTP send failure', () async {
        // Arrange
        const email = TestData.validEmail;
        
        when(() => mockApiService.sendOtp(email))
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => authProvider.sendOtp(email),
          throwsA(isA<Exception>()),
        );

        expect(authProvider.isLoading, false);
        expect(authProvider.error, isNotNull);
      });
    });

    group('Verify OTP', () {
      test('should verify OTP successfully', () async {
        // Arrange
        const email = TestData.validEmail;
        const otp = TestData.validOtp;
        final verificationResponse = OtpVerificationResponse(
          success: true,
          message: 'OTP verified successfully',
          token: TestData.validToken,
          user: {'id': 1, 'email': email, 'name': 'Test User'},
        );
        
        when(() => mockApiService.verifyOtp(email, otp))
            .thenAnswer((_) async => verificationResponse);

        // Act
        final result = await authProvider.verifyOtp(email, otp);

        // Assert
        expect(result.success, true);
        expect(result.token, TestData.validToken);
        expect(authProvider.isLoggedIn, true);
        expect(authProvider.token, TestData.validToken);
        expect(authProvider.isLoading, false);
        expect(authProvider.error, null);
        
        verify(() => mockApiService.verifyOtp(email, otp)).called(1);
      });

      test('should handle OTP verification failure', () async {
        // Arrange
        const email = TestData.validEmail;
        const otp = 'invalid';
        final verificationResponse = OtpVerificationResponse(
          success: false,
          message: 'Invalid OTP',
          token: null,
          user: null,
        );
        
        when(() => mockApiService.verifyOtp(email, otp))
            .thenAnswer((_) async => verificationResponse);

        // Act
        final result = await authProvider.verifyOtp(email, otp);

        // Assert
        expect(result.success, false);
        expect(result.token, null);
        expect(authProvider.isLoggedIn, false);
        expect(authProvider.token, null);
        expect(authProvider.isLoading, false);
        
        verify(() => mockApiService.verifyOtp(email, otp)).called(1);
      });
    });

    group('Forgot Password', () {
      test('should send forgot password request successfully', () async {
        // Arrange
        const email = TestData.validEmail;
        
        when(() => mockApiService.forgotPassword(email))
            .thenAnswer((_) async => {'message': 'Reset link sent'});

        // Act
        await authProvider.forgotPassword(email);

        // Assert
        expect(authProvider.isLoading, false);
        expect(authProvider.error, null);
        
        verify(() => mockApiService.forgotPassword(email)).called(1);
      });

      test('should handle forgot password failure', () async {
        // Arrange
        const email = TestData.validEmail;
        
        when(() => mockApiService.forgotPassword(email))
            .thenThrow(Exception('Email not found'));

        // Act & Assert
        expect(
          () => authProvider.forgotPassword(email),
          throwsA(isA<Exception>()),
        );

        expect(authProvider.isLoading, false);
        expect(authProvider.error, isNotNull);
      });
    });

    group('Reset Password', () {
      test('should reset password successfully', () async {
        // Arrange
        const token = TestData.validToken;
        const newPassword = 'NewPass123!';
        
        when(() => mockApiService.resetPassword(token, newPassword))
            .thenAnswer((_) async => {'message': 'Password reset successfully'});

        // Act
        await authProvider.resetPassword(token, newPassword);

        // Assert
        expect(authProvider.isLoading, false);
        expect(authProvider.error, null);
        
        verify(() => mockApiService.resetPassword(token, newPassword)).called(1);
      });

      test('should handle reset password failure', () async {
        // Arrange
        const token = 'invalid-token';
        const newPassword = 'NewPass123!';
        
        when(() => mockApiService.resetPassword(token, newPassword))
            .thenThrow(Exception('Invalid token'));

        // Act & Assert
        expect(
          () => authProvider.resetPassword(token, newPassword),
          throwsA(isA<Exception>()),
        );

        expect(authProvider.isLoading, false);
        expect(authProvider.error, isNotNull);
      });
    });

    group('Logout', () {
      test('should logout successfully', () async {
        // Arrange - First login to have a token
        const email = TestData.validEmail;
        const password = TestData.validPassword;
        const token = TestData.validToken;
        
        when(() => mockApiService.login(email, password))
            .thenAnswer((_) async => {
                  'token': token,
                  'user': {'id': 1, 'email': email, 'name': 'Test User'}
                });

        await authProvider.login(email, password);
        expect(authProvider.isLoggedIn, true);

        // Act
        await authProvider.logout();

        // Assert
        expect(authProvider.isLoggedIn, false);
        expect(authProvider.token, null);
        expect(authProvider.user, null);
      });
    });

    group('Error Handling', () {
      test('should clear error when clearError is called', () async {
        // Arrange - Trigger an error
        const email = TestData.validEmail;
        
        when(() => mockApiService.sendOtp(email))
            .thenThrow(Exception('Network error'));

        try {
          await authProvider.sendOtp(email);
        } catch (e) {
          // Expected error
        }

        expect(authProvider.error, isNotNull);

        // Act
        authProvider.clearError();

        // Assert
        expect(authProvider.error, null);
      });
    });
  });
}

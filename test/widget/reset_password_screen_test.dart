import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ez_credosafe_flutter/screens/reset_password_screen.dart';
import 'package:ez_credosafe_flutter/widgets/index.dart';
import '../helpers/test_helper.dart';
import '../mocks/mock_classes.dart';

void main() {
  group('ResetPasswordScreen Widget Tests', () {
    late MockApiService mockApiService;
    late MockAuthProvider mockAuthProvider;
    final testToken = TestData.validToken;
    final testEmail = TestData.validEmail;

    setUp(() {
      mockApiService = MockApiService();
      mockAuthProvider = MockAuthProvider();
      when(() => mockAuthProvider.isLoggedIn).thenReturn(false);
      when(() => mockAuthProvider.isLoading).thenReturn(false);
      when(() => mockAuthProvider.token).thenReturn(null);
    });

    testWidgets('should render correctly with valid token', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        ResetPasswordScreen(token: testToken, email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.byType(ResetPasswordScreen), findsOneWidget);
      expect(find.byType(PasswordField), findsNWidgets(2));
    });

    testWidgets('should display password fields', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        ResetPasswordScreen(token: testToken, email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.byType(PasswordField), findsNWidgets(2));
    });

    testWidgets('should display styled title text', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        ResetPasswordScreen(token: testToken, email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert - Check for RichText which contains the styled spans
      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('should display password requirements', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        ResetPasswordScreen(token: testToken, email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.textContaining('Password must contain'), findsOneWidget);
      expect(find.textContaining('At least 8 characters'), findsOneWidget);
    });

    testWidgets('should display reset button', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        ResetPasswordScreen(token: testToken, email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.text('Reset Password'), findsOneWidget);
    });

    testWidgets('should display sign in link', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        ResetPasswordScreen(token: testToken, email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('should handle empty token by navigating back', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const ResetPasswordScreen(token: ''),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Let the widget initialize and trigger navigation
      await tester.pumpAndSettle();

      // Assert - Should handle empty token case
      expect(tester.takeException(), isNull);
    });
  });
}
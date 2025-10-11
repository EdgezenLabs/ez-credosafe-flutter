import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ez_credosafe_flutter/screens/forgot_password_screen.dart';
import 'package:ez_credosafe_flutter/widgets/index.dart';
import '../helpers/test_helper.dart';
import '../mocks/mock_classes.dart';

void main() {
  group('ForgotPasswordScreen Widget Tests', () {
    late MockApiService mockApiService;
    late MockAuthProvider mockAuthProvider;

    setUp(() {
      mockApiService = MockApiService();
      mockAuthProvider = MockAuthProvider();
      
      // Setup default mock behaviors
      when(() => mockAuthProvider.isLoading).thenReturn(false);
      when(() => mockAuthProvider.error).thenReturn(null);
    });

    tearDown(() {
      reset(mockApiService);
      reset(mockAuthProvider);
    });

    testWidgets('should display forgot password screen with all required elements', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const ForgotPasswordScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert - Check for components that definitely exist
      expect(find.byType(AppHeader), findsOneWidget);
      expect(find.byType(RichText), findsAtLeastNWidgets(1)); // RichText with the title
      expect(find.byType(CustomTextField), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
      expect(find.text('Sign In'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display instructions text', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const ForgotPasswordScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert - Look for the exact instruction text
      expect(
        find.text('Enter your email address and we\'ll send you a link to reset your password.'),
        findsOneWidget,
      );
    });

    testWidgets('should allow email input', (WidgetTester tester) async {
      // Arrange
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const ForgotPasswordScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Act
      await TestHelper.enterText(
        tester,
        TestData.validEmail,
        find.byType(CustomTextField),
      );

      // Assert
      expect(find.text(TestData.validEmail), findsOneWidget);
    });

    testWidgets('should validate email format', (WidgetTester tester) async {
      // Arrange
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const ForgotPasswordScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Act - Enter invalid email
      await TestHelper.enterText(
        tester,
        'invalid-email',
        find.byType(CustomTextField),
      );

      await TestHelper.tapAndPump(tester, find.text('Send Reset Link'));

      // Assert - Should show validation error
      expect(find.textContaining('valid email'), findsOneWidget);
    });

    testWidgets('should require email field', (WidgetTester tester) async {
      // Arrange
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const ForgotPasswordScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Act - Try to submit without email
      await TestHelper.tapAndPump(tester, find.text('Send Reset Link'));

      // Assert - Should show required field error
      expect(find.textContaining('required'), findsOneWidget);
    });

    testWidgets('should call forgotPassword when send button is pressed with valid email', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.forgotPassword(any())).thenAnswer((_) async {});

      await TestHelper.pumpWidgetWithProviders(
        tester,
        const ForgotPasswordScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Enter valid email
      await TestHelper.enterText(
        tester,
        TestData.validEmail,
        find.byType(CustomTextField),
      );

      // Act - Tap send button
      await TestHelper.tapAndPump(tester, find.text('Send Reset Link'));
      await TestHelper.pumpAndSettle(tester);

      // Assert
      verify(() => mockAuthProvider.forgotPassword(TestData.validEmail)).called(1);
    });

    testWidgets('should show loading state when request is in progress', (WidgetTester tester) async {
      // Arrange
      final completer = Completer<void>();
      when(() => mockAuthProvider.forgotPassword(any()))
          .thenAnswer((_) => completer.future);

      await TestHelper.pumpWidgetWithProviders(
        tester,
        const ForgotPasswordScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Enter email
      await TestHelper.enterTextAndPump(tester, find.byType(CustomTextField), TestData.validEmail);

      // Act - Tap send reset link button
      await TestHelper.tapAndPump(tester, find.text('Send Reset Link'));

      // Assert - Button should show loading state (disabled)
      final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(button.isLoading, isTrue);
      expect(button.onPressed, isNull);

      // Complete the future to avoid timer issues
      completer.complete();
      await TestHelper.pumpAndSettle(tester);
    });

    testWidgets('should navigate back when sign in link is tapped', (WidgetTester tester) async {
      // Arrange
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const ForgotPasswordScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Act - Tap sign in link
      await TestHelper.tapAndPump(tester, find.text('Sign In').last);
      await TestHelper.pumpAndSettle(tester);

      // Assert - Should not throw any errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('should navigate back when back button is pressed', (WidgetTester tester) async {
      // Arrange
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const ForgotPasswordScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Act - Tap back button (IconButton with arrow_back icon)
      await TestHelper.tapAndPump(tester, find.byIcon(Icons.arrow_back));
      await TestHelper.pumpAndSettle(tester);

      // Assert - Should not throw any errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('should show error message on request failure', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.forgotPassword(any()))
          .thenThrow(Exception('Email not found'));

      await TestHelper.pumpWidgetWithProviders(
        tester,
        const ForgotPasswordScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Enter valid email
      await TestHelper.enterText(
        tester,
        TestData.validEmail,
        find.byType(CustomTextField),
      );

      // Act - Tap send button
      await TestHelper.tapAndPump(tester, find.text('Send Reset Link'));
      await TestHelper.pumpAndSettle(tester);

      // Assert - Should show error snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Email not found'), findsOneWidget);
    });

    testWidgets('should disable button and show loading when submitting', (WidgetTester tester) async {
      // Arrange - Use Completer to control when the future completes
      final completer = Completer<void>();
      when(() => mockAuthProvider.forgotPassword(any()))
          .thenAnswer((_) => completer.future);

      await TestHelper.pumpWidgetWithProviders(
        tester,
        const ForgotPasswordScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Enter valid email
      await TestHelper.enterTextAndPump(
        tester,
        find.byType(CustomTextField),
        TestData.validEmail,
      );

      // Get initial button state
      final initialButton = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(initialButton.onPressed, isNotNull);
      expect(initialButton.isLoading, isFalse);

      // Act - Tap send button (don't pump yet to check immediate state)
      await tester.tap(find.text('Send Reset Link'));
      await tester.pump(); // Single pump to trigger state change

      // Assert - Button should show loading state after single pump
      final loadingButton = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(loadingButton.isLoading, isTrue);
      expect(loadingButton.onPressed, isNull);

      // Complete the future and wait for completion
      completer.complete();
      await TestHelper.pumpAndSettle(tester);
    });

    testWidgets('should display remember password link', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const ForgotPasswordScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.textContaining('Remember your password?'), findsOneWidget);
    });
  });
}
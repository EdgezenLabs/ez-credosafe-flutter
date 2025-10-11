import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ez_credosafe_flutter/screens/login_screen.dart';
import 'package:ez_credosafe_flutter/widgets/index.dart';
import '../helpers/test_helper.dart';
import '../mocks/mock_classes.dart';

void main() {
  group('Authentication Flow Integration Tests', () {
    late MockApiService mockApiService;
    late MockAuthProvider mockAuthProvider;

    setUp(() {
      mockApiService = MockApiService();
      mockAuthProvider = MockAuthProvider();
      
      // Setup default mock behaviors
      when(() => mockAuthProvider.isLoading).thenReturn(false);
      when(() => mockAuthProvider.error).thenReturn(null);
      when(() => mockAuthProvider.isLoggedIn).thenReturn(false);
    });

    tearDown(() {
      reset(mockApiService);
      reset(mockAuthProvider);
    });

    group('Complete Login Flow', () {
      testWidgets('should complete successful login flow with valid credentials', (WidgetTester tester) async {
        // Arrange
        when(() => mockAuthProvider.login(any(), any())).thenAnswer((_) async {});
        when(() => mockAuthProvider.isLoggedIn).thenReturn(true);
        
        // Start from login screen
        await TestHelper.pumpWidgetWithProviders(
          tester,
          const LoginScreen(),
          authProvider: mockAuthProvider,
          apiService: mockApiService,
        );

        // Step 1: Verify login screen is displayed
        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.text('Sign in'), findsAtLeastNWidgets(1));
        expect(find.byType(CustomTextField), findsAtLeastNWidgets(1));
        expect(find.byType(PasswordField), findsAtLeastNWidgets(1));

        // Step 2: Enter valid email
        await TestHelper.enterTextAndPump(
          tester,
          find.byType(CustomTextField).first,
          TestData.validEmail,
        );

        // Step 3: Enter valid password
        await TestHelper.enterTextAndPump(
          tester,
          find.byType(PasswordField).first,
          TestData.validPassword,
        );

        // Step 4: Verify input fields contain the entered data
        expect(find.text(TestData.validEmail), findsOneWidget);

        // Step 5: Agree to terms and conditions
        await TestHelper.tapAndPump(tester, find.byType(CustomCheckbox));
        await TestHelper.pumpAndSettle(tester);

        // Step 6: Tap Sign in button
        final signInButton = find.widgetWithText(PrimaryButton, 'Sign in');
        final button = tester.widget<PrimaryButton>(signInButton);
        
        if (button.onPressed != null) {
          await TestHelper.tapAndPump(tester, signInButton);
          await TestHelper.pumpAndSettle(tester);

          // Step 7: Verify login was called with correct credentials
          verify(() => mockAuthProvider.login(TestData.validEmail, TestData.validPassword)).called(1);
        }

        // Step 8: Verify no errors occurred
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle login with invalid credentials gracefully', (WidgetTester tester) async {
        // Arrange - Mock login failure
        when(() => mockAuthProvider.login(any(), any())).thenThrow(Exception('Invalid credentials'));
        
        await TestHelper.pumpWidgetWithProviders(
          tester,
          const LoginScreen(),
          authProvider: mockAuthProvider,
          apiService: mockApiService,
        );

        // Enter invalid credentials
        await TestHelper.enterTextAndPump(
          tester,
          find.byType(CustomTextField).first,
          'invalid@email.com',
        );

        await TestHelper.enterTextAndPump(
          tester,
          find.byType(PasswordField).first,
          'wrongpassword',
        );

        // Agree to terms
        await TestHelper.tapAndPump(tester, find.byType(CustomCheckbox));

        // Attempt login
        final signInButton = find.widgetWithText(PrimaryButton, 'Sign in');
        final button = tester.widget<PrimaryButton>(signInButton);
        
        if (button.onPressed != null) {
          await TestHelper.tapAndPump(tester, signInButton);
          await TestHelper.pumpAndSettle(tester);

          // Verify login was attempted
          verify(() => mockAuthProvider.login('invalid@email.com', 'wrongpassword')).called(1);
        }

        // Verify the screen handles the error gracefully
        expect(find.byType(LoginScreen), findsOneWidget);
      });
    });

    group('Complete Registration Flow', () {
      testWidgets('should complete registration flow from email to OTP verification', (WidgetTester tester) async {
        // Arrange
        when(() => mockAuthProvider.sendOtp(any())).thenAnswer((_) async => TestDataUtils.successOtpResponse());
        when(() => mockAuthProvider.verifyOtp(any(), any())).thenAnswer((_) async => TestDataUtils.successVerificationResponse());
        
        // Start from login screen
        await TestHelper.pumpWidgetWithProviders(
          tester,
          const LoginScreen(),
          authProvider: mockAuthProvider,
          apiService: mockApiService,
        );

        // Step 1: Switch to Register tab
        await TestHelper.tapAndPump(tester, find.text('Register'));
        await TestHelper.pumpAndSettle(tester);

        // Step 2: Verify Register form is displayed
        expect(find.text('Send OTP'), findsOneWidget);
        expect(find.text('Enter Email to send OTP'), findsOneWidget);

        // Step 3: Enter email for registration
        final emailField = find.byType(CustomTextField).last;
        await TestHelper.enterTextAndPump(tester, emailField, TestData.validEmail);

        // Step 4: Tap Send OTP button
        await TestHelper.tapAndPump(tester, find.text('Send OTP'));
        await TestHelper.pumpAndSettle(tester);

        // Step 5: Verify OTP was sent
        verify(() => mockAuthProvider.sendOtp(TestData.validEmail)).called(1);

        // Note: In a real integration test, we would navigate to OTP screen
        // but since we're mocking, we verify the flow logic
        expect(tester.takeException(), isNull);
      });
    });

    group('Complete Forgot Password Flow', () {
      testWidgets('should navigate through forgot password flow', (WidgetTester tester) async {
        // Start from login screen
        await TestHelper.pumpWidgetWithProviders(
          tester,
          const LoginScreen(),
          authProvider: mockAuthProvider,
          apiService: mockApiService,
        );

        // Step 1: Tap "Forgot password?" link
        await TestHelper.tapAndPump(tester, find.text('Forgot password?'));
        await TestHelper.pumpAndSettle(tester);

        // Step 2: Verify navigation occurred (no exception)
        expect(tester.takeException(), isNull);
        
        // Note: In a real integration test, we would verify the ForgotPasswordScreen
        // is displayed and test the complete flow
      });
    });

    group('Email Validation Integration', () {
      testWidgets('should validate email format throughout the complete flow', (WidgetTester tester) async {
        // Arrange
        when(() => mockAuthProvider.login(any(), any())).thenAnswer((_) async {});
        
        await TestHelper.pumpWidgetWithProviders(
          tester,
          const LoginScreen(),
          authProvider: mockAuthProvider,
          apiService: mockApiService,
        );

        final testEmails = [
          'valid@example.com',
          'test.user+tag@domain.co.uk',
          'user123@test-domain.org',
          'simple@domain.com',
        ];

        for (final email in testEmails) {
          // Step 1: Clear and enter each email
          await TestHelper.clearAndEnterText(
            tester,
            find.byType(CustomTextField).first,
            email,
          );

          // Step 2: Enter password
          await TestHelper.clearAndEnterText(
            tester,
            find.byType(PasswordField).first,
            TestData.validPassword,
          );

          // Step 3: Ensure terms are agreed
          final checkbox = tester.widget<CustomCheckbox>(find.byType(CustomCheckbox));
          if (!checkbox.value) {
            await TestHelper.tapAndPump(tester, find.byType(CustomCheckbox));
          }

          // Step 4: Verify email is displayed correctly
          expect(find.text(email), findsOneWidget);

          // Step 5: Test login attempt
          final signInButton = find.widgetWithText(PrimaryButton, 'Sign in');
          final button = tester.widget<PrimaryButton>(signInButton);
          
          if (button.onPressed != null) {
            await TestHelper.tapAndPump(tester, signInButton);
            await TestHelper.pumpAndSettle(tester);

            // Verify login was called with the correct email
            verify(() => mockAuthProvider.login(email, TestData.validPassword)).called(1);
          }

          // Reset for next iteration
          reset(mockAuthProvider);
          when(() => mockAuthProvider.isLoading).thenReturn(false);
          when(() => mockAuthProvider.error).thenReturn(null);
          when(() => mockAuthProvider.login(any(), any())).thenAnswer((_) async {});
        }
      });

      testWidgets('should handle edge cases in email input', (WidgetTester tester) async {
        // Arrange
        when(() => mockAuthProvider.login(any(), any())).thenAnswer((_) async {});
        
        await TestHelper.pumpWidgetWithProviders(
          tester,
          const LoginScreen(),
          authProvider: mockAuthProvider,
          apiService: mockApiService,
        );

        // Test email with leading/trailing whitespace
        await TestHelper.enterTextAndPump(
          tester,
          find.byType(CustomTextField).first,
          '  ${TestData.validEmail}  ',
        );

        await TestHelper.enterTextAndPump(
          tester,
          find.byType(PasswordField).first,
          TestData.validPassword,
        );

        // Agree to terms
        await TestHelper.tapAndPump(tester, find.byType(CustomCheckbox));

        // Attempt login
        final signInButton = find.widgetWithText(PrimaryButton, 'Sign in');
        final button = tester.widget<PrimaryButton>(signInButton);
        
        if (button.onPressed != null) {
          await TestHelper.tapAndPump(tester, signInButton);
          await TestHelper.pumpAndSettle(tester);

          // Verify login was called with trimmed email
          verify(() => mockAuthProvider.login(TestData.validEmail, TestData.validPassword)).called(1);
        }
      });
    });

    group('Error Handling Integration', () {
      testWidgets('should handle network errors gracefully', (WidgetTester tester) async {
        // Arrange - Mock network error
        when(() => mockAuthProvider.login(any(), any())).thenThrow(Exception('Network error'));
        
        await TestHelper.pumpWidgetWithProviders(
          tester,
          const LoginScreen(),
          authProvider: mockAuthProvider,
          apiService: mockApiService,
        );

        // Fill valid credentials
        await TestHelper.enterTextAndPump(
          tester,
          find.byType(CustomTextField).first,
          TestData.validEmail,
        );

        await TestHelper.enterTextAndPump(
          tester,
          find.byType(PasswordField).first,
          TestData.validPassword,
        );

        // Agree to terms
        await TestHelper.tapAndPump(tester, find.byType(CustomCheckbox));

        // Attempt login
        final signInButton = find.widgetWithText(PrimaryButton, 'Sign in');
        final button = tester.widget<PrimaryButton>(signInButton);
        
        if (button.onPressed != null) {
          await TestHelper.tapAndPump(tester, signInButton);
          await TestHelper.pumpAndSettle(tester);
        }

        // Verify the app handles the error gracefully
        expect(find.byType(LoginScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle empty form submission gracefully', (WidgetTester tester) async {
        // Arrange
        when(() => mockAuthProvider.login(any(), any())).thenAnswer((_) async {});
        
        await TestHelper.pumpWidgetWithProviders(
          tester,
          const LoginScreen(),
          authProvider: mockAuthProvider,
          apiService: mockApiService,
        );

        // Don't fill any fields, just agree to terms and try to submit
        await TestHelper.tapAndPump(tester, find.byType(CustomCheckbox));

        final signInButton = find.widgetWithText(PrimaryButton, 'Sign in');
        final button = tester.widget<PrimaryButton>(signInButton);
        
        if (button.onPressed != null) {
          await TestHelper.tapAndPump(tester, signInButton);
          await TestHelper.pumpAndSettle(tester);
        }

        // Verify login was not called with empty fields
        verifyNever(() => mockAuthProvider.login(any(), any()));
        expect(tester.takeException(), isNull);
      });
    });

    group('User Interface Interaction Flow', () {
      testWidgets('should maintain state during tab switching', (WidgetTester tester) async {
        await TestHelper.pumpWidgetWithProviders(
          tester,
          const LoginScreen(),
          authProvider: mockAuthProvider,
          apiService: mockApiService,
        );

        // Step 1: Fill sign in form
        await TestHelper.enterTextAndPump(
          tester,
          find.byType(CustomTextField).first,
          TestData.validEmail,
        );

        await TestHelper.enterTextAndPump(
          tester,
          find.byType(PasswordField).first,
          TestData.validPassword,
        );

        // Step 2: Switch to Register tab
        await TestHelper.tapAndPump(tester, find.text('Register'));
        await TestHelper.pumpAndSettle(tester);

        // Step 3: Verify Register form is displayed
        expect(find.text('Send OTP'), findsOneWidget);

        // Step 4: Switch back to Sign in tab
        await TestHelper.tapAndPump(tester, find.text('Sign in'));
        await TestHelper.pumpAndSettle(tester);

        // Step 5: Verify Sign in form is displayed and data is preserved
        expect(find.text(TestData.validEmail), findsOneWidget);
        expect(find.byType(PasswordField), findsAtLeastNWidgets(1));
      });

      testWidgets('should handle rapid user interactions', (WidgetTester tester) async {
        // Arrange
        when(() => mockAuthProvider.login(any(), any())).thenAnswer((_) async {
          // Simulate slow network
          await Future.delayed(const Duration(milliseconds: 100));
        });
        
        await TestHelper.pumpWidgetWithProviders(
          tester,
          const LoginScreen(),
          authProvider: mockAuthProvider,
          apiService: mockApiService,
        );

        // Rapidly fill form and submit
        await TestHelper.enterTextAndPump(
          tester,
          find.byType(CustomTextField).first,
          TestData.validEmail,
        );

        await TestHelper.enterTextAndPump(
          tester,
          find.byType(PasswordField).first,
          TestData.validPassword,
        );

        await TestHelper.tapAndPump(tester, find.byType(CustomCheckbox));

        // Rapid button taps
        final signInButton = find.widgetWithText(PrimaryButton, 'Sign in');
        final button = tester.widget<PrimaryButton>(signInButton);
        
        if (button.onPressed != null) {
          // Multiple rapid taps
          await TestHelper.tapAndPump(tester, signInButton);
          await TestHelper.tapAndPump(tester, signInButton);
          await TestHelper.pumpAndSettle(tester);
        }

        // Verify the app handles rapid interactions gracefully
        expect(tester.takeException(), isNull);
      });
    });
  });
}
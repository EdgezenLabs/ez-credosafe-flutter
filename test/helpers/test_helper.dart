import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ez_credosafe_flutter/providers/auth_provider.dart';
import 'package:ez_credosafe_flutter/providers/loans_provider.dart';
import 'package:ez_credosafe_flutter/services/api_service.dart';

/// Helper class for common test utilities
class TestHelper {
  /// Creates a MaterialApp wrapper with providers for testing widgets
  static Widget createTestApp({
    required Widget child,
    AuthProvider? authProvider,
    LoansProvider? loansProvider,
    ApiService? apiService,
  }) {
    final api = apiService ?? ApiService();
    final auth = authProvider ?? AuthProvider(api);
    final loans = loansProvider ?? LoansProvider(api, auth);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: auth),
        ChangeNotifierProvider<LoansProvider>.value(value: loans),
      ],
      child: MaterialApp(
        home: child,
        routes: {
          '/login': (context) => const Scaffold(body: Text('Login Screen')),
          '/loans': (context) => const Scaffold(body: Text('Loans Screen')),
          '/otp': (context) => const Scaffold(body: Text('OTP Screen')),
          '/success': (context) => const Scaffold(body: Text('Success Screen')),
          '/forgot-password': (context) => const Scaffold(body: Text('Forgot Password Screen')),
          '/reset-password': (context) => const Scaffold(body: Text('Reset Password Screen')),
        },
      ),
    );
  }

  /// Pump widget with providers
  static Future<void> pumpWidgetWithProviders(
    WidgetTester tester,
    Widget widget, {
    AuthProvider? authProvider,
    LoansProvider? loansProvider,
    ApiService? apiService,
  }) async {
    await tester.pumpWidget(
      createTestApp(
        child: widget,
        authProvider: authProvider,
        loansProvider: loansProvider,
        apiService: apiService,
      ),
    );
  }

  /// Enter text in a TextField and pump
  static Future<void> enterTextAndPump(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.tap(finder);
    await tester.pump();
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Enter text in a TextField
  static Future<void> enterText(
    WidgetTester tester,
    String text,
    Finder finder,
  ) async {
    await tester.tap(finder);
    await tester.pump();
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Clear and enter text in a TextField
  static Future<void> clearAndEnterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.tap(finder);
    await tester.pump();
    // Clear the field first
    await tester.enterText(finder, '');
    await tester.pump();
    // Then enter the new text
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Tap a widget and wait for animation
  static Future<void> tapAndPump(
    WidgetTester tester,
    Finder finder, {
    Duration? duration,
  }) async {
    await tester.tap(finder);
    await tester.pump(duration ?? const Duration(milliseconds: 100));
  }

  /// Wait for async operations
  static Future<void> pumpAndSettle(
    WidgetTester tester, {
    Duration? duration,
  }) async {
    await tester.pumpAndSettle(duration ?? const Duration(seconds: 2));
  }

  /// Find widgets by key string
  static Finder findByKeyString(String key) => find.byKey(Key(key));

  /// Find widgets by text
  static Finder findByText(String text) => find.text(text);

  /// Find widgets by type
  static Finder findByType<T>() => find.byType(T);

  /// Verify that a widget exists
  static void expectWidgetExists(Finder finder) {
    expect(finder, findsOneWidget);
  }

  /// Verify that a widget doesn't exist
  static void expectWidgetNotExists(Finder finder) {
    expect(finder, findsNothing);
  }

  /// Verify that multiple widgets exist
  static void expectMultipleWidgets(Finder finder, int count) {
    expect(finder, findsNWidgets(count));
  }
}

/// Test data constants
class TestData {
  static const String validEmail = 'test@example.com';
  static const String invalidEmail = 'invalid-email';
  static const String validOtp = '123456';
  static const String invalidOtp = '000000';
  static const String validPassword = 'TestPassword123!';
  static const String weakPassword = '123';
  static const String strongPassword = 'StrongPassword123!';
  static const String validToken = 'test-token-123';
}
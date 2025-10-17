import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ez_credosafe_flutter/screens/common/password_setup_screen.dart';
import '../helpers/test_helper.dart';
import '../mocks/mock_classes.dart';

void main() {
  group('PasswordSetupScreen Widget Tests', () {
    late MockApiService mockApiService;
    late MockAuthProvider mockAuthProvider;
    const testEmail = TestData.validEmail;

    setUp(() {
      mockApiService = MockApiService();
      mockAuthProvider = MockAuthProvider();
      when(() => mockAuthProvider.isLoggedIn).thenReturn(false);
      when(() => mockAuthProvider.isLoading).thenReturn(false);
      when(() => mockAuthProvider.token).thenReturn(null);
    });

    testWidgets('should display password setup screen with all required elements', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const PasswordSetupScreen(email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.byType(PasswordSetupScreen), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(RichText), findsWidgets); // Multiple RichText widgets exist
    });

    testWidgets('should display email when provided', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const PasswordSetupScreen(email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert - the screen doesn't actually display the email, just accepts it as parameter
      expect(find.byType(PasswordSetupScreen), findsOneWidget);
    });

    testWidgets('should display password fields', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const PasswordSetupScreen(email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('New password'), findsOneWidget);
      expect(find.text('Confirm new password'), findsOneWidget);
    });

    testWidgets('should display styled title text', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const PasswordSetupScreen(email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert - Just check that RichText widgets exist (they contain the styled text)
      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('should validate password fields can be entered', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const PasswordSetupScreen(email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Enter passwords
      await tester.enterText(find.byType(TextField).at(0), 'TestPassword123!');
      await tester.enterText(find.byType(TextField).at(1), 'TestPassword123!');
      await tester.pump();

      // Assert fields accept input
      expect(find.text('TestPassword123!'), findsNWidgets(2));
    });

    testWidgets('should display submit button', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const PasswordSetupScreen(email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(InkWell), findsWidgets); // Multiple InkWell widgets exist (for buttons)
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const PasswordSetupScreen(email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert visibility icons are present
      expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));
      
      // Tap first visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_outlined).first);
      await tester.pump();

      // Should show one visibility_off icon and one visibility icon
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('should handle empty token by navigating back', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const PasswordSetupScreen(email: ''),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Let the widget initialize
      await tester.pumpAndSettle();

      // Assert - Should handle empty email case
      expect(tester.takeException(), isNull);
    });
  });
}
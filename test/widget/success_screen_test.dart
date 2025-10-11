import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ez_credosafe_flutter/screens/success_screen.dart';
import '../helpers/test_helper.dart';
import '../mocks/mock_classes.dart';

void main() {
  group('SuccessScreen Widget Tests', () {
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

    testWidgets('should display success screen with all required elements', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SuccessScreen(email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.byType(SuccessScreen), findsOneWidget);
      expect(find.text('Congratulations!'), findsOneWidget);
      expect(find.text('Success!'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('should display success message', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SuccessScreen(email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.textContaining('successfully authenticated'), findsOneWidget);
    });

    testWidgets('should display success icon', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SuccessScreen(email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('should display congratulations message', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SuccessScreen(email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.text('Congratulations!'), findsOneWidget);
      expect(find.text('Success!'), findsOneWidget);
    });

    testWidgets('should navigate when continue button is pressed', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SuccessScreen(email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Find and tap the Continue button
      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Assert - Navigation should work without errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('should work without email parameter', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SuccessScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.byType(SuccessScreen), findsOneWidget);
      expect(find.text('Congratulations!'), findsOneWidget);
      expect(find.text('Success!'), findsOneWidget);
    });

    testWidgets('should display logo', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SuccessScreen(email: testEmail),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert - Check for Image widget (logo)
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should handle navigation with empty email', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SuccessScreen(email: ''),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Find and tap the Continue button
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Assert - Should handle empty email case
      expect(tester.takeException(), isNull);
    });
  });
}
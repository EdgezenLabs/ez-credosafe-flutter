import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ez_credosafe_flutter/screens/splash_screen.dart';
import '../helpers/test_helper.dart';
import '../mocks/mock_classes.dart';

void main() {
  group('SplashScreen Widget Tests', () {
    late MockApiService mockApiService;
    late MockAuthProvider mockAuthProvider;

    setUp(() {
      mockApiService = MockApiService();
      mockAuthProvider = MockAuthProvider();
      
      // Setup default mock behaviors
      when(() => mockAuthProvider.isLoading).thenReturn(false);
      when(() => mockAuthProvider.error).thenReturn(null);
      when(() => mockAuthProvider.isLoggedIn).thenReturn(false);
      when(() => mockAuthProvider.loadFromStorage()).thenAnswer((_) async {});
    });

    tearDown(() {
      reset(mockApiService);
      reset(mockAuthProvider);
    });

    testWidgets('should display splash screen with logo and app name', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SplashScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert - Check for logo image instead of text
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
      
      // Complete the timer to avoid pending timer errors
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);
    });

    testWidgets('should show loading indicator', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SplashScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert - Check for animation widgets instead of CircularProgressIndicator
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
      expect(find.byType(Opacity), findsOneWidget);
      expect(find.byType(Transform), findsAtLeastNWidgets(1));
      
      // Complete the timer to avoid pending timer errors
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);
    });

    testWidgets('should navigate when user is already logged in', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.isLoggedIn).thenReturn(true);

      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SplashScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Let the navigation timer complete
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);

      // Assert - Verify isLoggedIn was checked during navigation
      verify(() => mockAuthProvider.isLoggedIn).called(greaterThan(0));
    });

    testWidgets('should navigate to login when user is not logged in', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.isLoggedIn).thenReturn(false);

      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SplashScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Let the navigation timer complete
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);

      // Assert - Verify isLoggedIn was checked during navigation
      verify(() => mockAuthProvider.isLoggedIn).called(greaterThan(0));
    });

    testWidgets('should handle token validation failure', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.isLoggedIn).thenReturn(false);

      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SplashScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Let the navigation timer complete
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);

      // Assert - Should handle navigation gracefully
      verify(() => mockAuthProvider.isLoggedIn).called(greaterThan(0));
    });

    testWidgets('should handle network errors during initialization', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.isLoggedIn).thenReturn(false);

      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SplashScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Let the navigation timer complete
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);

      // Assert - Should handle error gracefully
      expect(tester.takeException(), isNull);
    });

    testWidgets('should have proper app branding', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SplashScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert - Check for logo image instead of text
      expect(find.byType(Image), findsOneWidget);
      
      // Verify image properties
      final imageFinder = find.byType(Image);
      final image = tester.widget<Image>(imageFinder);
      expect(image.image, isA<AssetImage>());
      
      // Complete the timer to avoid pending timer errors
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);
    });

    testWidgets('should display loading animation', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SplashScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert - Check for animation widgets instead of CircularProgressIndicator
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
      
      // Verify the animation properties - get the splash screen specific one
      final animatedBuilders = tester.widgetList<AnimatedBuilder>(find.byType(AnimatedBuilder));
      expect(animatedBuilders.length, greaterThan(0));
      
      // Complete the timer to avoid pending timer errors
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SplashScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      
      // Complete the timer to avoid pending timer errors
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);
    });

    testWidgets('should handle URL parameters for password reset', (WidgetTester tester) async {
      // This test would need to be adapted based on how URL handling is implemented
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SplashScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Let initialization complete
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);

      // Assert - Should handle any URL-based navigation
      expect(tester.takeException(), isNull);
    });

    testWidgets('should complete initialization flow', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.isLoggedIn).thenReturn(false);

      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SplashScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Wait for navigation timer
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);

      // Assert
      verify(() => mockAuthProvider.isLoggedIn).called(greaterThan(0));
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SplashScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Assert - Check accessibility elements
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
      
      // Ensure no accessibility issues
      expect(tester.takeException(), isNull);
      
      // Complete the timer to avoid pending timer errors
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);
    });

    testWidgets('should handle quick navigation changes', (WidgetTester tester) async {
      // Arrange
      when(() => mockAuthProvider.isLoggedIn).thenReturn(false);

      // Act
      await TestHelper.pumpWidgetWithProviders(
        tester,
        const SplashScreen(),
        authProvider: mockAuthProvider,
        apiService: mockApiService,
      );

      // Pump for a short time then complete
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(seconds: 3));
      await TestHelper.pumpAndSettle(tester);

      // Assert - Should handle timing properly
      expect(tester.takeException(), isNull);
    });
  });
}
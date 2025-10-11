import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/loans_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/success_screen.dart';
import 'screens/password_setup_screen.dart';
import 'screens/loan_list_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/reset_password_screen.dart';

// Conditional import for web
import 'dart:html' as html if (dart.library.html) 'dart:html';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final api = ApiService();
  final auth = AuthProvider(api);
  await auth.loadFromStorage();
  runApp(MyApp(auth: auth, api: api));
}

class MyApp extends StatelessWidget {
  final AuthProvider auth;
  final ApiService api;
  const MyApp({required this.auth, required this.api, super.key});

  // Custom route generator to handle URL parameters
  Route<dynamic>? _generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');
    final path = uri.path;
    final queryParams = uri.queryParameters;

    // For web, try to get query params from the current URL
    Map<String, String> webQueryParams = {};
    if (kIsWeb) {
      try {
        final webUri = Uri.parse(kIsWeb ? html.window.location.href : '');
        webQueryParams = webUri.queryParameters;
      } catch (e) {
        // If there's an error, use empty params
        webQueryParams = {};
      }
    }

    // Merge query params (prefer web params for reset password)
    final allParams = {...queryParams, ...webQueryParams};

    switch (path) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/reset-password':
        final token = allParams['token'] ?? '';
        final email = allParams['email'] ?? '';
        if (token.isNotEmpty) {
          return MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(token: token, email: email),
          );
        } else {
          // If no token, redirect to login
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
      case '/otp':
        final email = allParams['email'] ?? '';
        return MaterialPageRoute(
          builder: (_) => OTPVerificationScreen(email: email),
        );
      case '/success':
        return MaterialPageRoute(builder: (_) => const SuccessScreen());
      case '/password-setup':
        final email = allParams['email'] ?? '';
        return MaterialPageRoute(
          builder: (_) => PasswordSetupScreen(email: email),
        );
      case '/loans':
      case '/loan-list':
        return MaterialPageRoute(builder: (_) => const LoanListScreen());
      default:
        // Unknown route, redirect to splash
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: auth),
        ChangeNotifierProvider<LoansProvider>(create: (_) => LoansProvider(api, auth)),
      ],
      child: Consumer<AuthProvider>(builder: (context, authProv, _) {
        // Determine initial widget based on URL for web
        Widget initialWidget = const SplashScreen();
        
        if (kIsWeb) {
          try {
            final currentUrl = kIsWeb ? html.window.location.href : '';
            print('Current URL: $currentUrl'); // Debug
            
            // Simple check if URL contains reset-password and token
            if (currentUrl.contains('/reset-password') && currentUrl.contains('token=')) {
              // Extract token using simple string parsing
              final uri = Uri.parse(currentUrl);
              final token = uri.queryParameters['token'] ?? '';
              final email = uri.queryParameters['email'] ?? '';
              
              print('Reset password URL detected'); // Debug
              print('Token: $token'); // Debug
              print('Email: $email'); // Debug
              
              if (token.isNotEmpty) {
                initialWidget = ResetPasswordScreen(token: token, email: email);
                print('Setting initial widget to ResetPasswordScreen'); // Debug
              }
            }
          } catch (e) {
            print('Error parsing URL: $e'); // Debug
            // If there's an error, default to splash screen
          }
        }
        
        return MaterialApp(
          title: 'Credosafe',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          home: initialWidget,
          onGenerateRoute: (settings) => _generateRoute(settings),
        );
      }),
    );
  }
}

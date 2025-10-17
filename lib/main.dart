import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/loans_provider.dart';
import 'providers/loan_status_provider.dart';
import 'providers/loan_application_provider.dart';
import 'screens/common/splash_screen.dart';
import 'screens/common/login_screen.dart';
import 'screens/common/otp_verification_screen.dart';
import 'screens/common/success_screen.dart';
import 'screens/common/password_setup_screen.dart';
import 'screens/customer/loan_list_screen.dart';
import 'screens/common/forgot_password_screen.dart';
import 'screens/common/reset_password_screen.dart';
import 'screens/customer/loan_routing_screen.dart';
import 'screens/admin/admin_loan_applications_screen.dart';
import 'utils/logger.dart';

// Conditional import for web
import 'package:web/web.dart' as web;

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
        final webUri = Uri.parse(kIsWeb ? web.window.location.href : '');
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
      case '/loan-dashboard':
        return MaterialPageRoute(builder: (_) => const LoanRoutingScreen());
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
        ChangeNotifierProvider<LoanStatusProvider>(create: (_) => LoanStatusProvider()),
        ChangeNotifierProvider<LoanApplicationProvider>(create: (_) => LoanApplicationProvider()),
      ],
      child: Consumer<AuthProvider>(builder: (context, authProv, _) {
        // Navigation after login based on role
        Widget initialWidget = const SplashScreen();
        final isLoggedIn = authProv.isLoggedIn;
        final userRole = authProv.user?.role ?? '';
        if (isLoggedIn) {
          if (userRole == 'admin') {
            initialWidget = const AdminLoanApplicationsScreen();
          } else {
            initialWidget = const LoanRoutingScreen();
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

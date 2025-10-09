import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/loans_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/success_screen.dart';
import 'screens/password_setup_screen.dart';
import 'screens/loan_list_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: auth),
        ChangeNotifierProvider<LoansProvider>(create: (_) => LoansProvider(api, auth)),
      ],
      child: Consumer<AuthProvider>(builder: (context, authProv, _) {
        return MaterialApp(
          title: 'Credosafe',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/otp': (context) => const OTPVerificationScreen(email: ''),
            '/success': (context) => const SuccessScreen(),
            '/password-setup': (context) => const PasswordSetupScreen(email: ''),
            '/loans': (context) => const LoanListScreen(),
            '/loan-list': (context) => const LoanListScreen(),
          },
        );
      }),
    );
  }
}

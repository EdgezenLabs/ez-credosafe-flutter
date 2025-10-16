/// Application route names
/// Centralized route management
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Authentication Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String otpVerification = '/otp-verification';
  static const String passwordSetup = '/password-setup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String success = '/success';
  static const String emailLinkSent = '/email-link-sent';

  // Main App Routes
  static const String loanRouting = '/loan-routing';
  static const String loanDashboard = '/loan-dashboard';
  static const String loanStatus = '/loan-status';
  static const String loanTypeSelection = '/loan-type-selection';

  // Application Routes
  static const String personalLoanApplication = '/personal-loan-application';
  static const String residentialDetails = '/residential-details';
  static const String employmentDetails = '/employment-details';
  static const String applicationSuccess = '/application-success';
  static const String applicationStatus = '/application-status';

  // Other Routes
  static const String loanList = '/loan-list';
  static const String accessDenied = '/access-denied';
}

/// API endpoint constants
/// Centralized API endpoint management
class ApiEndpoints {
  // Private constructor
  ApiEndpoints._();

  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String verifyOtp = '/auth/verify-otp';
  static const String setupPassword = '/auth/setup-password';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String logout = '/auth/logout';

  // User Endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update';

  // Loan Endpoints
  static const String loanTypes = '/loans/types';
  static const String loanStatus = '/loans/status';
  static const String loanApplication = '/loans/application';
  static const String loanList = '/loans/list';

  // Document Endpoints
  static const String uploadDocument = '/documents/upload';
  static const String viewDocument = '/documents/view';
  static const String downloadDocument = '/documents/download';
  static const String deleteDocument = '/documents/delete';

  // Application Endpoints
  static const String submitApplication = '/application/submit';
  static const String cancelApplication = '/application/cancel';
  static const String applicationDetails = '/application/details';
}

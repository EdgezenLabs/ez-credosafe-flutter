/// Core application constants
/// Centralized location for app-wide constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Information
  static const String appName = 'CredoSafe';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.credosafe.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String userIdKey = 'user_id';
  
  // File Upload
  static const List<String> allowedFileExtensions = ['pdf', 'jpg', 'jpeg', 'png'];
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  
  // Document Types
  static const String documentTypeAadhaar = 'aadhaar';
  static const String documentTypePan = 'pan';
  static const String documentTypeBankStatement = 'bank_statement';
  static const String documentTypeIncomeTax = 'income_tax';
  
  // Loan Types
  static const String loanTypePersonal = 'personal';
  static const String loanTypeBusiness = 'business';
  static const String loanTypeHome = 'home';
  
  // Application Status
  static const String statusPending = 'pending';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';
  static const String statusUnderReview = 'under review';
  
  // Validation Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^[0-9]{10}$';
  static const String panPattern = r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double buttonHeight = 50.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}

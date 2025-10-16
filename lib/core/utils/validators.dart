/// Input validation utilities
/// Reusable validation functions

class Validators {
  // Private constructor
  Validators._();

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Validates phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    
    return null;
  }

  /// Validates password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }

  /// Validates required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates PAN card
  static String? validatePan(String? value) {
    if (value == null || value.isEmpty) {
      return 'PAN is required';
    }
    
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    
    if (!panRegex.hasMatch(value)) {
      return 'Please enter a valid PAN (e.g., ABCDE1234F)';
    }
    
    return null;
  }

  /// Validates Aadhaar number
  static String? validateAadhaar(String? value) {
    if (value == null || value.isEmpty) {
      return 'Aadhaar is required';
    }
    
    final aadhaarRegex = RegExp(r'^[0-9]{12}$');
    
    if (!aadhaarRegex.hasMatch(value)) {
      return 'Please enter a valid 12-digit Aadhaar number';
    }
    
    return null;
  }

  /// Validates amount
  static String? validateAmount(String? value, {double? min, double? max}) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    
    final amount = double.tryParse(value);
    
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    
    if (min != null && amount < min) {
      return 'Amount must be at least ₹${min.toStringAsFixed(0)}';
    }
    
    if (max != null && amount > max) {
      return 'Amount must not exceed ₹${max.toStringAsFixed(0)}';
    }
    
    return null;
  }

  /// Validates OTP
  static String? validateOtp(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    
    if (value.length != length) {
      return 'Please enter a valid $length-digit OTP';
    }
    
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    
    return null;
  }

  /// Validates name
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    
    return null;
  }

  /// Validates match (e.g., password confirmation)
  static String? validateMatch(String? value, String? compareValue, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value != compareValue) {
      return '$fieldName does not match';
    }
    
    return null;
  }
}

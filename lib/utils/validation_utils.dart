class ValidationUtils {
  // Email validation regex pattern
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Password validation patterns
  static final RegExp _uppercaseRegex = RegExp(r'[A-Z]');
  static final RegExp _lowercaseRegex = RegExp(r'[a-z]');
  static final RegExp _digitRegex = RegExp(r'[0-9]');
  static final RegExp _specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  /// Validates email format
  /// Returns null if valid, error message if invalid
  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Email is required';
    }

    final trimmedEmail = email.trim();
    
    if (!_emailRegex.hasMatch(trimmedEmail)) {
      return 'Please enter a valid email address';
    }

    return null; // Valid email
  }

  /// Validates password strength
  /// Returns null if valid, error message if invalid
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!_uppercaseRegex.hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!_lowercaseRegex.hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!_digitRegex.hasMatch(password)) {
      return 'Password must contain at least one number';
    }

    if (!_specialCharRegex.hasMatch(password)) {
      return 'Password must contain at least one special character';
    }

    return null; // Valid password
  }

  /// Checks if email is valid (boolean)
  static bool isValidEmail(String? email) {
    return validateEmail(email) == null;
  }

  /// Checks if password is strong (boolean)
  static bool isStrongPassword(String? password) {
    return validatePassword(password) == null;
  }

  /// Validates required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Gets password strength level (0-4)
  /// 0: Very weak, 1: Weak, 2: Fair, 3: Good, 4: Strong
  static int getPasswordStrength(String? password) {
    if (password == null || password.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;

    // Character type checks
    if (_uppercaseRegex.hasMatch(password)) strength++;
    if (_lowercaseRegex.hasMatch(password)) strength++;
    if (_digitRegex.hasMatch(password)) strength++;
    if (_specialCharRegex.hasMatch(password)) strength++;

    // Cap at 4 for strong
    return strength > 4 ? 4 : strength;
  }

  /// Gets password strength description
  static String getPasswordStrengthText(int strength) {
    switch (strength) {
      case 0:
        return 'Very weak';
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return 'Very weak';
    }
  }

  /// Validates form fields collectively
  static Map<String, String?> validateLoginForm({
    required String? email,
    required String? password,
  }) {
    return {
      'email': validateEmail(email),
      'password': validatePassword(password),
    };
  }

  /// Checks if login form is valid
  static bool isLoginFormValid({
    required String? email,
    required String? password,
  }) {
    final validationResults = validateLoginForm(
      email: email,
      password: password,
    );
    
    return validationResults.values.every((error) => error == null);
  }
}
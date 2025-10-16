/// String extension methods
/// Additional utility methods for String class

extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes first letter of each word
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty ? word : word.capitalize())
        .join(' ');
  }

  /// Checks if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  /// Checks if string is a valid phone number
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(this);
  }

  /// Checks if string contains only numbers
  bool get isNumeric {
    return RegExp(r'^[0-9]+$').hasMatch(this);
  }

  /// Truncates string to specified length and adds ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Removes all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Converts string to currency format
  String toCurrency() {
    final number = double.tryParse(this);
    if (number == null) return this;
    return '₹${number.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }
}

/// DateTime extension methods
extension DateTimeExtensions on DateTime {
  /// Formats date as dd/MM/yyyy
  String toDateString() {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  /// Formats date as dd MMM yyyy (e.g., 15 Jan 2024)
  String toFormattedDate() {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '$day ${months[month - 1]} $year';
  }

  /// Formats time as hh:mm AM/PM
  String toTimeString() {
    final hour = this.hour > 12 ? this.hour - 12 : this.hour;
    final period = this.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Checks if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
}

/// num extension methods
extension NumExtensions on num {
  /// Formats number as currency
  String toCurrency() {
    return '₹${toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  /// Formats number with thousand separators
  String toFormattedString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

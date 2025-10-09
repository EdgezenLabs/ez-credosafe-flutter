/// OTP request and response models for type safety and validation
class OtpRequest {
  final String email;

  const OtpRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};

  @override
  String toString() => 'OtpRequest(email: $email)';
}

class OtpVerificationRequest {
  final String email;
  final String otp;

  const OtpVerificationRequest({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'otp': otp,
      };

  @override
  String toString() => 'OtpVerificationRequest(email: $email, otp: $otp)';
}

class OtpResponse {
  final bool success;
  final String message;
  final String? sessionId;

  const OtpResponse({
    required this.success,
    required this.message,
    this.sessionId,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      success: json['success'] ?? (json['message'] != null && json['message'].toString().isNotEmpty),
      message: json['message'] ?? '',
      sessionId: json['session_id'],
    );
  }

  @override
  String toString() => 'OtpResponse(success: $success, message: $message, sessionId: $sessionId)';
}

class OtpVerificationResponse {
  final bool success;
  final String message;
  final String? token;
  final Map<String, dynamic>? user;

  const OtpVerificationResponse({
    required this.success,
    required this.message,
    this.token,
    this.user,
  });

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    // Handle new API response structure with access_token and token_type
    final accessToken = json['access_token'] as String?;
    final tokenType = json['token_type'] as String?;
    
    // If we have access_token, it means verification was successful
    final bool isSuccess = accessToken != null && accessToken.isNotEmpty;
    
    // Build the complete token with token_type prefix if available
    String? fullToken;
    if (accessToken != null) {
      if (tokenType != null && tokenType.isNotEmpty) {
        fullToken = tokenType == 'bearer' ? accessToken : '$tokenType $accessToken';
      } else {
        fullToken = accessToken;
      }
    }
    
    return OtpVerificationResponse(
      success: json['success'] ?? isSuccess,
      message: json['message'] ?? (isSuccess ? 'OTP verified successfully' : 'Verification failed'),
      token: json['token'] ?? fullToken,
      user: json['user'],
    );
  }

  @override
  String toString() => 'OtpVerificationResponse(success: $success, message: $message, hasToken: ${token != null})';
}

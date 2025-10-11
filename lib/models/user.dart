class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String role;
  final bool isActive;
  final String? tenantId;
  final String createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.role,
    required this.isActive,
    this.tenantId,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      role: json['role'] ?? 'customer',
      isActive: json['is_active'] ?? true,
      tenantId: json['tenant_id'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'is_active': isActive,
      'tenant_id': tenantId,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, role: $role)';
  }
}

class UserModel {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String email;
  final String username;
  final int admin;
  final bool isAdmin;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;
  final String? branch;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
    required this.username,
    required this.admin,
    required this.isAdmin,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.lastLogin,
    this.branch,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] ?? "",
      email: json["mail"] ?? "",
      username: json["username"] ?? "",
      admin: json["admin"] ?? 0,
      isAdmin: json["is_admin"] ?? false,
      isActive: json["is_active"] ?? false,
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      lastLogin: json["last_login"] != null
          ? DateTime.tryParse(json["last_login"])
          : null,
      branch: json["branch"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "address": address,
      "mail": email,
      "username": username,
      "admin": admin,
      "is_admin": isAdmin,
      "is_active": isActive,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "last_login": lastLogin?.toIso8601String(),
      "branch": branch,
    };
  }
}

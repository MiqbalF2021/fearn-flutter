class User {
  final String accessToken;
  final String refreshToken;
  final List<String> permissions;

  User({
    required this.accessToken,
    required this.refreshToken,
    required this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      permissions: List<String>.from(json['permissions']),
    );
  }
}
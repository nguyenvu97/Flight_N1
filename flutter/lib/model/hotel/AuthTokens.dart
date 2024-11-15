import 'dart:convert';

// Lớp Dart để lưu trữ các token
class AuthTokens {
  final String accessToken;
  final String refreshToken;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  // Tạo đối tượng AuthTokens từ một bản đồ
  factory AuthTokens.fromMap(Map<String, dynamic> map) {
    return AuthTokens(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
    );
  }

  // Chuyển đối tượng AuthTokens thành một bản đồ
  Map<String, dynamic> toMap() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  // Chuyển đổi đối tượng AuthTokens thành JSON
  String toJson() {
    final map = toMap();
    return jsonEncode(map);
  }

  // Tạo đối tượng AuthTokens từ chuỗi JSON

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );
  }
}

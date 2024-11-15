import 'dart:convert';

class MemberData {
  final int id;
  String? sub;
  final int iat;
  final int exp;
  final String role;
  String? aliases;
  final String name;
  final String address;
  final String phone;

  // Constructor
  MemberData({
    required this.id,
    required this.sub,
    required this.iat,
    required this.exp,
    required this.role,
    this.aliases,
    required this.name,
    required this.address,
    required this.phone,
  });

  // Named constructor to create an instance from a map
  factory MemberData.fromMap(Map<String, dynamic> map) {
    return MemberData(
      id: map['id'] as int,
      sub: map['sub'] as String,
      iat: map['iat'] as int,
      exp: map['exp'] as int,
      role: map['role'] as String,
      aliases: map['aliases'] as String,
      name: map['name'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
    );
  }

  // Convert the instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sub': sub,
      'iat': iat,
      'exp': exp,
      'role': role,
      'aliases': aliases,
      'name': name,
      'address': address,
      'phone': phone,
    };
  }

  // Convert the instance to a JSON string
  String toJson() {
    final map = toMap();
    return jsonEncode(map);
  }

  // Create an instance from a JSON string
  factory MemberData.fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return MemberData.fromMap(map);
  }
}

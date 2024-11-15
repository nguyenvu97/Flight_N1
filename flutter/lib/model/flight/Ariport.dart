import 'dart:convert';

class Ariport {
  final int id;
  final String location;
  final String code;
  final String name;

  Ariport(
      {required this.id,
      required this.code,
      required this.location,
      required this.name});

  Map<String, dynamic> toMap() {
    return {"id": id, "location": location, "code": code, "name": name};
  }

  String toJson() {
    final map = toMap();
    return jsonEncode(map);
  }

  factory Ariport.fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return Ariport.fromMap(map);
  }

  factory Ariport.fromMap(Map<String, dynamic> map) {
    return Ariport(
        id: map['id'] as int,
        code: map['code'] as String,
        location: map['location'] as String,
        name: map['name'] as String);
  }
}

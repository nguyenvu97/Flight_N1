class User {
  String email;
  String? password;
  String fullName;
  String address;
  String phone;
  String aliases;

  User({
    required this.email,
    this.password,
    required this.fullName,
    required this.address,
    required this.phone,
    required this.aliases,
  });

  @override
  String toString() {
    return 'User{email: $email, password: $password, name: $fullName, '
        'address: $address, phone: $phone,}';
  }

  Map<String, dynamic> toMap() {
    return {
      'Email': email,
      'password': password,
      'Name': fullName,
      'Address': address,
      'Phone': phone,
      'aliases': aliases, // Gọi hàm để chuyển đổi enum thành chuỗi
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'Email': email,
      'Password': password,
      'Name': fullName,
      'Address': address,
      'Phone': phone,
      'aliases': aliases, // Gọi hàm để chuyển đổi enum thành chuỗi
    };
  }
}

class CustomerDto {
  String fullName;
  String aliases;
  String birthOfDay;
  String email;
  String phone;
  String customType;
  double? amountTotal;
  int? bagGo; // bag_go
  int? bagBack; // bag_back
  Map<int, String> seatsGo; // seats_go
  Map<int, String>? seatsGoChild; // seats_go_child
  Map<int, String>? seatsBack; // seats_back
  Map<int, String>? seatsBackChild; // seats_back_child

  CustomerDto({
    required this.fullName,
    required this.aliases,
    required this.birthOfDay,
    required this.email,
    required this.phone,
    required this.customType,
    this.amountTotal = 0.0,
    this.bagGo = 0,
    this.bagBack = 0,
    required this.seatsGo,
    this.seatsGoChild,
    this.seatsBack,
    this.seatsBackChild,
  });

  // Phương thức để chuyển đổi thành JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'aliases': aliases,
      'birthOfDay': birthOfDay,
      'email': email,
      'phone': phone,
      'customType': customType,
      'amountTotal': amountTotal,
      'bag_go': bagGo,
      'bag_back': bagBack,
      'seats_go': seatsGo.map((key, value) => MapEntry(key.toString(), value)),
      'seats_go_child': seatsGoChild?.map((key, value) => MapEntry(key.toString(), value)) ?? {},
      'seats_back': seatsBack?.map((key, value) => MapEntry(key.toString(), value)) ?? {},
      'seats_back_child': seatsBackChild?.map((key, value) => MapEntry(key.toString(), value)) ?? {},
    };
  }


  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    return CustomerDto(
      fullName: json['fullName'],
      aliases: json['aliases'],
      birthOfDay: json['birthOfDay'],
      email: json['email'],
      phone: json['phone'],
      customType: json['customType'],
      amountTotal: (json['amountTotal'] as num?)?.toDouble(),
      bagGo: json['bag_go'] as int?,
      bagBack: json['bag_back'] as int?,
      seatsGo: Map<int, String>.from(json['seats_go']?.map((key, value) => MapEntry(int.parse(key), value)) ?? {}),
      seatsGoChild: json['seats_go_child'] != null
          ? Map<int, String>.from(json['seats_go_child'].map((key, value) => MapEntry(int.parse(key), value)))
          : null,
      seatsBack: json['seats_back'] != null
          ? Map<int, String>.from(json['seats_back'].map((key, value) => MapEntry(int.parse(key), value)))
          : null,
      seatsBackChild: json['seats_back_child'] != null
          ? Map<int, String>.from(json['seats_back_child'].map((key, value) => MapEntry(int.parse(key), value)))
          : null,
    );

  }
}

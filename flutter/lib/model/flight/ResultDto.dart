class ResultDto {
  final String status;
  final String message; // Chỉnh sửa từ 'messger' thành 'message'
  final DateTime date;
  final String url;

  ResultDto({
    required this.status,
    required this.message,
    required this.date,
    required this.url,
  });

  // Phương thức chuyển đổi đối tượng thành Map
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'date':
          date.toIso8601String(), // Chuyển đổi DateTime thành chuỗi ISO 8601
      'url': url,
    };
  }

  // Phương thức khởi tạo từ Map (tùy chọn, nếu cần)
  factory ResultDto.fromMap(Map<String, dynamic> map) {
    return ResultDto(
      status: map['status'],
      message: map['messger'], // Ensure the key matches the response
      date: DateTime.parse(map['date']),
      url: map['url'],
    );
  }
}

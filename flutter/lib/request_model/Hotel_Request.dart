class HotelSearchRequest {
  String? address;
  int? numberPeople;
  int? numberRoom;
  String? categoryType;
  double? minMoney;
  double? maxMoney;
  int? startHotel;
  int? pageSize;
  int? pageNumber;
  final String startTime;
  final String endTime;

  HotelSearchRequest({
    this.address,
    this.numberPeople,
    this.numberRoom,
    this.categoryType,
    this.minMoney,
    this.maxMoney,
    this.startHotel,
    this.pageSize,
    this.pageNumber,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'numberPeople': numberPeople,
      'numberRoom': numberRoom,
      'categoryType': categoryType?.toString(),
      'minMoney': minMoney,
      'maxMoney': maxMoney,
      'startHotel': startHotel,
      'pageSize': pageSize,
      'pageNumber': pageNumber,
      'startTime': startTime,
      'endTime': endTime
    };
  }
}

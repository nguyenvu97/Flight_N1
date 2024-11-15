class SearchFlight {
  String startDate;
  String? endDate;
  String departure;
  String arrival;

  SearchFlight({
    required this.startDate,
    this.endDate,
    required this.departure,
    required this.arrival,
  });
  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'departure': departure,
      'arrival': arrival,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'departure': departure,
      'arrival': arrival,
    };
  }
}

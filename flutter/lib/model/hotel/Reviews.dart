import 'dart:convert';

class ReviewsResponse {
  final int pageSize;
  final int pageNumber;
  final List<Review> content;
  final int totalElements;
  final int number;
  final int numberOfElements;
  final int totalPages;

  ReviewsResponse({
    required this.pageSize,
    required this.pageNumber,
    required this.content,
    required this.totalElements,
    required this.number,
    required this.numberOfElements,
    required this.totalPages,
  });

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) {
    return ReviewsResponse(
      pageSize: json['pageSize'],
      pageNumber: json['pageNumber'],
      content: List<Review>.from(
          json['content'].map((item) => Review.fromJson(item))),
      totalElements: json['totalElements'],
      number: json['number'],
      numberOfElements: json['numberOfElements'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageSize': pageSize,
      'pageNumber': pageNumber,
      'content': List<dynamic>.from(content.map((item) => item.toJson())),
      'totalElements': totalElements,
      'number': number,
      'numberOfElements': numberOfElements,
      'totalPages': totalPages,
    };
  }
}

class Review {
  final int? id;
  final int hotelId;
  final String email;
  final int? customerId; // Sử dụng int? để có thể là null
  final String comment;
  final double rating;
  final DateTime? time; // Sử dụng DateTime? để có thể là null

  // Constructor
  Review({
    this.id,
    required this.hotelId,
    required this.email,
    this.customerId,
    required this.comment,
    required this.rating,
    this.time,
  });

  // Factory method to create a Review from JSON
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      hotelId: json['hotelId'],
      email: json['email'],
      customerId: json['customerId'],
      comment: json['comment'],
      rating: (json['rating'] as num).toDouble(),
      time: json['time'] != null ? DateTime.parse(json['time']) : null,
    );
  }

  // Method to convert a Review to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotelId': hotelId,
      'email': email,
      'customerId': customerId,
      'comment': comment,
      'rating': rating,
      'time': time?.toIso8601String(), // Convert DateTime to ISO 8601 string
    };
  }
}

// Example usage


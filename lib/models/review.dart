// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

Review reviewFromJson(String str) => Review.fromJson(json.decode(str));

String reviewToJson(Review data) => json.encode(data.toJson());

class Review {
  List<Result> results;

  Review({
    required this.results,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  String user;
  int rating;
  String comment;
  DateTime createdAt;

  Result({
    required this.user,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        user: json["user"],
        rating: json["rating"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "rating": rating,
        "comment": comment,
        "created_at": createdAt.toIso8601String(),
      };
}

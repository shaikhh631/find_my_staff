class Review {
  String bookingID;
  String bookerEmail;
  String authorEmail;
  String type;
  double rating;
  String review;
  String authorName;

  Review({
    required this.bookingID,
    required this.bookerEmail,
    required this.authorEmail,
    required this.type,
    required this.rating,
    required this.review,
    required this.authorName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      bookingID: json['bookingID'],
      bookerEmail: json['bookerEmail'],
      authorEmail: json['authorEmail'],
      type: json['type'],
      rating: json['rating'],
      review: json['review'],
      authorName: json['authorName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bookingID": this.bookingID,
      "bookerEmail": this.bookerEmail,
      "authorEmail": this.authorEmail,
      "type": this.type,
      "rating": this.rating,
      "review": this.review,
      "authorName": this.authorName,
    };
  }
}

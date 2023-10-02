class Gig {
  String id;
  String title;
  String description;
  String category;
  String authorType;
  String authorEmail;
  String authorName;
  double lat;
  double lon;
  int rating;

  Gig({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.authorType,
    required this.authorEmail,
    required this.authorName,
    required this.lat,
    required this.lon,
    required this.rating,
  });

  factory Gig.fromJson(Map<String, dynamic> json) {
    return Gig(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      authorType: json['authorType'],
      authorEmail: json['authorEmail'],
      authorName: json['authorName'],
      lat: json['lat'],
      lon: json['lon'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "description": this.description,
      "category": this.category,
      "authorType": this.authorType,
      "authorEmail": this.authorEmail,
      "authorName": this.authorName,
      "lat": this.lat,
      "lon": this.lon,
      "rating": this.rating,
    };
  }
}

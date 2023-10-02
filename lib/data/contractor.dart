class Contractor {
  String name;
  String email;
  String phone;
  String password;
  String method;
  String category;
  String experience;
  String workerTypes;
  String description;
  double lat;
  double long;
  String earned;
  String? imageUrl;

  Contractor(
      {required this.name,
      required this.email,
      required this.phone,
      required this.password,
      required this.method,
      required this.category,
      required this.experience,
      required this.workerTypes,
      required this.description,
      required this.lat,
      required this.long,
      required this.earned,
      this.imageUrl});

  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        password: json['password'],
        method: json['method'],
        category: json['category'],
        experience: json['experience'],
        workerTypes: json['workerTypes'],
        description: json['description'],
        lat: json['lat'],
        long: json['long'],
        earned: json['earned'],
        imageUrl: json['imageUrl']);
  }

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'email': this.email,
        'phone': this.phone,
        'password': this.password,
        'method': this.method,
        'category': this.category,
        'experience': this.experience,
        'workerTypes': this.workerTypes,
        'description': this.description,
        'lat': this.lat,
        'long': this.long,
        'earned': this.earned,
        'imageUrl': this.imageUrl
      };
}

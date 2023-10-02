class Worker {
  String name;
  String email;
  String phone;
  String password;
  String method;
  String category;
  String experience;
  String description;
  String hourlyRate;
  String skills;
  double lat;
  double long;
  String earned;
  String? imageUrl;
  

  Worker({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.method,
    required this.category,
    required this.experience,
    required this.description,
    required this.hourlyRate,
    required this.skills,
    required this.lat,
    required this.long,
    required this.earned,
     this.imageUrl
  });

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      method: json['method'],
      category: json['category'],
      experience: json['experience'],
      description: json['description'],
      hourlyRate: json['hourlyRate'],
      skills: json['skills'],
      lat: json['lat'],
      long: json['long'],
      earned: json['earned'],
      imageUrl: json['imageUrl']
    );
  }

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'email': this.email,
        'phone': this.phone,
        'password': this.password,
        'method': this.method,
        'category': this.category,
        'experience': this.experience,
        'description': this.description,
        'hourlyRate': this.hourlyRate,
        'skills': this.skills,
        'lat': this.lat,
        'long': this.long,
        'earned': this.earned,
        'imageUrl': this.imageUrl
      };
}

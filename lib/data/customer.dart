class Customer {
  String name;
  String email;
  String phone;
  String password;
  String method;
  double lat;
  double long;
  String? imageUrl;

  Customer({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.method,
    required this.lat,
    required this.long,
     this.imageUrl,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        password: json['password'],
        method: json['method'],
        lat: json['lat'],
        long: json['long'],
        imageUrl: json['imageUrl']);
  }

  Map<String, dynamic> toJson() => {
        'name': this.name,
        'email': this.email,
        'phone': this.phone,
        'password': this.password,
        'method': this.method,
        'lat': this.lat,
        'long': this.long,
        'imageUrl': this.imageUrl
      };
}

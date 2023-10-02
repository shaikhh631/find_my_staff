import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String id;
  String status;
  String title;
  String gig;
  String bookerEmail;
  String authorEmail;
  String authorName;
  String bookingType;
  String daysBooked;
  String perHourCost;
  String totalCost;
  List<dynamic> bookingDates;
  Timestamp bookedAt;

  Booking({
    required this.id,
    required this.status,
    required this.title,
    required this.gig,
    required this.bookerEmail,
    required this.authorEmail,
    required this.authorName,
    required this.bookingType,
    required this.daysBooked,
    required this.perHourCost,
    required this.totalCost,
    required this.bookingDates,
    required this.bookedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      status: json['status'],
      title: json['title'],
      gig: json['gig'],
      bookerEmail: json['bookerEmail'],
      authorEmail: json['authorEmail'],
      authorName: json['authorName'],
      bookingType: json['bookingType'],
      daysBooked: json['daysBooked'],
      perHourCost: json['perHourCost'],
      totalCost: json['totalCost'],
      bookingDates: json['bookingDates'],
      bookedAt: json['bookedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "status": status,
      "title": title,
      "gig": gig,
      "bookerEmail": bookerEmail,
      "authorEmail": authorEmail,
      "authorName": authorName,
      "bookingType": bookingType,
      "daysBooked": daysBooked,
      "perHourCost": perHourCost,
      "totalCost": totalCost,
      "bookingDates": bookingDates,
      "bookedAt": bookedAt,
    };
  }
}

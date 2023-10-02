import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_staff/data/booking.dart';
import 'package:find_my_staff/data/category.dart';
import 'package:find_my_staff/data/contractor.dart';
import 'package:find_my_staff/data/customer.dart';
import 'package:find_my_staff/data/gig.dart';
import 'package:find_my_staff/data/review.dart';
import 'package:find_my_staff/data/worker.dart';
import 'package:flutter/material.dart';
import 'dart:math' show cos, sqrt, asin;

class DataController {
  List<Category> categories = [
    Category(
      tag: "Home Cleaning",
      icon: Icons.cleaning_services,
    ),
    Category(
      tag: "Car Detailing",
      icon: Icons.car_repair,
    ),
    Category(
      tag: "Technology",
      icon: Icons.screen_search_desktop_outlined,
    ),
    Category(
      tag: "Construction",
      icon: Icons.build,
    ),
  ];

  Future<Worker> getWorker(String workerEmail) async {
    var collection = FirebaseFirestore.instance.collection("workers");
    var docsRef = await collection.doc(workerEmail).get();
    Worker worker = Worker.fromJson(docsRef.data()!);
    return worker;
  }

  Future<Contractor> getContractor(String contractorEmail) async {
    var collection = FirebaseFirestore.instance.collection("contractors");
    var docsRef = await collection.doc(contractorEmail).get();
    Contractor contractor = Contractor.fromJson(docsRef.data()!);
    return contractor;
  }

  Future<Customer> getCustomer(String customerEmail) async {
    var collection = FirebaseFirestore.instance.collection("customers");
    var docsRef = await collection.doc(customerEmail).get();
    Customer customer = Customer.fromJson(docsRef.data()!);
    return customer;
  }

  Future<bool> addGig(Gig newGig) async {
    var collection = FirebaseFirestore.instance.collection("gigs");
    await collection
        .doc(newGig.id)
        .set(newGig.toJson())
        .onError((error, stackTrace) {
      return false;
    });
    return true;
  }

  Future<bool> editGig(Gig newGigDetails) async {
    var collection = FirebaseFirestore.instance.collection("gigs");
    await collection
        .doc(newGigDetails.id)
        .update(newGigDetails.toJson())
        .onError((error, stackTrace) {
      return false;
    });
    return true;
  }

  Future<List<Gig>> getAllWorkerGigs(String email) async {
    List<Gig> allGigs = [];
    var collection = FirebaseFirestore.instance.collection("gigs");
    var docsRef = await collection
        .where("authorEmail", isEqualTo: email)
        .where("authorType", isEqualTo: "worker")
        .get();
    docsRef.docs.forEach((element) {
      Gig _thisGig = Gig.fromJson(
        element.data(),
      );
      allGigs.add(_thisGig);
    });
    return allGigs;
  }

  Future<List<Gig>> getAllContractorGigs(String email) async {
    List<Gig> allGigs = [];
    var collection = FirebaseFirestore.instance.collection("gigs");
    var docsRef = await collection
        .where("authorEmail", isEqualTo: email)
        .where("authorType", isEqualTo: "contractor")
        .get();
    docsRef.docs.forEach((element) {
      Gig _thisGig = Gig.fromJson(
        element.data(),
      );
      allGigs.add(_thisGig);
    });
    return allGigs;
  }

  Future<List<Gig>> getGigsByCategory(String category) async {
    List<Gig> allGigs = [];
    var collection = FirebaseFirestore.instance.collection("gigs");
    var docsRef = await collection.where("category", isEqualTo: category).get();
    docsRef.docs.forEach((element) {
      Gig _thisGig = Gig.fromJson(
        element.data(),
      );
      allGigs.add(_thisGig);
    });
    return allGigs;
  }

  Future<List<Gig>> getGigsByCategoryOfWorker(String category) async {
    List<Gig> allGigs = [];
    var collection = FirebaseFirestore.instance.collection("gigs");
    var docsRef = await collection
        .where("category", isEqualTo: category)
        .where("authorType", isEqualTo: "worker")
        .get();
    docsRef.docs.forEach((element) {
      Gig _thisGig = Gig.fromJson(
        element.data(),
      );
      allGigs.add(_thisGig);
    });
    return allGigs;
  }

  Future<List<Gig>> getGigsByLocation(double userLat, double userLon) async {
    List<Gig> allGigs = [];
    var collection = FirebaseFirestore.instance.collection("gigs");
    var docsRef = await collection.get();
    docsRef.docs.forEach((element) {
      Gig _thisGig = Gig.fromJson(
        element.data(),
      );
      double distanceInKm =
          calculateDistance(userLat, userLon, _thisGig.lat, _thisGig.lon);
      if (distanceInKm < 5) {
        allGigs.add(_thisGig);
      }
    });
    return allGigs;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<bool> addBooking(Booking newBooking) async {
    var collection = FirebaseFirestore.instance.collection("bookings");
    await collection
        .doc(newBooking.id)
        .set(newBooking.toJson())
        .onError((error, stackTrace) {
      return false;
    });
    return true;
  }

  Future<List<Booking>> getWorkerOngoing(String email) async {
    List<Booking> bookings = [];
    var collection = FirebaseFirestore.instance.collection("bookings");
    var docsRef = await collection
        .where("authorEmail", isEqualTo: email)
        .where("status", isEqualTo: "Ongoing")
        .get();
    docsRef.docs.forEach((element) {
      Booking _booking = Booking.fromJson(element.data());
      bookings.add(_booking);
    });
    return bookings;
  }

  Future<List<Booking>> getWorkerCompleted(String email) async {
    List<Booking> bookings = [];
    var collection = FirebaseFirestore.instance.collection("bookings");
    var docsRef = await collection
        .where("authorEmail", isEqualTo: email)
        .where("status", isEqualTo: "Completed")
        .get();
    docsRef.docs.forEach((element) {
      Booking _booking = Booking.fromJson(element.data());
      bookings.add(_booking);
    });
    return bookings;
  }

  Future<bool> markBookingComplete(String id) async {
    var collection = FirebaseFirestore.instance.collection("bookings");
    await collection.doc(id).update({
      "status": "Completed",
    }).onError((error, stackTrace) {
      return false;
    });
    return true;
  }

  Future<bool> addReview(Review review) async {
    var collection = FirebaseFirestore.instance.collection("reviews");
    await collection.doc().set(review.toJson()).onError((error, stackTrace) {
      return false;
    });
    return true;
  }

  Future<bool> addEarningsToContractor(
      String newEarning, String contractorEmail) async {
    var collection = FirebaseFirestore.instance.collection("contractors");
    var doc = await collection.doc(contractorEmail).get();
    Contractor contractor = Contractor.fromJson(doc.data()!);
    int oldEarnings = int.parse(contractor.earned);
    int updatableEarning = oldEarnings + int.parse(newEarning);
    await collection.doc(contractorEmail).update({
      "earned": updatableEarning.toString(),
    }).onError((error, stackTrace) {
      return false;
    });
    return true;
  }

  Future<bool> addEarningsToWorker(
      String newEarning, String workerEmail) async {
    var collection = FirebaseFirestore.instance.collection("workers");
    var doc = await collection.doc(workerEmail).get();
    Worker worker = Worker.fromJson(doc.data()!);
    int oldEarnings = int.parse(worker.earned);
    int updatableEarning = oldEarnings + int.parse(newEarning);
    await collection.doc(workerEmail).update({
      "earned": updatableEarning.toString(),
    }).onError((error, stackTrace) {
      return false;
    });
    return true;
  }

  Future<Booking> getBookingByID(String id) async {
    var docRef =
        await FirebaseFirestore.instance.collection("bookings").doc(id).get();
    Booking _booking = Booking.fromJson(docRef.data()!);
    return _booking;
  }

  Future<Gig> getGigByID(String id) async {
    var docRef =
        await FirebaseFirestore.instance.collection("gigs").doc(id).get();
    Gig _gig = Gig.fromJson(docRef.data()!);
    return _gig;
  }

  Future<List<Booking>> getHiredOngoing(String email) async {
    List<Booking> bookings = [];
    var collection = FirebaseFirestore.instance.collection("bookings");
    var docsRef = await collection
        .where("bookerEmail", isEqualTo: email)
        .where("status", isEqualTo: "Ongoing")
        .get();
    docsRef.docs.forEach((element) {
      Booking _booking = Booking.fromJson(element.data());
      bookings.add(_booking);
    });
    return bookings;
  }

  Future<List<Booking>> getHiredCompleted(String email) async {
    List<Booking> bookings = [];
    var collection = FirebaseFirestore.instance.collection("bookings");
    var docsRef = await collection
        .where("bookerEmail", isEqualTo: email)
        .where("status", isEqualTo: "Completed")
        .get();
    docsRef.docs.forEach((element) {
      Booking _booking = Booking.fromJson(element.data());
      bookings.add(_booking);
    });
    return bookings;
  }

  
}

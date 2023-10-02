import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_staff/controllers/data_controller.dart';
import 'package:find_my_staff/data/booking.dart';
import 'package:find_my_staff/screens/common/complete_project.dart';
import 'package:find_my_staff/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewBooking extends StatefulWidget {
  String bookingID;

  ViewBooking({required this.bookingID});

  @override
  State<ViewBooking> createState() => _ViewBookingState();
}

class _ViewBookingState extends State<ViewBooking> {
  bool isLoading = true;
  Booking? booking;

  bool isOwner = false;

  bool? isAuthorWorker;

  DataController dataController = DataController();

  @override
  void initState() {
    getBooking();
    super.initState();
  }

  getBooking() async {
    Booking _booking = await dataController.getBookingByID(widget.bookingID);
    setState(() {
      isAuthorWorker = _booking.bookingType == "Worker" ? true : false;
      booking = _booking;
      isLoading = false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString("email")!;
    if (booking!.bookerEmail == email) {
      setState(() {
        isOwner = true;
      });
    }
  }

  formatDate(Timestamp formattable) {
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(formattable.toDate());
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isOwner
          ? booking!.status == "Completed"
              ? null
              : GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => CompleteProject(
                          booking: booking!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Complete Project",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
          : null,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "View Booking",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "View all details about Booking #${widget.bookingID}",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Card(
                            elevation: 4,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    "Gig:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                    booking!.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Booking Date:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                    "${formatDate(booking!.bookingDates.first)} till ${formatDate(booking!.bookingDates.last)}",
                                    style: TextStyle(),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Days Booked:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                    "${booking!.bookingDates.length}",
                                    style: TextStyle(),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Per Hour Wage",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                    !isAuthorWorker!
                                        ? "Undefined"
                                        : "Rs.${booking!.perHourCost}",
                                    style: TextStyle(),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Per Day Wage",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                    !isAuthorWorker!
                                        ? "Undefined"
                                        : "Rs.${(int.parse(booking!.perHourCost) * int.parse(booking!.daysBooked)).toString()}",
                                    style: TextStyle(),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Total Wage:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                    !isAuthorWorker!
                                        ? "Undefined"
                                        : "Rs.${booking!.totalCost}",
                                    style: TextStyle(),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Status:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                    "${booking!.status}",
                                    style: TextStyle(),
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    "Type:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                    "${booking!.bookingType}",
                                    style: TextStyle(),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (booking!.status == "Ongoing")
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              elevation: 4,
                              child: ListTile(
                                title: Text(
                                  "Chat Now",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "Discuss details of the project.",
                                ),
                                trailing: Icon(
                                  CupertinoIcons.chat_bubble,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_staff/controllers/data_controller.dart';
import 'package:find_my_staff/data/booking.dart';
import 'package:find_my_staff/data/category.dart';
import 'package:find_my_staff/data/contractor.dart';
import 'package:find_my_staff/data/gig.dart';
import 'package:find_my_staff/data/worker.dart';
import 'package:find_my_staff/screens/contractor/contractor_tab_manager.dart';
import 'package:find_my_staff/screens/customer/customer_tab_manager.dart';
import 'package:find_my_staff/screens/customer/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme.dart';

class HireSummary extends StatefulWidget {
  Gig gig;
  Category category;
  String hoursPerDay;
  List<DateTime> selectedDates;
  Worker? worker;
  Contractor? contractor;
  bool isWorker;

  HireSummary({
    required this.selectedDates,
    required this.gig,
    required this.category,
    required this.hoursPerDay,
    required this.isWorker,
    this.worker,
    this.contractor,
  });

  @override
  State<HireSummary> createState() => _HireSummaryState();
}

class _HireSummaryState extends State<HireSummary> {
  bool isLoading = false;

  DataController dataController = DataController();

  formatDate(DateTime formattable) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(formattable);
    return formattedDate;
  }

  bookNow() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bookerEmail = prefs.getString("email")!;
    List<Timestamp> bookingDates = [];
    widget.selectedDates.forEach((element) {
      Timestamp _ts = Timestamp.fromDate(element);
      bookingDates.add(_ts);
    });

    Booking newBooking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: widget.gig.title,
      status: "Ongoing",
      gig: widget.gig.id,
      bookerEmail: bookerEmail,
      authorEmail:
          !widget.isWorker ? widget.contractor!.email : widget.worker!.email,
      authorName:
          !widget.isWorker ? widget.contractor!.name : widget.worker!.name,
      bookingType: !widget.isWorker ? "Contractor" : "Worker",
      daysBooked: widget.selectedDates.length.toString(),
      perHourCost: !widget.isWorker ? "Undefined" : widget.worker!.hourlyRate,
      totalCost: !widget.isWorker
          ? "Undefined"
          : ((int.parse(
                        widget.worker!.hourlyRate,
                      ) *
                      int.parse(
                        widget.hoursPerDay,
                      )) *
                  widget.selectedDates.length)
              .toString(),
      bookingDates: bookingDates,
      bookedAt: Timestamp.fromDate(
        DateTime.now(),
      ),
    );

    bool isAdded = await dataController.addBooking(newBooking);
    if (isAdded) {
      if (widget.isWorker) {
        Fluttertoast.showToast(
            msg: "${widget.worker!.name}. hired successfully");
      } else {
        Fluttertoast.showToast(
            msg: "${widget.contractor!.name}. hired successfully");
      }
    } else {
      Fluttertoast.showToast(
          msg:
              "There was a problem in creating this booking, please try again later.");
    }

    String type = prefs.getString("type")!;
    if (type == "customer") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerTabManager(),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ContractorTabManager(),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Order Summary",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Please check all details before placing order.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            "Booking Date:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            "${formatDate(widget.selectedDates.first)} till ${formatDate(widget.selectedDates.last)}",
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
                            "${widget.selectedDates.length}",
                            style: TextStyle(),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Per Hour Cost",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            !widget.isWorker
                                ? "TBD"
                                : "Rs.${widget.worker!.hourlyRate}",
                            style: TextStyle(),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Per Day Cost",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            !widget.isWorker
                                ? "TBD"
                                : "Rs.${(int.parse(widget.worker!.hourlyRate) * int.parse(widget.hoursPerDay)).toString()}",
                            style: TextStyle(),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "Amount to Pay:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            !widget.isWorker
                                ? "TBD"
                                : "Rs.${((int.parse(widget.worker!.hourlyRate) * int.parse(widget.hoursPerDay)) * widget.selectedDates.length).toString()}",
                            style: TextStyle(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.info_outline,
                          ),
                          title: Text(
                            widget.isWorker
                                ? "If you and the author have agreed on a different quote, you can mention that at the completion of the project. This is a rough estimation."
                                : "\"Find My Staff\" believes both parties have already made an understanding about the cost of this project and will make transactions and work accordingly. Therefore we are not mentioning any monetary details.",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: Text(
                            "Select Payment Method",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Radio(
                            value: "cod",
                            groupValue: "cod",
                            onChanged: (value) {},
                          ),
                          title: Text(
                            "Cash on Completion",
                            style: TextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (isLoading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (!isLoading)
                    InkWell(
                      onTap: () {
                        bookNow();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              100,
                            ),
                          ),
                          color: primaryColor,
                          child: ListTile(
                            title: Center(
                              child: Text(
                                "Book Now",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_right,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

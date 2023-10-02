import 'package:find_my_staff/data/category.dart';
import 'package:find_my_staff/data/contractor.dart';
import 'package:find_my_staff/data/gig.dart';
import 'package:find_my_staff/data/worker.dart';
import 'package:find_my_staff/screens/customer/order_summary.dart';
import 'package:find_my_staff/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HireNow extends StatefulWidget {
  Gig gig;
  Category category;
  Worker? worker;
  Contractor? contractor;
  bool isWorker;

  HireNow({
    required this.gig,
    required this.isWorker,
    required this.category,
    this.worker,
    this.contractor,
  });

  @override
  State<HireNow> createState() => _HireNowState();
}

class _HireNowState extends State<HireNow> {
  DateTime? startDate;
  DateTime? endDate;

  String placedBidAmount = '';

  String currentUsername = "";

  final formKey = GlobalKey<FormState>();

  DateRangePickerController dateController = DateRangePickerController();

  TextEditingController hoursController = TextEditingController();

  List<DateTime> selectedDates = [];
  List<DateTime> blackoutDates = [];
  bool isLoading = false;

  void onSubmit(value) {
    setState(
      () {
        if (value is PickerDateRange) {
          setState(() {
            startDate = value.startDate;
            endDate = value.endDate;
          });
          if (endDate != null) {
            List<DateTime> dates = [];
            int differenceInDays = endDate!.difference(startDate!).inDays;
            bool hasBlackout = false;
            DateTime? blackoutStopper;
            for (int i = 0; i <= differenceInDays; i++) {
              DateTime currentDate = startDate!.add(Duration(days: i));
              if (blackoutDates.contains(currentDate)) {
                hasBlackout = true;
                blackoutStopper = currentDate;
                endDate = blackoutStopper.subtract(
                  Duration(
                    days: 1,
                  ),
                );
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Blackout Error",
                      ),
                      content: Text(
                        "You have selected a range that appears to have a non-working day for the author of this gig. We have altered the end date to the last available date. Please verify before booking or select a different range. Your start date is ${DateFormat('yyyy-MM-dd').format(startDate!)} and your end date is ${DateFormat('yyyy-MM-dd').format(endDate!)}",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "OK",
                          ),
                        ),
                      ],
                    );
                  },
                );
                break;
              }
            }
            differenceInDays = endDate!.difference(startDate!).inDays;
            for (int i = 0; i <= differenceInDays; i++) {
              DateTime currentDate = startDate!.add(Duration(days: i));
              dates.add(
                  DateTime.parse(DateFormat('yyyy-MM-dd').format(currentDate)));
            }

            setState(() {
              dateController.selectedRange =
                  PickerDateRange(startDate, endDate);
              selectedDates = dates;
            });
            selectedDates.forEach((element) {
              print(element.day);
            });
            if (!hasBlackout) {
              Fluttertoast.showToast(
                  msg: "Dates are available! You can book now.");
            }
          } else {
            setState(() {
              selectedDates = [
                startDate!,
              ];
              endDate = value.startDate;
            });
          }
        }
      },
    );
  }

  formatDate(DateTime formattable) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(formattable);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
        title: Text(
          "Hire ${widget.gig.authorName}",
          style: TextStyle(
            color: primaryColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Booking Date: ${selectedDates.isEmpty ? 'Not Specified' : formatDate(selectedDates.first)} - ${selectedDates.isEmpty ? 'Not Specified' : formatDate(selectedDates.last)}",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SfDateRangePicker(
                            controller: dateController,
                            showActionButtons: true,
                            selectionMode: DateRangePickerSelectionMode.range,
                            monthViewSettings: DateRangePickerMonthViewSettings(
                              blackoutDates: blackoutDates,
                              showTrailingAndLeadingDates: true,
                            ),
                            selectionTextStyle:
                                const TextStyle(color: Colors.white),
                            selectionColor: primaryColor,
                            startRangeSelectionColor: primaryColor,
                            endRangeSelectionColor: primaryColor,
                            rangeSelectionColor: primaryColor.withOpacity(
                              0.5,
                            ),
                            confirmText: "Submit Dates",
                            cancelText: '',
                            onSubmit: onSubmit,
                            todayHighlightColor: Colors.transparent,
                            minDate: DateTime.now().add(
                              Duration(
                                days: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final bidAmount = await showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomBidModal();
                                },
                              );
                              if (bidAmount != null && bidAmount.isNotEmpty) {
                                setState(() {
                                  placedBidAmount =
                                      bidAmount; // Update the bid amount on the main screen
                                });
                              }
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Center(
                                child: Text(
                                  "Place a Bid",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (widget.isWorker)
                            TextFormField(
                              controller: hoursController,
                              validator: (value) {
                                if (value!.length < 1) {
                                  return "Please enter atleast 1 character";
                                }
                                if (int.parse(value) > 10) {
                                  return "You can not book a gig for more than 10 hours a day";
                                }
                              },
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 2.0),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                hintText:
                                    "Please enter the required hours per day",
                                labelText: "Hours Per Day",
                                alignLabelWithHint: true,
                                // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                              ),
                            ),
                          if (placedBidAmount
                              .isNotEmpty) // Show bid amount message if placedBidAmount is not empty
                            Column(
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  "Your placed bid: \$${placedBidAmount}",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Bid amount will disappear after a few seconds.",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: selectedDates.isNotEmpty
          ? GestureDetector(
              onTap: () {
                bool isValid = formKey.currentState!.validate();
                if (isValid) {
                  String contText = "";
                  if (widget.isWorker) {
                    contText =
                        " for ${hoursController.text} hours each day. Do you confirm?";
                  } else {
                    contText =
                        ". \"Find My Staff\" believes both parties have already made an understanding about the cost of this project and will make transactions and work accordingly. Do you confirm?";
                  }
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Booking"),
                        content: Text(
                          "You are about to book ${widget.gig.authorName} from ${formatDate(selectedDates.first)} to ${formatDate(selectedDates.last)}" +
                              contText,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => HireSummary(
                                    gig: widget.gig,
                                    category: widget.category,
                                    hoursPerDay: hoursController.text,
                                    selectedDates: selectedDates,
                                    isWorker: widget.isWorker,
                                    worker:
                                        widget.isWorker ? widget.worker : null,
                                    contractor: !widget.isWorker
                                        ? widget.contractor
                                        : null,
                                  ),
                                ),
                              );
                            },
                            child: Text("Confirm"),
                          ),
                        ],
                      );
                    },
                  );
                }
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
                    "Hire Now",
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
    );
  }
}

class CustomBidModal extends StatefulWidget {
  @override
  _CustomBidModalState createState() => _CustomBidModalState();
}

class _CustomBidModalState extends State<CustomBidModal> {
  TextEditingController bidController = TextEditingController();
  void placeCustomBid(String customBid) {
    // Implement the logic to save the custom bid to Firestore or perform other actions
    // You can access the gig's details using widget.thisScreenGig

    Navigator.pop(context, customBid);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Place Custom Bid",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: bidController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter your bid",
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(primaryColor)),
            onPressed: () {
              String customBid = bidController.text;
              placeCustomBid(customBid);
              // Do something with the custom bid (e.g., save to Firestore)
              // Navigator.pop(context);
            },
            child: Text("Place Bid"),
          ),
        ],
      ),
    );
  }
}

import 'package:find_my_staff/controllers/data_controller.dart';
import 'package:find_my_staff/data/booking.dart';
import 'package:find_my_staff/data/review.dart';
import 'package:find_my_staff/screens/customer/customer_tab_manager.dart';
import 'package:find_my_staff/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CompleteProject extends StatefulWidget {
  Booking booking;

  CompleteProject({
    required this.booking,
  });

  @override
  State<CompleteProject> createState() => _CompleteProjectState();
}

class _CompleteProjectState extends State<CompleteProject> {
  final formKey = GlobalKey<FormState>();

  DataController dataController = DataController();

  TextEditingController reviewController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  bool isLoading = false;

  double rating = 0;
  bool? isWorker;

  @override
  void initState() {
    super.initState();
    getIfIsWorker();
  }

  getIfIsWorker() {
    if (widget.booking.bookingType == "Worker") {
      setState(() {
        isWorker = true;
      });
    } else {
      setState(() {
        isWorker = false;
      });
    }
  }

  completeProject() async {
    if (amountController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter a valid total cost of the project");
    } else if (rating == 0) {
      Fluttertoast.showToast(
          msg: "Please select one of the rating icons to rate the service");
    } else {
      setState(() {
        isLoading = true;
      });
      Review review = Review(
        bookingID: widget.booking.id,
        bookerEmail: widget.booking.bookerEmail,
        authorEmail: widget.booking.authorEmail,
        type: widget.booking.bookingType,
        rating: rating,
        review: reviewController.text,
        authorName: widget.booking.authorName,
      );
      bool isCompleted =
          await dataController.markBookingComplete(widget.booking.id);
      if (isCompleted) {
        bool isReviewed = await dataController.addReview(review);
        if (isReviewed) {
          if (isWorker!) {
            await dataController
                .addEarningsToWorker(
                    amountController.text, widget.booking.authorEmail)
                .then((value) {
              if (value) {
                Fluttertoast.showToast(
                    msg: "Project was successfully marked complete");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CustomerTabManager(),
                  ),
                  (route) => false,
                );
              } else {
                Fluttertoast.showToast(
                  msg:
                      "There was a problem connecting with the server, please try again later",
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CustomerTabManager(),
                  ),
                  (route) => false,
                );
              }
            });
          } else {
            await dataController
                .addEarningsToContractor(
                    amountController.text, widget.booking.authorEmail)
                .then((value) {
              if (value) {
                Fluttertoast.showToast(
                    msg: "Project was successfully marked complete");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CustomerTabManager(),
                  ),
                  (route) => false,
                );
              } else {
                Fluttertoast.showToast(
                  msg:
                      "There was a problem connecting with the server, please try again later",
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CustomerTabManager(),
                  ),
                  (route) => false,
                );
              }
            });
          }
        } else {
          Fluttertoast.showToast(
            msg:
                "There was a problem connecting with the server, please try again later",
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => CustomerTabManager(),
            ),
            (route) => false,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg:
              "There was a problem connecting with the server, please try again later",
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerTabManager(),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isWorker == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                              "Complete Project",
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
                              "Mark project complete and rate the author.",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "How much did you pay the author?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
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
                                hintText: "eg. 10000.",
                                labelText: "Amount in Rupees",
                                alignLabelWithHint: true,
                                // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "How do you rate the service? Please select an icon.",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: RatingBar.builder(
                                initialRating: 0,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  switch (index) {
                                    case 0:
                                      return Icon(
                                        Icons.sentiment_very_dissatisfied,
                                        color: Colors.red,
                                      );
                                    case 1:
                                      return Icon(
                                        Icons.sentiment_dissatisfied,
                                        color: Colors.redAccent,
                                      );
                                    case 2:
                                      return Icon(
                                        Icons.sentiment_neutral,
                                        color: Colors.amber,
                                      );
                                    case 3:
                                      return Icon(
                                        Icons.sentiment_satisfied,
                                        color: Colors.lightGreen,
                                      );
                                    case 4:
                                      return Icon(
                                        Icons.sentiment_very_satisfied,
                                        color: Colors.green,
                                      );
                                    default:
                                      return Container();
                                  }
                                },
                                onRatingUpdate: (number) {
                                  setState(() {
                                    rating = number;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: reviewController,
                              maxLines: 2,
                              maxLength: 50,
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
                                    "eg. Service was very good and timely.",
                                labelText:
                                    "Describe your experience (Optional)",
                                alignLabelWithHint: true,
                                // hintStyle: TextStyle(color: AppColors.primaryColorLight),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      if (isLoading)
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        ),
                      if (!isLoading)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              completeProject();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: Text(
                                    "Mark Completed",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

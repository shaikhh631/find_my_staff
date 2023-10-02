import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_staff/controllers/data_controller.dart';
import 'package:find_my_staff/data/category.dart';
import 'package:find_my_staff/data/chat.dart';
import 'package:find_my_staff/data/contractor.dart';
import 'package:find_my_staff/data/customer.dart';
import 'package:find_my_staff/data/gig.dart';
import 'package:find_my_staff/data/worker.dart';
import 'package:find_my_staff/screens/common/chat_screen.dart';
import 'package:find_my_staff/screens/customer/hire_now.dart';
import 'package:find_my_staff/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GigScreen extends StatefulWidget {
  Gig thisScreenGig;

  GigScreen({required this.thisScreenGig});

  @override
  State<GigScreen> createState() => _GigScreenState();
}

class _GigScreenState extends State<GigScreen> {
  DataController dataController = DataController();

  bool isLoading = true;

  String userType = "";

  bool isOwner = true;

  bool? isWorker;

  Category? category;
  Worker? workerAuthor;
  Contractor? contractorAuthor;

  Customer? potentialUserCustomer;
  Contractor? potentialUserContractor;

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String type = prefs.getString("type")!;
    String email = prefs.getString("email")!;

    if (email == widget.thisScreenGig.authorEmail) {
      setState(() {
        isOwner = true;
      });
    } else {
      setState(() {
        isOwner = false;
      });
    }

    if (type == "customer") {
      Customer _customer = await dataController.getCustomer(email);
      setState(() {
        potentialUserCustomer = _customer;
        userType = type;
      });
    } else {
      Contractor _contractor = await dataController.getContractor(email);
      setState(() {
        potentialUserContractor = _contractor;
        userType = type;
      });
    }

    loadAuthorDetails();
    loadCategory();
  }

  loadCategory() async {
    Category thisCat =
        dataController.categories[dataController.categories.indexWhere(
      (element) => element.tag == widget.thisScreenGig.category,
    )];
    setState(() {
      category = thisCat;
    });
  }

  loadAuthorDetails() async {
    if (widget.thisScreenGig.authorType == "contractor") {
      setState(() {
        isWorker = false;
      });
      Contractor _contractor =
          await dataController.getContractor(widget.thisScreenGig.authorEmail);
      setState(() {
        contractorAuthor = _contractor;
        isLoading = false;
      });
    } else {
      setState(() {
        isWorker = true;
      });
      Worker _worker =
          await dataController.getWorker(widget.thisScreenGig.authorEmail);
      setState(() {
        workerAuthor = _worker;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HireNow(
                      gig: widget.thisScreenGig,
                      category: category!,
                      worker: isWorker! ? workerAuthor : null,
                      contractor: !isWorker! ? contractorAuthor : null,
                      isWorker: isWorker!,
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
                    "Hire Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
      body: isWorker == null
          ? Container()
          : !isWorker!
              ? contractorAuthor != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 25,
                                ),
                                child: Center(
                                  child: Icon(
                                    category!.icon,
                                    color: Colors.white,
                                    size: 75,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  category!.tag,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Gig Description",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.thisScreenGig.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Author",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/contractor.png",
                                    height: 50,
                                    width: 50,
                                  ),

                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.black,
                                  //     borderRadius: BorderRadius.circular(
                                  //       100,
                                  //     ),
                                  //   ),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(12.0),
                                  //     child: Icon(
                                  //       Icons.person,
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    contractorAuthor!.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  // Row(
                                  //   children: [
                                  //     Icon(
                                  //       Icons.star,
                                  //       color: Colors.amber,
                                  //       size: 20,
                                  //     ),
                                  //     SizedBox(
                                  //       width: 5,
                                  //     ),
                                  //     Text(
                                  //       widget.thisScreenGig.rating.toString() +
                                  //           ".0",
                                  //       style: TextStyle(
                                  //         fontSize: 16,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  if (!isOwner)
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        String chatID = DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString();
                                        String myEmail = "";
                                        String participantEmail = "";
                                        String myName = "";
                                        String participantName = "";
                                        if (userType == "customer") {
                                          myEmail =
                                              potentialUserCustomer!.email;
                                          myName = potentialUserCustomer!.name;
                                        } else {
                                          myName =
                                              potentialUserContractor!.name;
                                          myEmail =
                                              potentialUserContractor!.email;
                                        }

                                        if (isWorker!) {
                                          participantEmail =
                                              workerAuthor!.email;
                                          participantName = workerAuthor!.name;
                                        } else {
                                          participantEmail =
                                              contractorAuthor!.email;
                                          participantName =
                                              contractorAuthor!.name;
                                        }
                                        Chat newChat = Chat(
                                          id: chatID,
                                          participantIDs: [
                                            myEmail,
                                            participantEmail,
                                          ],
                                          participantNames: [
                                            myName,
                                            participantName,
                                          ],
                                        );
                                        var collection = FirebaseFirestore
                                            .instance
                                            .collection("chats");
                                        var docRef = await collection.where(
                                          "participantIDs",
                                          arrayContainsAny: [
                                            myEmail,
                                            participantEmail,
                                          ],
                                        ).get();
                                        if (docRef.docs.length == 1) {
                                          print("All Good");
                                          Chat _retrievedChat = Chat.fromJson(
                                            docRef.docs.first.data(),
                                          );
                                          setState(() {
                                            newChat = _retrievedChat;
                                            isLoading = false;
                                          });
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (_) => ChatScreen(
                                                chat: newChat,
                                                type: userType,
                                                partner: participantName,
                                                contractor:
                                                    potentialUserContractor,
                                                customer: potentialUserCustomer,
                                              ),
                                            ),
                                          );
                                        } else if (docRef.docs.length == 0) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (_) => ChatScreen(
                                                chat: newChat,
                                                type: userType,
                                                partner: participantName,
                                                contractor:
                                                    potentialUserContractor,
                                                customer: potentialUserCustomer,
                                              ),
                                            ),
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg:
                                                "There are multiple chats of this type",
                                          );
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.message,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                contractorAuthor!.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.monetization_on,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                title: Text(
                                  "Cost: Contractor costs are decided on chat after you hire them.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.calendar_month,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                title: Text(
                                  "Experience: " + contractorAuthor!.experience,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.work,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                title: Text(
                                  "Skills: " + contractorAuthor!.category,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container()
              : workerAuthor != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 25,
                                ),
                                child: Center(
                                  child: Icon(
                                    category!.icon,
                                    color: Colors.white,
                                    size: 75,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  category!.tag,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Gig Description",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.thisScreenGig.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Author",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/welcome.png",
                                    height: 50,
                                    width: 50,
                                  ),

                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.black,
                                  //     borderRadius: BorderRadius.circular(
                                  //       100,
                                  //     ),
                                  //   ),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(12.0),
                                  //     child: Icon(
                                  //       Icons.person,
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    workerAuthor!.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        widget.thisScreenGig.rating.toString() +
                                            ".0",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                workerAuthor!.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryColor,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.monetization_on,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                title: Text(
                                  "Rs." +
                                      workerAuthor!.hourlyRate +
                                      " per hour",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.calendar_month,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                title: Text(
                                  "Experience: " + workerAuthor!.experience,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.work,
                                  color: primaryColor,
                                  size: 20,
                                ),
                                title: Text(
                                  "Skills: " + workerAuthor!.skills,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),
    );
  }
}

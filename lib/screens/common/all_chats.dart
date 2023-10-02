import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_staff/controllers/data_controller.dart';
import 'package:find_my_staff/data/chat.dart';
import 'package:find_my_staff/data/contractor.dart';
import 'package:find_my_staff/data/customer.dart';
import 'package:find_my_staff/data/worker.dart';
import 'package:find_my_staff/screens/common/chat_screen.dart';
import 'package:find_my_staff/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllChats extends StatefulWidget {
  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  bool isLoading = true;

  DataController dataController = DataController();

  Worker? worker;
  Contractor? contractor;
  Customer? customer;

  String type = "";
  String email = "";

  List<Chat> chats = [];

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _email = prefs.getString("email")!;
    String _type = prefs.getString("type")!;
    if (_type == "worker") {
      Worker _worker = await dataController.getWorker(_email);
      setState(() {
        worker = _worker;
        type = _type;
        email = _email;
      });
    } else if (_type == "contractor") {
      Contractor _contractor = await dataController.getContractor(_email);
      setState(() {
        contractor = _contractor;
        type = _type;
        email = _email;
      });
    } else {
      Customer _customer = await dataController.getCustomer(_email);
      setState(() {
        customer = _customer;
        type = _type;
        email = _email;
      });
    }
    getChats();
  }

  getChats() async {
    var collection = FirebaseFirestore.instance.collection("chats");
    var docRef = await collection.where(
      "participantIDs",
      arrayContainsAny: [
        email,
      ],
    ).get();
    docRef.docs.forEach((element) {
      Chat newChat = Chat.fromJson(
        element.data(),
      );
      setState(() {
        chats.add(newChat);
      });
    });
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contacts",
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
                    "Communicate your requirement with workers",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (isLoading)
              SizedBox(
                height: 50,
              ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
            if (!isLoading)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    String userName = "";
                    if (type == "worker") {
                      userName = worker!.name;
                    } else if (type == "contractor") {
                      userName = contractor!.name;
                    } else {
                      userName = customer!.name;
                    }
                    String participantName = "";
                    if (chats[index].participantNames.first == userName) {
                      participantName = chats[index].participantNames.last;
                    } else {
                      participantName = chats[index].participantNames.first;
                    }
                    return ListTile(
                      leading: Icon(
                        CupertinoIcons.person_alt_circle_fill,
                        size: 40,
                        color: primaryColor,
                      ),
                      title: Text(participantName),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              chat: chats[index],
                              type: type,
                              worker: worker != null ? worker : null,
                              contractor:
                                  contractor != null ? contractor : null,
                              customer: customer != null ? customer : null,
                              partner: participantName,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_staff/data/chat.dart';
import 'package:find_my_staff/data/contractor.dart';
import 'package:find_my_staff/data/customer.dart';
import 'package:find_my_staff/data/message.dart';
import 'package:find_my_staff/data/worker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme.dart';

class ChatScreen extends StatefulWidget {
  Chat chat;
  Worker? worker;
  Contractor? contractor;
  Customer? customer;
  String type;
  String partner;

  ChatScreen({
    required this.chat,
    required this.type,
    required this.partner,
    this.worker,
    this.contractor,
    this.customer,
  });
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isLoading = true;
  String myEmail = "";

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    getState();
    super.initState();
  }

  getState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _email = prefs.getString("email")!;
    setState(() {
      myEmail = _email;
    });
    checkIfExists();
  }

  checkIfExists() async {
    var collection = FirebaseFirestore.instance.collection("chats");
    var docRef = await collection
        .where(
          "participantIDs",
          arrayContainsAny: widget.chat.participantIDs,
        )
        .get();
    if (docRef.docs.length == 1) {
      print("All Good");
      setState(() {
        widget.chat.id = docRef.docs.first.id;
        isLoading = false;
      });
    } else if (docRef.docs.length == 0) {
      await collection
          .doc(widget.chat.id)
          .set(
            widget.chat.toJson(),
          )
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      Fluttertoast.showToast(
        msg: "There are multiple chats of this type",
      );
    }
  }

  void _handleSubmitted(String text) {
    if (text == "") return;
    String userName = "";
    if (widget.type == "worker") {
      userName = widget.worker!.name;
    } else if (widget.type == "contractor") {
      userName = widget.contractor!.name;
    } else {
      userName = widget.customer!.name;
    }
    String senderName = "";
    if (widget.chat.participantNames.first == userName) {
      senderName = widget.chat.participantNames.first;
    } else {
      senderName = widget.chat.participantNames.first;
    }
    _textController.clear();
    String messageID = DateTime.now().microsecondsSinceEpoch.toString();
    Message message = Message(
      id: messageID,
      chatID: widget.chat.id,
      createdAt: Timestamp.now(),
      content: text,
      isPicture: false,
      email: myEmail,
      senderName: senderName,
      isMe: true,
    );
    FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chat.id)
        .collection("messages")
        .doc()
        .set(
          message.toJson(),
        );
  }

  Widget _buildChatList() {
    return Flexible(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc(widget.chat.id)
            .collection("messages")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          List<Message> _messages = [];

          if (snapshot.hasData) {
            snapshot.data!.docs.forEach((element) {
              print(element.data());
              Message newMess = Message.fromJson(
                element.data(),
              );
              newMess.isMe = newMess.email == myEmail;
              _messages.add(newMess);
            });
          }

          return !snapshot.hasData
              ? Container()
              : ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Message message = _messages[index];
                    return _buildChatMessage(message);
                  },
                );
        },
      ),
    );
  }

  Widget _buildChatMessage(Message message) {
    message.isMe = myEmail == message.email ? true : false;
    final AlignmentGeometry alignment =
        message.isMe ? Alignment.centerRight : Alignment.centerLeft;

    final BorderRadiusGeometry borderRadius = message.isMe
        ? BorderRadius.only(
            topLeft: Radius.circular(16.0),
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          )
        : BorderRadius.only(
            topRight: Radius.circular(16.0),
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          );

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      alignment: alignment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.senderName,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey[600],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 4.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: message.isMe ? Colors.blue[300] : Colors.grey[200],
              borderRadius: borderRadius,
            ),
            child: Text(
              message.content,
              style: TextStyle(
                fontSize: 16.0,
                color: message.isMe ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 5,
              ),
              child: TextField(
                controller: _textController,
                textInputAction: TextInputAction.send,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          children: [
            Text(
              widget.partner,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                _buildChatList(),
                Divider(
                  height: 1.0,
                  color: Colors.grey[300],
                ),
                _buildMessageInput(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
    );
  }
}

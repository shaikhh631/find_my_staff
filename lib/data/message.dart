import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  String chatID;
  Timestamp createdAt;
  String content;
  bool isPicture;
  String email;
  String senderName;
  bool isMe;

  Message({
    required this.id,
    required this.chatID,
    required this.createdAt,
    required this.content,
    required this.isPicture,
    required this.email,
    required this.senderName,
    required this.isMe,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      chatID: json["chatID"],
      createdAt: json["createdAt"],
      content: json["content"],
      isPicture: json["isPicture"],
      email: json["email"],
      senderName: json["senderName"],
      isMe: json["isMe"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "chatID": chatID,
      "createdAt": createdAt,
      "content": content,
      "isPicture": isPicture,
      "email": email,
      "senderName": senderName,
      "isMe": isMe,
    };
  }
}

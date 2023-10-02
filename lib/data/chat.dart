class Chat {
  String id;
  List<dynamic> participantIDs;
  List<dynamic> participantNames;

  Chat({
    required this.id,
    required this.participantIDs,
    required this.participantNames,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      participantIDs: json['participantIDs'],
      participantNames: json['participantNames'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "participantIDs": participantIDs,
      "participantNames": participantNames,
    };
  }
}

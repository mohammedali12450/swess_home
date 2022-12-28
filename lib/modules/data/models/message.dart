class Message {
  int id;
  String username;
  String message;
  String sendDate;
  String? replayMessage;
  String? replayDate;

  Message(
      {required this.id,
      required this.username,
      required this.message,
      required this.sendDate,
      this.replayMessage,
      this.replayDate});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json["id"],
        username: json["customer"],
        message: json["subject"],
        sendDate: json["created_at"],
        replayDate: json["reply_date"] == null ? null : json["reply_date"],
        replayMessage:
            json["reply"] == null ? null : json["reply"]);
  }
}

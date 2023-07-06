import 'dart:convert';

import 'package:chatonym/Models/user_model.dart';

class Message {
  final String message;
  final DBUser sender;
  final DateTime time;
  Message({
    required this.message,
    required this.sender,
    required this.time,
  });

  Message copyWith({
    String? message,
    DBUser? sender,
    DateTime? time,
  }) {
    return Message(
      message: message ?? this.message,
      sender: sender ?? this.sender,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'sender': sender.toMap(),
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'] ?? '',
      sender: DBUser.fromMap(map['sender']),
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));

  @override
  String toString() => 'Message(message: $message, sender: $sender, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Message &&
      other.message == message &&
      other.sender == sender &&
      other.time == time;
  }

  @override
  int get hashCode => message.hashCode ^ sender.hashCode ^ time.hashCode;
}

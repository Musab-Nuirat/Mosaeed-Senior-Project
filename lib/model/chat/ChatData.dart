import 'package:flutter/foundation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

class ChatData {
  List<Message> messages;
  User assistant;
  User user;
  ChatData({
    required this.messages,
    required this.assistant,
    required this.user,
  });

  ChatData copyWith({
    List<Message>? messages,
    User? assistant,
    User? user,
  }) {
    return ChatData(
      messages: messages ?? this.messages,
      assistant: assistant ?? this.assistant,
      user: user ?? this.user,
    );
  }

  static List<Message> dummyChat = [];

  @override
  bool operator == (covariant ChatData other) {
    if (identical(this, other)) return true;

    return listEquals(other.messages, messages) &&
        other.assistant == assistant &&
        other.user == user;
  }

  @override
  int get hashCode => messages.hashCode ^ assistant.hashCode ^ user.hashCode;
}

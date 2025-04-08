class Message {
  final bool isBot;
  final String userId;
  final String content;
  final DateTime timestamp;

  Message({
    required this.isBot,
    required this.userId,
    required this.content,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      isBot: json['isBot'] as bool,
      userId: json['userId'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isBot': isBot,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

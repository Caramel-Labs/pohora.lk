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

  // Factory constructor to create a Message from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      isBot: json['is_bot'] ?? false,
      userId: json['user_id'] ?? 'anonymous',
      content: json['content'] ?? '',
      timestamp:
          json['timestamp'] != null
              ? DateTime.parse(json['timestamp'])
              : DateTime.now(),
    );
  }

  // Convert Message to JSON
  Map<String, dynamic> toJson() {
    return {
      'is_bot': isBot,
      'user_id': userId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

import 'package:intl/intl.dart';

class News {
  final int id;
  final String title;
  final String body;
  final String imagePath;
  final DateTime timestamp;
  final String author;

  News({
    required this.id,
    required this.title,
    required this.body,
    required this.imagePath,
    required this.timestamp,
    required this.author,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      imagePath: json['imagePath'],
      timestamp: DateTime.parse(json['timestamp']),
      author: json['author'],
    );
  }

  String get formattedDate {
    return DateFormat('MMM d, yyyy').format(timestamp);
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return formattedDate;
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}

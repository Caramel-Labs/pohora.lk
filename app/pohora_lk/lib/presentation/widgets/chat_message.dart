import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pohora_lk/data/models/message.dart';

class ChatMessage extends StatelessWidget {
  final Message message;

  const ChatMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isUser = !message.isBot;
    final timeFormat = DateFormat('h:mm a');
    final dateFormat = DateFormat('MMM d');
    final now = DateTime.now();
    final messageDate = message.timestamp;

    String timeString;
    if (now.difference(messageDate).inDays > 0) {
      timeString = dateFormat.format(messageDate);
    } else {
      timeString = timeFormat.format(messageDate);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.smart_toy, color: Colors.white),
                ),
                const SizedBox(width: 8.0),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isUser
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              if (isUser) const SizedBox(width: 8.0),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 4.0,
              left: isUser ? 0 : 40.0,
              right: isUser ? 8.0 : 0,
            ),
            child: Text(
              timeString,
              style: TextStyle(fontSize: 11.0, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pohora_lk/data/models/message.dart';

class ChatRepository {
  final String _baseUrl = 'http://localhost:8080';
  final FirebaseAuth _firebaseAuth;

  ChatRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<List<Message>> sendMessage(String message) async {
    try {
      // Get current user ID from Firebase Auth
      final userId = _firebaseAuth.currentUser?.uid ?? 'anonymous';

      final response = await http.post(
        Uri.parse('$_baseUrl/messages/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'content': message,
          'isBot': false,
          'userId': userId,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      // For development fallback in case API is not available
      print('Error sending message: $e');
      return [
        Message(
          isBot: false,
          userId: _firebaseAuth.currentUser?.uid ?? 'anonymous',
          content: message,
          timestamp: DateTime.now(),
        ),
        Message(
          isBot: true,
          userId: 'bot',
          content:
              'Sorry, I am having trouble connecting to the server. Please try again later.',
          timestamp: DateTime.now().add(const Duration(seconds: 1)),
        ),
      ];
    }
  }

  Future<List<Message>> getMessageHistory() async {
    try {
      final userId = _firebaseAuth.currentUser?.uid ?? 'anonymous';

      final response = await http.get(
        Uri.parse('$_baseUrl/messages/$userId/history'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to get message history: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error getting message history: $e');
      return [];
    }
  }
}

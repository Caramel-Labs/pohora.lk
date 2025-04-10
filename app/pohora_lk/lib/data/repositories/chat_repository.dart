import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pohora_lk/data/models/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  final String _baseUrl = 'https://pohora-intelligence.koyeb.app';
  FirebaseAuth _firebaseAuth;

  // Keep track of the current user ID to detect changes
  String? _currentUserId;

  // Store chat history locally in memory
  final List<Message> _localChatHistory = [];

  // Singleton pattern for ChatRepository
  static final ChatRepository _instance = ChatRepository._internal();

  factory ChatRepository({FirebaseAuth? firebaseAuth}) {
    _instance._firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

    // Check if user has changed and reload chat history if needed
    _instance._checkAndUpdateUser();

    return _instance;
  }

  ChatRepository._internal() : _firebaseAuth = FirebaseAuth.instance {
    // Listen for auth state changes to reload chat history when user changes
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user?.uid != _currentUserId) {
        _checkAndUpdateUser();
      }
    });
  }

  // Check if the user has changed and update history accordingly
  Future<void> _checkAndUpdateUser() async {
    final newUserId = _firebaseAuth.currentUser?.uid ?? 'anonymous';

    if (_currentUserId != newUserId) {
      print('User changed from: $_currentUserId to: $newUserId');
      _currentUserId = newUserId;

      // Clear current history and load the new user's history
      _localChatHistory.clear();
      await _loadChatHistoryFromStorage();
    }
  }

  // Method to send a message and get response
  Future<List<Message>> sendMessage(String message) async {
    // Ensure we have the latest user ID before processing
    await _checkAndUpdateUser();

    try {
      // Get current user ID from Firebase Auth
      final userId = _currentUserId ?? 'anonymous';

      // Create user message
      final userMessage = Message(
        isBot: false,
        userId: userId,
        content: message,
        timestamp: DateTime.now(),
      );

      // Add user message to local history
      _localChatHistory.add(userMessage);

      // Format the request according to the expected schema
      final requestBody = {
        "messages": [
          {"content": message, "sender": "human"},
        ],
      };

      print('Sending chat request: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/get-agent-response/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Chat response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Parse the response according to the expected format
        final responseData = jsonDecode(response.body);
        print('Chat response data: $responseData');

        // Extract the output from the response
        final botResponseText = responseData['data']['output'] as String;

        // Create bot message
        final botMessage = Message(
          isBot: true,
          userId: 'bot',
          content: botResponseText,
          timestamp: DateTime.now().add(const Duration(seconds: 1)),
        );

        // Add bot message to local history
        _localChatHistory.add(botMessage);

        // Save updated chat history to persistent storage
        _saveChatHistoryToStorage();

        // Return just the two latest messages (question and answer)
        return [userMessage, botMessage];
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      // For development fallback in case API is not available
      print('Error sending message: $e');

      // Create user message
      final userMessage = Message(
        isBot: false,
        userId: _currentUserId ?? 'anonymous',
        content: message,
        timestamp: DateTime.now(),
      );

      // Create error bot message
      final botMessage = Message(
        isBot: true,
        userId: 'bot',
        content:
            'Sorry, I am having trouble connecting to the server. Please try again later.',
        timestamp: DateTime.now().add(const Duration(seconds: 1)),
      );

      // Add both messages to local history
      _localChatHistory.add(userMessage);
      _localChatHistory.add(botMessage);

      // Save updated chat history to persistent storage
      _saveChatHistoryToStorage();

      return [userMessage, botMessage];
    }
  }

  // Get the entire chat history from local memory
  Future<List<Message>> getMessageHistory() async {
    // Ensure we have the latest user before returning history
    await _checkAndUpdateUser();

    // Return a copy of the list to prevent outside modifications
    return List<Message>.from(_localChatHistory);
  }

  // Clear chat history
  Future<void> clearChatHistory() async {
    _localChatHistory.clear();

    // Also clear from persistent storage
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('chat_history_$_currentUserId');
    } catch (e) {
      print('Error clearing chat history from storage: $e');
    }
  }

  // Save chat history to SharedPreferences for persistence
  Future<void> _saveChatHistoryToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = _currentUserId ?? 'anonymous';

      print('Saving chat history for user: $userId');

      // Convert message list to JSON
      final List<Map<String, dynamic>> serializedMessages =
          _localChatHistory.map((msg) => msg.toJson()).toList();

      // Save to SharedPreferences
      await prefs.setString(
        'chat_history_$userId',
        jsonEncode(serializedMessages),
      );
    } catch (e) {
      print('Error saving chat history to storage: $e');
    }
  }

  // Load chat history from SharedPreferences
  Future<void> _loadChatHistoryFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = _currentUserId ?? 'anonymous';

      print('Loading chat history for user: $userId');

      final String? storedData = prefs.getString('chat_history_$userId');

      if (storedData != null) {
        // Parse the JSON string
        final List<dynamic> jsonList = jsonDecode(storedData);

        // Convert JSON to Message objects
        final List<Message> loadedMessages =
            jsonList
                .map((json) => Message.fromJson(json as Map<String, dynamic>))
                .toList();

        // Clear and add all loaded messages
        _localChatHistory.clear();
        _localChatHistory.addAll(loadedMessages);

        print('Loaded ${loadedMessages.length} messages for user: $userId');
      } else {
        print('No chat history found for user: $userId');
      }
    } catch (e) {
      print('Error loading chat history from storage: $e');
    }
  }
}

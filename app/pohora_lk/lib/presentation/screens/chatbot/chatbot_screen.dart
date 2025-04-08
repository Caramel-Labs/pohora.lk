import 'package:flutter/material.dart';
import 'package:pohora_lk/data/models/message.dart';
import 'package:pohora_lk/data/repositories/chat_repository.dart';
import 'package:pohora_lk/presentation/widgets/chat_message.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatRepository _chatRepository = ChatRepository();

  List<Message> _messages = [];
  bool _isLoading = true;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessageHistory();
  }

  Future<void> _loadMessageHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final messages = await _chatRepository.getMessageHistory();
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) async {
    _messageController.clear();

    if (text.trim().isEmpty) return;

    // Add user message immediately for responsiveness
    setState(() {
      _messages.add(
        Message(
          isBot: false,
          userId: 'pending',
          content: text,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    _scrollToBottom();

    try {
      // Send to API and get response
      final List<Message> newMessages = await _chatRepository.sendMessage(text);

      setState(() {
        // Replace the pending message and add bot response(s)
        _messages.removeLast(); // Remove the pending message
        _messages.addAll(newMessages);
        _isTyping = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isTyping = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send message: $e')));
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0, // In a reversed ListView, 0 is the bottom (most recent)
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AgriAssistant'), elevation: 1),
      // Use a regular Column for the chat content
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  // Chat messages area - takes full screen
                  Positioned.fill(
                    child:
                        _messages.isEmpty
                            ? _buildWelcomeCard()
                            : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.fromLTRB(
                                8.0,
                                8.0,
                                8.0,
                                80.0,
                              ), // Add bottom padding for input
                              reverse: true,
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                return ChatMessage(
                                  message:
                                      _messages[_messages.length - 1 - index],
                                );
                              },
                            ),
                  ),

                  // Typing indicator
                  if (_isTyping)
                    Positioned(
                      bottom: 80, // Position above input area
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Typing...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      // Move the input field to the floatingActionButton property
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: SizedBox(
          width: double.infinity,
          child: FloatingActionButton(
            elevation: 3,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
              side: BorderSide(color: Colors.grey.shade300, width: 0.5),
            ),
            onPressed: null, // No action on button itself
            child: Row(
              children: [
                // Text field takes most of the space
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask something about farming...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                    ),
                    onSubmitted: _handleSubmitted,
                  ),
                ),

                // Send button
                Container(
                  margin: const EdgeInsets.only(left: 4, right: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => _handleSubmitted(_messageController.text),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Set the FloatingActionButton to stretch across the screen
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Extract welcome card to its own method
  Widget _buildWelcomeCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        // Center the card vertically
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Only take as much space as needed
              children: [
                Icon(
                  Icons.smart_toy_rounded,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Farming Assistant',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ask me anything about farming, crops, fertilizers, or pest control!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildSuggestionChip('Best fertilizers?'),
                    _buildSuggestionChip('Weather impact'),
                    _buildSuggestionChip('Rice cultivation'),
                    _buildSuggestionChip('Pest control'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () => _handleSubmitted(text),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    );
  }
}

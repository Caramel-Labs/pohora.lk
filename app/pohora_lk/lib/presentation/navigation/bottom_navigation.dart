import 'package:flutter/material.dart';
import 'package:pohora_lk/presentation/screens/chatbot/chatbot_screen.dart';
import 'package:pohora_lk/presentation/screens/home/home_screen.dart';
import 'package:pohora_lk/presentation/screens/news/news_screen.dart';
import 'package:pohora_lk/presentation/screens/profile/profile_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    const ChatbotScreen(),
    const NewsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            icon: Image.asset(
              'assets/icons/ai_chat_outlined.png',
              width: 24,
              height: 24,
            ),
            selectedIcon: Image.asset(
              'assets/icons/ai_chat_filled.png',
              width: 24,
              height: 24,
            ),
            label: 'Assistant',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'News',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

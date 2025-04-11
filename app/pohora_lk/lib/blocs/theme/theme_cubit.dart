import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    emit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    try {
      final isDarkMode = state == ThemeMode.dark;
      final prefs = await SharedPreferences.getInstance();

      // First update shared preferences
      await prefs.setBool('isDarkMode', !isDarkMode);

      // Then emit the new state to trigger UI rebuild
      final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
      print('Changing theme to: ${newMode.toString()}');
      emit(newMode);
    } catch (e) {
      print('Error toggling theme: $e');
    }
  }

  bool get isDarkMode => state == ThemeMode.dark;
}

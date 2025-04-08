import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pohora_lk/blocs/auth/auth_bloc.dart';
import 'package:pohora_lk/blocs/auth/auth_state.dart';
import 'package:pohora_lk/presentation/navigation/bottom_navigation.dart';
import 'package:pohora_lk/presentation/screens/auth/forgot_password_screen.dart';
import 'package:pohora_lk/presentation/screens/auth/login_screen.dart';
import 'package:pohora_lk/presentation/screens/auth/register_screen.dart';
import 'package:pohora_lk/presentation/screens/home/add_cultivation_screen.dart';
import 'package:pohora_lk/presentation/screens/home/home_screen.dart';
import 'package:pohora_lk/presentation/screens/profile/profile_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String cropDetails = '/crop-details';
  static const String addCultivation = '/add-cultivation';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
    // initial: (context) => const App(),
    initial:
        (context) => BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              return const BottomNavigation();
            } else if (state.status == AuthStatus.unauthenticated) {
              return const LoginScreen();
            }
            // Loading state
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    home: (context) => HomeScreen(),
    addCultivation: (context) => const AddCultivationScreen(),
    profile: (context) => const ProfileScreen(),
  };
}

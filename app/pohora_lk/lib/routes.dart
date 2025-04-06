import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pohora_lk/app/app.dart';
import 'package:pohora_lk/blocs/auth/auth_bloc.dart';
import 'package:pohora_lk/blocs/auth/auth_state.dart';
import 'package:pohora_lk/presentation/navigation/bottom_navigation.dart';
import 'package:pohora_lk/presentation/screens/auth/forgot_password_screen.dart';
import 'package:pohora_lk/presentation/screens/auth/login_screen.dart';
import 'package:pohora_lk/presentation/screens/auth/register_screen.dart';
import 'package:pohora_lk/presentation/screens/home/home_screen.dart';
import 'package:pohora_lk/presentation/screens/home/crop_details_screen.dart';
import 'package:pohora_lk/presentation/screens/home/add_crop_screen.dart';
import 'package:pohora_lk/presentation/screens/news/news_detail_screen.dart';
import 'package:pohora_lk/presentation/screens/profile/profile_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String cropDetails = '/crop-details';
  static const String addCrop = '/add-crop';
  static const String newsDetail = '/news-detail';
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
    cropDetails: (context) => const CropDetailsScreen(),
    addCrop: (context) => const AddCropScreen(),
    newsDetail: (context) => const NewsDetailScreen(),
    profile: (context) => const ProfileScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case cropDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder:
              (context) => CropDetailsScreen(
                // cropId: args['cropId'],
              ),
        );
      case newsDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder:
              (context) => NewsDetailScreen(
                // newsId: args['newsId'],
              ),
        );
      default:
        return MaterialPageRoute(
          builder:
              (context) =>
                  const Scaffold(body: Center(child: Text('Route not found!'))),
        );
    }
  }
}

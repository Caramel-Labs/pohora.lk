import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pohora_lk/blocs/auth/auth_bloc.dart';
import 'package:pohora_lk/blocs/auth/auth_state.dart';
import 'package:pohora_lk/presentation/navigation/bottom_navigation.dart';
import 'package:pohora_lk/presentation/screens/auth/login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          return const BottomNavigation();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

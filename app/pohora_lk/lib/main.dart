import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pohora_lk/blocs/auth/auth_bloc.dart';
import 'package:pohora_lk/data/repositories/auth_repository.dart';
import 'package:pohora_lk/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authRepository = AuthRepository();

  runApp(
    RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        create: (context) => AuthBloc(authRepository: authRepository),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pohora.lk',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 23, 129, 80),
        ),
      ),
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

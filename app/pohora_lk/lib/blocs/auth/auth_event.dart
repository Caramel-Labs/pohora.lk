import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthInitialized extends AuthEvent {}

class EmailSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const EmailSignInRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class GoogleSignInRequested extends AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignOutRequested extends AuthEvent {}

class ResetPasswordRequested extends AuthEvent {
  final String email;

  const ResetPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pohora_lk/blocs/auth/auth_event.dart';
import 'package:pohora_lk/blocs/auth/auth_state.dart';
import 'package:pohora_lk/data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _authStateSubscription;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState.unknown()) {
    on<AuthInitialized>(_onAuthInitialized);
    on<EmailSignInRequested>(_onEmailSignInRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);

    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });

    add(AuthInitialized());
  }

  void _onAuthInitialized(AuthInitialized event, Emitter<AuthState> emit) {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onEmailSignInRequested(
    EmailSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.unknown));
    try {
      await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
    } catch (e) {
      emit(AuthState.unauthenticated(e.toString()));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.unknown));
    try {
      await _authRepository.signInWithGoogle();
    } catch (e) {
      emit(AuthState.unauthenticated(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.unknown));
    try {
      await _authRepository.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
    } catch (e) {
      emit(AuthState.unauthenticated(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.signOut();
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.resetPassword(event.email);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}

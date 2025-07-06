import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit({required this.repository}) : super(AuthInitial());

  void checkAuthStatus() {
    final userId = repository.getCurrentUserId();
    if (userId != null) {
      emit(AuthAuthenticated(userId));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      await repository.signUp(email, password);
      checkAuthStatus();
    } catch (e) {
      emit(AuthError('Sign up failed: $e'));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await repository.signIn(email, password);
      checkAuthStatus();
    } catch (e) {
      emit(AuthError('Login failed: $e'));
    }
  }

  Future<void> signOut() async {
    await repository.signOut();
    emit(AuthUnauthenticated());
  }
}

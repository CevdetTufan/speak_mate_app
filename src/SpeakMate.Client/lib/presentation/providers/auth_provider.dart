import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/repositories/grpc_auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return GrpcAuthRepository();
});

class AuthNotifier extends StateNotifier<bool> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(false) {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    state = await _repository.isLoggedIn();
  }

  Future<bool> login(String username, String password) async {
    final success = await _repository.login(username, password);
    if (success) {
      state = true;
    }
    return success;
  }

  Future<bool> register(String username, String password) async {
    final success = await _repository.register(username, password);
    if (success) {
      state = true;
    }
    return success;
  }

  Future<void> logout() async {
    await _repository.logout();
    state = false;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

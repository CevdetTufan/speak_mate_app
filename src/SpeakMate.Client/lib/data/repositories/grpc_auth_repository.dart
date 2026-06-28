import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../services/generated/auth.pbgrpc.dart';

class GrpcAuthRepository implements AuthRepository {
  late ClientChannel _channel;
  late AuthServiceClient _stub;

  GrpcAuthRepository() {
    _channel = ClientChannel(
      'localhost',
      port: 5001,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _stub = AuthServiceClient(_channel);
  }

  @override
  Future<bool> login(String username, String password) async {
    try {
      final response = await _stub.login(LoginRequest(username: username, password: password));
      if (response.success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.token);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> register(String username, String password) async {
    try {
      final response = await _stub.register(RegisterRequest(username: username, password: password));
      if (response.success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', response.token);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  @override
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }
}

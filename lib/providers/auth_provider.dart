import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task/core/network/dio_client.dart';

final authNotifierProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<bool> {
  final Ref ref;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthNotifier(this.ref) : super(false) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await storage.read(key: 'jwt_token');
    state = token != null && token.isNotEmpty;
  }

  Future<void> login(String email, String password) async {
    final api = ref.read(apiServiceProvider);
    final token = await api.login(email, password);
    await storage.write(key: 'jwt_token', value: token);
    state = true;
  }

  Future<void> logout() async {
    await storage.delete(key: 'jwt_token');
    state = false;
  }
}

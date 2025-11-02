import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:task/services/auth_services.dart';

final authRepositoryProvider = Provider((ref) => AuthServices());

final loginProvider = StateNotifierProvider<LoginNotifier, AsyncValue<void>>((
  ref,
) {
  return LoginNotifier(ref.watch(authRepositoryProvider));
});

class LoginNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthServices _repo;
  LoginNotifier(this._repo) : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _repo.login(email, password);
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

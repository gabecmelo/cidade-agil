import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_errors.dart';
import '../../../core/storage/auth_storage.dart';
import '../data/auth_models.dart';
import '../data/auth_repository.dart';

sealed class AuthState {}
class AuthUnauthenticated extends AuthState {}
class AuthAuthenticated extends AuthState {
  AuthAuthenticated(this.usuario);
  final MeResponseDto usuario;
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final token = await AuthStorage.instance.readToken();
    if (token == null) return AuthUnauthenticated();
    try {
      final me = await AuthRepository.instance.me();
      return AuthAuthenticated(me);
    } catch (_) {
      await AuthStorage.instance.clear();
      return AuthUnauthenticated();
    }
  }

  Future<void> login(String email, String senha) async {
    state = const AsyncLoading();
    try {
      final res = await AuthRepository.instance.login(
        LoginRequestDto(email: email, senha: senha),
      );
      // Bloquear gestor/técnico no app mobile
      if (res.tipoUsuario != 'CIDADAO') {
        state = AsyncError(
          const AppError(
            code: 'tipo_invalido',
            message: 'Use o painel web para acessar como gestor ou técnico.',
          ),
          StackTrace.current,
        );
        return;
      }
      await AuthStorage.instance.save(
        token: res.token,
        tipoUsuario: res.tipoUsuario,
      );
      final me = await AuthRepository.instance.me();
      state = AsyncData(AuthAuthenticated(me));
    } on AppError catch (e, st) {
      state = AsyncError(e, st);
    } catch (e, st) {
      state = AsyncError(AppError.unknown(), st);
    }
  }

  Future<void> logout() async {
    await AuthRepository.instance.logout();
    state = AsyncData(AuthUnauthenticated());
  }

  void invalidate() {
    state = AsyncData(AuthUnauthenticated());
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

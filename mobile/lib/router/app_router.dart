import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/ocorrencias/presentation/lista_screen.dart';
import '../features/ocorrencias/presentation/registrar_screen.dart';
import '../features/ocorrencias/presentation/registrar_sucesso_screen.dart';
import '../features/ocorrencias/presentation/detalhe_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    refreshListenable: _AuthListenable(ref),
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuthenticated = switch (authState) {
        AsyncData(value: AuthAuthenticated()) => true,
        _ => false,
      };
      final loc = state.matchedLocation;
      final isOnAuth = loc == '/login' || loc == '/signup';

      if (!isAuthenticated && !isOnAuth) return '/login';
      if (isAuthenticated && isOnAuth) return '/lista';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
      GoRoute(path: '/lista', builder: (context, state) => const ListaScreen()),
      GoRoute(
        path: '/registrar',
        builder: (context, state) => const RegistrarScreen(),
        routes: [
          GoRoute(
            path: 'sucesso/:protocolo',
            builder: (context, state) => RegistrarSucessoScreen(
              protocolo: state.pathParameters['protocolo']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/detalhe/:id',
        builder: (context, state) => DetalheScreen(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
    ],
    initialLocation: '/lista',
  );
});

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen(authProvider, (previous, next) => notifyListeners());
  }
}

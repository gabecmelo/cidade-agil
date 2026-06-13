import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/api/dio_client.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'router/app_router.dart';

void main() {
  DioClient.init();
  runApp(const ProviderScope(child: CidadeAgilApp()));
}

class CidadeAgilApp extends ConsumerWidget {
  const CidadeAgilApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Registrar callback de 401 após o ProviderScope estar disponível
    DioClient.instance.registerOnUnauthorized(() {
      ref.read(authProvider.notifier).invalidate();
    });

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Cidade Ágil',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}

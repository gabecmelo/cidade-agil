import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/api_errors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/error_alert.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  bool _senhaVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _errorMessage = null);
    await ref.read(authProvider.notifier).login(_emailCtrl.text.trim(), _senhaCtrl.text);
    if (!mounted) return;
    final state = ref.read(authProvider);
    if (state is AsyncError) {
      final err = state.error;
      setState(() {
        _errorMessage = err is AppError ? err.message : 'E-mail ou senha inválidos.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              // Logo
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                        ),
                      ),
                      child: const Icon(Icons.domain, size: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Cidade Ágil',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Denúncias de manutenção urbana',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              if (_errorMessage != null) ...[
                ErrorAlert(message: _errorMessage!),
                const SizedBox(height: 16),
              ],
              // Campo E-mail
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.mail_outline),
                  hintText: 'seu@email.com',
                ),
              ),
              const SizedBox(height: 12),
              // Campo Senha
              TextFormField(
                controller: _senhaCtrl,
                obscureText: !_senhaVisible,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _login(),
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: '••••••••',
                  suffixIcon: IconButton(
                    icon: Icon(_senhaVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _senhaVisible = !_senhaVisible),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: null,
                  child: Text(
                    'Esqueci a senha',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF1E3A8A),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(label: 'Entrar', onPressed: _login, loading: isLoading),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Não tem conta? ', style: Theme.of(context).textTheme.bodySmall),
                  TextButton(
                    onPressed: () => context.push('/signup'),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                    child: const Text('Criar conta', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

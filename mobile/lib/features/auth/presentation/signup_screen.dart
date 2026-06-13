import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/api_errors.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/error_alert.dart';
import '../data/auth_repository.dart';
import '../data/auth_models.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  bool _senhaVisible = false;
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    setState(() { _loading = true; _errorMessage = null; });
    try {
      await AuthRepository.instance.signup(
        SignupRequestDto(
          nome: _nomeCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          senha: _senhaCtrl.text,
        ),
      );
      // Após 201, faz login direto para bloquear enumeração de e-mail
      await ref.read(authProvider.notifier).login(
        _emailCtrl.text.trim(),
        _senhaCtrl.text,
      );
      if (!mounted) return;
      // Se login retornar erro (ex: 401 anti-enumeração), vai silenciosamente para login
      final authState = ref.read(authProvider);
      if (authState is AsyncError) {
        context.go('/login');
      }
      // Se autenticado o redirect do GoRouter já leva para /lista
    } on AppError catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (_) {
      setState(() => _errorMessage = 'Ocorreu um erro. Tente novamente.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Criar conta'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              if (_errorMessage != null) ...[
                ErrorAlert(message: _errorMessage!),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _nomeCtrl,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'Seu nome',
                ),
              ),
              const SizedBox(height: 12),
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
              TextFormField(
                controller: _senhaCtrl,
                obscureText: !_senhaVisible,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _signup(),
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: 'Mínimo 6 caracteres',
                  suffixIcon: IconButton(
                    icon: Icon(_senhaVisible ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _senhaVisible = !_senhaVisible),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(label: 'Criar conta', onPressed: _signup, loading: _loading),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Já tem conta? ', style: Theme.of(context).textTheme.bodySmall),
                  TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                    child: const Text('Entrar', style: TextStyle(fontWeight: FontWeight.w700)),
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

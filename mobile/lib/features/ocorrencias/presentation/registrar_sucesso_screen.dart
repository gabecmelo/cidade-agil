import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/widgets/app_buttons.dart';

class RegistrarSucessoScreen extends StatelessWidget {
  const RegistrarSucessoScreen({super.key, required this.protocolo});

  final String protocolo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Symbols.check_circle, size: 36, color: Color(0xFF16A34A)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Recebido!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF0E1726)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sua denúncia foi registrada com sucesso.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF384151)),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'PROTOCOLO',
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600,
                          letterSpacing: 0.08, color: Color(0xFF6B7383),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '#$protocolo',
                        style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.w800,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Acompanhe o andamento em\n"Minhas ocorrências"',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFF6B7383)),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Ver minhas ocorrências',
                  onPressed: () => context.go('/lista'),
                ),
                const SizedBox(height: 12),
                GhostButton(
                  label: 'Registrar outra',
                  onPressed: () => context.go('/registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

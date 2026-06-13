import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/utils/relative_date.dart';
import '../../../core/widgets/status_badge.dart';
import '../data/ocorrencia_models.dart';
import '../providers/ocorrencias_provider.dart';

class ListaScreen extends ConsumerWidget {
  const ListaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ocorrenciasListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas ocorrências'),
        actions: [
          IconButton(
            icon: const Icon(Symbols.tune),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Filtros em breve.')),
            ),
          ),
        ],
      ),
      body: state.when(
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Carregando ocorrências…', style: TextStyle(color: Color(0xFF6B7383))),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Symbols.error_outline, size: 48, color: Color(0xFFB91C1C)),
              const SizedBox(height: 16),
              const Text('Não foi possível carregar.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.read(ocorrenciasListProvider.notifier).refresh(),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
        data: (lista) => lista.isEmpty
            ? _EmptyState(onRegistrar: () => context.push('/registrar'))
            : RefreshIndicator(
                onRefresh: () => ref.read(ocorrenciasListProvider.notifier).refresh(),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemCount: lista.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, i) => _OcorrenciaCard(
                    item: lista[i],
                    onTap: () => context.push('/detalhe/${lista[i].id}'),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/registrar'),
        child: const Icon(Symbols.add),
      ),
      bottomNavigationBar: buildBottomNav(context),
    );
  }
}

class _OcorrenciaCard extends StatelessWidget {
  const _OcorrenciaCard({required this.item, required this.onTap});

  final OcorrenciaListItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEEF1F5)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F0B1E45),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Thumb(categoria: item.categoria),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${item.id} · ${item.categoria.label}',
                    style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF0E1726),
                    ),
                  ),
                  const SizedBox(height: 4),
                  StatusBadge(status: item.status),
                  const SizedBox(height: 6),
                  Text(
                    '${relativeDatePt(item.criadoEm)}${item.enderecoDisplay.isNotEmpty ? ' · ${item.enderecoDisplay}' : ''}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7383)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFFCBD2DC)),
          ],
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.categoria});
  final CategoriaDart categoria;

  @override
  Widget build(BuildContext context) {
    final colors = switch (categoria) {
      CategoriaDart.BURACO => const [Color(0xFF8B7355), Color(0xFFA0926B)],
      CategoriaDart.ILUMINACAO => const [Color(0xFF4A6741), Color(0xFF6B8F5E)],
      CategoriaDart.CALCADA => const [Color(0xFF5A6978), Color(0xFF7E8D9B)],
      CategoriaDart.ALAGAMENTO => const [Color(0xFF4A6078), Color(0xFF6888A0)],
      CategoriaDart.VANDALISMO => const [Color(0xFF6B4A78), Color(0xFF9468A0)],
      CategoriaDart.OUTRO => const [Color(0xFF6B6B6B), Color(0xFF9A9A9A)],
    };

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Icon(categoria.icon, size: 28, color: Colors.white.withValues(alpha: 0.8)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRegistrar});
  final VoidCallback onRegistrar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FB),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(Symbols.inbox, size: 40, color: Color(0xFF2A4DBA)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhuma ocorrência',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0E1726)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Você ainda não registrou nenhuma denúncia. Viu um problema na cidade?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7383), height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onRegistrar,
                icon: const Icon(Symbols.add),
                label: const Text('Registrar a primeira ocorrência'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildBottomNav(BuildContext context) {
  return BottomNavigationBar(
    currentIndex: 0,
    onTap: (i) {
      if (i != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Em breve.')),
        );
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Symbols.list_alt), label: 'Minhas'),
      BottomNavigationBarItem(icon: Icon(Symbols.map), label: 'Mapa'),
      BottomNavigationBarItem(icon: Icon(Symbols.person), label: 'Perfil'),
    ],
    selectedItemColor: Color(0xFF1E3A8A),
    unselectedItemColor: Color(0xFF6B7383),
    backgroundColor: Colors.white,
    elevation: 8,
  );
}

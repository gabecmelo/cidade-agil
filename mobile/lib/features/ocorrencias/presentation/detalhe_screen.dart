import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../../core/api/api_errors.dart';
import '../../../core/utils/relative_date.dart';
import '../../../core/widgets/category_chip.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/theme/app_theme.dart';
import '../data/ocorrencia_models.dart';
import '../data/ocorrencia_repository.dart';
import '../providers/ocorrencias_provider.dart';

class DetalheScreen extends ConsumerWidget {
  const DetalheScreen({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ocorrenciaDetalheProvider(id));

    return state.when(
      loading: () => Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: Center(child: Text(e is AppError ? e.message : 'Erro ao carregar.')),
      ),
      data: (ocorrencia) => _DetalheContent(ocorrencia: ocorrencia, ref: ref),
    );
  }
}

class _DetalheContent extends StatefulWidget {
  const _DetalheContent({required this.ocorrencia, required this.ref});

  final OcorrenciaDetalhe ocorrencia;
  final WidgetRef ref;

  @override
  State<_DetalheContent> createState() => _DetalheContentState();
}

class _DetalheContentState extends State<_DetalheContent> {
  int _nota = 0;
  final _comentarioCtrl = TextEditingController();
  bool _loadingAvaliacao = false;
  bool _avaliacaoEnviada = false;

  OcorrenciaDetalhe get ocorrencia => widget.ocorrencia;

  @override
  void dispose() {
    _comentarioCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviarAvaliacao() async {
    if (_nota == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma nota de 1 a 5.')),
      );
      return;
    }
    setState(() => _loadingAvaliacao = true);
    try {
      await OcorrenciaRepository.instance.avaliar(
        ocorrencia.id,
        AvaliacaoRequest(nota: _nota, comentario: _comentarioCtrl.text),
      );
      widget.ref.invalidate(ocorrenciaDetalheProvider(ocorrencia.id));
      widget.ref.invalidate(ocorrenciasListProvider);
      if (!mounted) return;
      setState(() => _avaliacaoEnviada = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avaliação enviada. Obrigado!')),
      );
    } on AppError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _loadingAvaliacao = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCoords = ocorrencia.locLatitude != null && ocorrencia.locLongitude != null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero foto
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            leading: IconButton(
              icon: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF5A6978), Color(0xFFA0ADB8)],
                  ),
                ),
                child: const Center(
                  child: Icon(Symbols.image, size: 64, color: Colors.white38),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Linha status + categoria + protocolo
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    StatusBadge(status: ocorrencia.status),
                    CategoryChipSmall(categoria: ocorrencia.categoria),
                    const Spacer(),
                    Text(
                      '#${ocorrencia.id}',
                      style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7383), fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Descrição
                Text(
                  ocorrencia.descricao,
                  style: const TextStyle(fontSize: 15, height: 1.5, color: Color(0xFF384151)),
                ),
                // Mini-mapa
                if (hasCoords) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            ocorrencia.locLatitude!,
                            ocorrencia.locLongitude!,
                          ),
                          initialZoom: 16,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.gabecmelo.cidade_agil',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(
                                  ocorrencia.locLatitude!,
                                  ocorrencia.locLongitude!,
                                ),
                                child: const Icon(
                                  Symbols.location_on,
                                  size: 36,
                                  color: Color(0xFFB91C1C),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (ocorrencia.enderecoDisplay.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        ocorrencia.enderecoDisplay,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF6B7383)),
                      ),
                    ),
                ],
                const SizedBox(height: 20),
                // Overline Histórico
                const Text(
                  'HISTÓRICO',
                  style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w600,
                    letterSpacing: 0.08, color: Color(0xFF6B7383),
                  ),
                ),
                const SizedBox(height: 12),
                _TimelineList(historico: ocorrencia.historico),
                // Card de avaliação
                if (ocorrencia.podeAvaliar && !_avaliacaoEnviada) ...[
                  const SizedBox(height: 20),
                  _AvaliacaoCard(
                    nota: _nota,
                    comentarioCtrl: _comentarioCtrl,
                    loading: _loadingAvaliacao,
                    onNotaChanged: (n) => setState(() => _nota = n),
                    onEnviar: _enviarAvaliacao,
                  ),
                ],
                const SizedBox(height: 32),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineList extends StatelessWidget {
  const _TimelineList({required this.historico});
  final List<HistoricoEvento> historico;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(historico.length, (i) {
        final ev = historico[i];
        final isLast = i == historico.length - 1;
        final isDone = !isLast;
        final isCurrent = isLast;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                child: Column(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCurrent
                            ? const Color(0xFF16A34A)
                            : isDone
                                ? AppTheme.primary
                                : const Color(0xFFCBD2DC),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF16A34A).withValues(alpha: 0.4),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: const Color(0xFFCBD2DC),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ev.para.label,
                        style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0E1726),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${formatDateTimePt(ev.dataHora)}${ev.responsavelNome != null ? ' · ${ev.responsavelNome}' : ''}',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF6B7383), height: 1.4),
                      ),
                      if (ev.observacao != null && ev.observacao!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8FB),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            ev.observacao!,
                            style: const TextStyle(fontSize: 12, height: 1.3, color: Color(0xFF384151)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _AvaliacaoCard extends StatelessWidget {
  const _AvaliacaoCard({
    required this.nota,
    required this.comentarioCtrl,
    required this.loading,
    required this.onNotaChanged,
    required this.onEnviar,
  });

  final int nota;
  final TextEditingController comentarioCtrl;
  final bool loading;
  final ValueChanged<int> onNotaChanged;
  final VoidCallback onEnviar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCE5F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Como foi o atendimento?',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF0E1726)),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (i) {
              final starIndex = i + 1;
              return GestureDetector(
                onTap: () => onNotaChanged(starIndex),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    nota >= starIndex ? Symbols.star : Symbols.star,
                    size: 28,
                    color: nota >= starIndex ? const Color(0xFFF59E0B) : const Color(0xFFCBD2DC),
                    fill: nota >= starIndex ? 1 : 0,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: comentarioCtrl,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'Comentário (opcional)',
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: loading ? null : onEnviar,
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              child: loading
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Enviar avaliação'),
            ),
          ),
        ],
      ),
    );
  }
}

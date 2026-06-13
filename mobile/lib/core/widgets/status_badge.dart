import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/app_theme.dart';
import '../../features/ocorrencias/data/ocorrencia_models.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final StatusOcorrenciaDart status;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    final (fg, bg, icon, label) = switch (status) {
      StatusOcorrenciaDart.RECEBIDA => (
          colors.statusRecebidaFg,
          colors.statusRecebidaBg,
          Symbols.mark_email_unread,
          'Recebida',
        ),
      StatusOcorrenciaDart.EM_ANALISE => (
          colors.statusAnalFg,
          colors.statusAnalBg,
          Symbols.search,
          'Em análise',
        ),
      StatusOcorrenciaDart.EM_ATENDIMENTO => (
          colors.statusAtendFg,
          colors.statusAtendBg,
          Symbols.construction,
          'Em atendimento',
        ),
      StatusOcorrenciaDart.RESOLVIDA => (
          colors.statusResolFg,
          colors.statusResolBg,
          Symbols.task_alt,
          'Resolvida',
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

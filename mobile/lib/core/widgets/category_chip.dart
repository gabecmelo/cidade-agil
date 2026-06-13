import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../../features/ocorrencias/data/ocorrencia_models.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.categoria,
    required this.selected,
    required this.onTap,
  });

  final CategoriaDart categoria;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selected;
    final label = categoria.label;
    final icon = categoria.icon;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primary : const Color(0xFFCBD2DC),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : AppTheme.primary,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF384151),
                height: 1.1,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Chip menor para uso no detalhe da ocorrência
class CategoryChipSmall extends StatelessWidget {
  const CategoryChipSmall({super.key, required this.categoria});

  final CategoriaDart categoria;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.primary50,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(categoria.icon, size: 14, color: AppTheme.primary),
          const SizedBox(width: 5),
          Text(
            categoria.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

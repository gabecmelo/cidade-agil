import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ErrorAlert extends StatelessWidget {
  const ErrorAlert({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Symbols.error, size: 18, color: Color(0xFFB91C1C)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFFB91C1C),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

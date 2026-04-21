import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ToggleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool active;
  final VoidCallback onTap;

  const ToggleChip({super.key, required this.label, required this.icon,
    required this.color, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: active ? color : AppTheme.cardBorder),
        borderRadius: BorderRadius.circular(20),
        color: active ? color.withOpacity(0.10) : Colors.white,
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: active ? color : AppTheme.textHint),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(
          fontSize: 13, color: active ? color : AppTheme.textHint,
          fontWeight: FontWeight.w500)),
      ]),
    ),
  );
}
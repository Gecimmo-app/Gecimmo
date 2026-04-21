import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  final bool small;

  const AppBadge({super.key, required this.label, required this.color, this.icon, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 8 : 12, vertical: small ? 3 : 6),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(small ? 12 : 20),
        color: color.withOpacity(0.08),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: small ? 12 : 14, color: color), SizedBox(width: 4)],
          Text(label, style: TextStyle(fontSize: small ? 11 : 13, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
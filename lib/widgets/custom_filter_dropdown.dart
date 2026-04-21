import 'package:flutter/material.dart';

class CustomFilterDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? icon;
  final List<String>? items;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final bool isEnabled;

  const CustomFilterDropdown({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.items,
    this.value,
    this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade800,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500, size: 20),
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 13,
              color: isEnabled ? Colors.grey.shade500 : Colors.grey.shade400,
            ),
            prefixIcon: icon != null 
                ? Icon(icon, size: 18, color: Colors.grey.shade400)
                : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14, 
              vertical: icon != null ? 12 : 14
            ),
            filled: true,
            fillColor: isEnabled ? Colors.white : Colors.grey.shade50,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1E40AF)),
            ),
          ),
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          items: items?.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: isEnabled ? onChanged : null,
        ),
      ],
    );
  }
}

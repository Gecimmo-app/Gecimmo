import 'package:flutter/material.dart';

class SolidBlueButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const SolidBlueButton({
    super.key, 
    required this.label, 
    required this.icon, 
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(
        label, 
        style: const TextStyle(
          fontSize: 15, 
          fontWeight: FontWeight.w700, 
          color: Colors.white,
        )
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: const Color(0xFF1E40AF).withOpacity(0.4), // Ombre douce (Soft UI)
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class FintechGradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const FintechGradientButton({
    super.key, 
    required this.label, 
    required this.icon, 
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)], // Deep blue to vibrant blue
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E40AF).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(
          label, 
          style: const TextStyle(
            fontSize: 14, 
            fontWeight: FontWeight.w700, 
            color: Colors.white,
          )
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class SafeDropdownTile extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final List<String>? items;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final bool isEnabled;

  const SafeDropdownTile({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.items,
    this.value,
    this.onChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12), // Radius 12 comme demandé
          border: Border.all(color: Colors.grey.shade200, width: 1), // Bordure fine grey[200]
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: const Color(0xFF1E40AF)), // Icône à gauche
            const SizedBox(width: 16),
            Expanded( // Protège contre RenderFlex overflow horizontal !
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true, 
                  isDense: false, // Résout le "Bottom Overflow" !
                  itemHeight: 58, // Hauteur suffisante pour la colonne
                  icon: const Icon(Icons.unfold_more_rounded, color: Colors.black38),
                  value: value,
                  hint: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey.shade800)),
                      const SizedBox(height: 2),
                      Text(
                        hint, 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis, 
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade500)
                      ),
                    ],
                  ),
                  selectedItemBuilder: (context) {
                    return items?.map((item) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                          const SizedBox(height: 2),
                          Text(
                            item, 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis, 
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)
                          ),
                        ],
                      );
                    }).toList() ?? [];
                  },
                  items: items?.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item, 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis, 
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)
                      ),
                    );
                  }).toList(),
                  onChanged: isEnabled ? onChanged : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FastFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData? icon;
  final VoidCallback onTap;

  const FastFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        selected: isSelected,
        onSelected: (_) => onTap(),
        label: Text(label),
        labelStyle: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? Colors.white : Colors.blueGrey.shade700,
          fontSize: 13,
        ),
        avatar: icon != null 
          ? Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.blueGrey.shade400)
          : null,
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF1E40AF),
        elevation: 0,
        pressElevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}

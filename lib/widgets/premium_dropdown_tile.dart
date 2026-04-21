import 'package:flutter/material.dart';

class PremiumDropdownTile extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final List<String>? items;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final bool isEnabled;

  const PremiumDropdownTile({
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
    final bool hasValue = value != null;
    
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: hasValue ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasValue ? const Color(0xFF1E40AF).withOpacity(0.4) : Colors.grey.shade200,
            width: 1.2,
          ),
          boxShadow: hasValue ? [] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Theme(
          // Removes default splash/highlight
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              icon: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.unfold_more_rounded, 
                  color: hasValue ? const Color(0xFF1E40AF) : Colors.grey.shade400,
                  size: 22,
                ),
              ),
              value: value,
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(16),
              // Custom Widget layout when NOTHING is selected
              hint: Padding(
                padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200, width: 1),
                      ),
                      child: Icon(icon, size: 20, color: Colors.blueGrey.shade400),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade800)),
                          const SizedBox(height: 2),
                          Text(hint, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Custom Widget layout when an item IS selected
              selectedItemBuilder: (BuildContext context) {
                return items?.map<Widget>((String item) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E40AF),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1E40AF).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          ),
                          child: Icon(icon, size: 20, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Sélection active", style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF), fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(item, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList() ?? [];
              },
              // The dropdown list values
              items: items?.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      item, 
                      style: TextStyle(
                        fontSize: 14, 
                        fontWeight: FontWeight.w600, 
                        color: value == item ? const Color(0xFF1E40AF) : const Color(0xFF1E293B)
                      )
                    ),
                  ),
                );
              }).toList(),
              onChanged: isEnabled ? onChanged : null,
            ),
          ),
        ),
      ),
    );
  }
}

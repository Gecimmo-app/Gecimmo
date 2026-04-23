import 'package:flutter/material.dart';
import '../../../widgets/Ajouter_visite.dart';

class Prestataire {
  final String nom;
  final String email;
  List<String> projetsAttribues;

  Prestataire({
    required this.nom,
    required this.email,
    required this.projetsAttribues,
  });
}

class EmailsPrestScreen extends StatefulWidget {
  const EmailsPrestScreen({Key? key}) : super(key: key);

  @override
  State<EmailsPrestScreen> createState() => _EmailsPrestScreenState();
}

class _EmailsPrestScreenState extends State<EmailsPrestScreen> {
  final List<Prestataire> _prestataires = [
    Prestataire(
      nom: 'Prestataire 1',
      email: 'nextorchq@gmail.com',
      projetsAttribues: ['Projet1', 'Projet2', 'Projet3', 'Projet4', 'Projet5', 'Projet6', 'Projet7', 'Projet12', 'Projet13'],
    ),
    Prestataire(
      nom: 'test',
      email: 'test@gmail.com',
      projetsAttribues: [],
    ),
  ];

  final List<String> _tousLesProjets = [
    'Projet1', 'Projet2', 'Projet3', 'Projet4', 'Projet5', 'Projet6', 'Projet7', 'Projet8', 'Projet9', 'Projet10', 'Projet11', 'Projet12', 'Projet13'
  ];

  void _showProjectSelect(Prestataire prestataire, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _MultiSelectSheet(
          title: 'Sélectionner des projets',
          options: _tousLesProjets,
          initialSelection: List.from(prestataire.projetsAttribues),
          onApply: (selected) {
            setState(() {
              _prestataires[index].projetsAttribues = selected;
            });
          },
        );
      },
    );
  }

  void _enregistrer(Prestataire p) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Projets enregistrés pour ${p.nom}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFEFF6FF);
    const Color textDark = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: bgColor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddVisitFlow()),
            );
          },
          backgroundColor: const Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          elevation: 6,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Paramétrage des prestataires',
                style: TextStyle(
                  color: textDark,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 32),
              ..._prestataires.asMap().entries.map((entry) {
                final index = entry.key;
                final p = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            p.nom,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            p.email,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF94A3B8), // Muted text
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Projets attribués',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Input transformé en select (Bottom Sheet Multi-select)
                      GestureDetector(
                        onTap: () => _showProjectSelect(p, index),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                          ),
                          child: Text(
                            p.projetsAttribues.isEmpty
                                ? 'Aucun projet attribué'
                                : p.projetsAttribues.join(', '),
                            style: TextStyle(
                              fontSize: 14,
                              color: p.projetsAttribues.isEmpty
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF475569),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () => _enregistrer(p),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E40AF), // primaryBlue
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Enregistrer',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _MultiSelectSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> initialSelection;
  final Function(List<String>) onApply;

  const _MultiSelectSheet({
    required this.title,
    required this.options,
    required this.initialSelection,
    required this.onApply,
  });

  @override
  State<_MultiSelectSheet> createState() => _MultiSelectSheetState();
}

class _MultiSelectSheetState extends State<_MultiSelectSheet> {
  late List<String> _tempSelected;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.initialSelection);
  }

  List<String> get _filteredOptions {
    if (_searchQuery.isEmpty) return widget.options;
    return widget.options.where((o) => o.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1E40AF);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _tempSelected.clear();
                  });
                },
                child: const Text('Vider', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Barre de recherche
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: const InputDecoration(
                hintText: 'Rechercher un projet...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                hintStyle: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _filteredOptions.isEmpty
                ? const Center(child: Text("Aucun projet trouvé", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: _filteredOptions.length,
                    itemBuilder: (context, index) {
                      final option = _filteredOptions[index];
                      final isSelected = _tempSelected.contains(option);
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFF1F5F9) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CheckboxListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          title: Text(
                            option,
                            style: TextStyle(
                              color: isSelected ? primaryBlue : const Color(0xFF334155),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                          value: isSelected,
                          activeColor: primaryBlue,
                          controlAffinity: ListTileControlAffinity.leading,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          onChanged: (bool? checked) {
                            setState(() {
                              if (checked == true) {
                                _tempSelected.add(option);
                              } else {
                                _tempSelected.remove(option);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_tempSelected);
                Navigator.pop(context); // Fermer le popup
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Appliquer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../widgets/Ajouter_visite.dart';

class EmailsParEtapeScreen extends StatefulWidget {
  const EmailsParEtapeScreen({Key? key}) : super(key: key);

  @override
  _EmailsParEtapeScreenState createState() => _EmailsParEtapeScreenState();
}

class _EmailsParEtapeScreenState extends State<EmailsParEtapeScreen> {
  String _selectedProjet = 'Sélectionner un projet';
  String _selectedTypeVisite = 'Sélectionner un type';
  
  final List<String> _projets = [
    'Sélectionner un projet',
    'Tous les projets',
    'Projet7',
    'Projet8',
    'Projet9',
  ];

  final List<String> _typesVisites = [
    'Sélectionner un type',
    'Tous les types de visite',
    'Réclamation',
    'Réception Technique',
    'Livraison Technique',
    'Livraison Client',
    'Livraison Syndic',
  ];

  final List<String> _etapes = [
    'Creation',
    'Planification',
    'Réalisation',
    'Refus',
    'Acceptation',
  ];

  late Map<String, List<String>> _etapeEmails;

  @override
  void initState() {
    super.initState();
    _etapeEmails = {};
    for (String etape in _etapes) {
      _etapeEmails[etape] = [];
    }
  }

  void _addEmail(String etape, String email) {
    if (email.trim().isEmpty) return;
    
    // Validation basique
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email invalide')),
      );
      return;
    }

    setState(() {
      if (!_etapeEmails[etape]!.contains(email.trim())) {
        _etapeEmails[etape]!.add(email.trim());
      }
    });
  }

  void _removeEmail(String etape, String email) {
    setState(() {
      _etapeEmails[etape]!.remove(email);
    });
  }

  void _sauvegarder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuration sauvegardée avec succès !')),
    );
  }

  void _showFilterSheet(
    BuildContext context,
    String title,
    List<String> options,
    String? currentValue,
    Function(String) onSelected, {
    bool showSearch = true,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _FilterSheetContent(
          title: title,
          options: options,
          currentValue: currentValue,
          onSelected: onSelected,
          showSearch: showSearch,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1E40AF);
    const Color bgColor = Color(0xFFEFF6FF); // Background comme Dashbordprincpa
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
              // Titre de la page
              const Text(
                'Configuration des emails de notification par Étape',
                style: TextStyle(
                  color: textDark,
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 24),

              // Section Selects (Façon Dashboard)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      icon: Icons.folder_outlined,
                      label: _selectedProjet == 'Sélectionner un projet' ? 'Projet' : 'Projet : $_selectedProjet',
                      onTap: () => _showFilterSheet(
                        context,
                        'Projets',
                        _projets,
                        _selectedProjet,
                        (value) => setState(() => _selectedProjet = value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      icon: Icons.category_outlined,
                      label: _selectedTypeVisite == 'Sélectionner un type' ? 'Type' : 'Type: $_selectedTypeVisite',
                      onTap: () => _showFilterSheet(
                        context,
                        'Type de visite',
                        _typesVisites,
                        _selectedTypeVisite,
                        (value) => setState(() => _selectedTypeVisite = value),
                        showSearch: false,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Tableau ou Message d'attente
              if (_selectedProjet == 'Sélectionner un projet' || _selectedTypeVisite == 'Sélectionner un type')
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Veuillez sélectionner un projet et un type de visite pour commencer',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else
                Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 1)),
                  ],
                ),
                child: Column(
                  children: [
                    // En-tête du tableau
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF9FAFB),
                        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              flex: 1, // 1/3
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                decoration: const BoxDecoration(
                                  border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
                                ),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Étape',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2, // 2/3
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Emails de notification',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Lignes du tableau
                    ..._etapes.map((etape) {
                      final isLast = _etapes.last == etape;
                      return Container(
                        decoration: BoxDecoration(
                          border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 1, // 1/3
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  decoration: const BoxDecoration(
                                    border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    etape,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF4B5563),
                                    ),
                                    overflow: TextOverflow.visible, 
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2, // 2/3
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  alignment: Alignment.centerLeft,
                                  child: _EmailInputWidget(
                                    emails: _etapeEmails[etape] ?? [],
                                    onEmailAdded: (email) => _addEmail(etape, email),
                                    onEmailRemoved: (email) => _removeEmail(etape, email),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Bouton Sauvegarder (comme Emails.dart)
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: (_selectedProjet != 'Sélectionner un projet' && _selectedTypeVisite != 'Sélectionner un type') 
                      ? _sauvegarder 
                      : null, // Pas clickable
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    disabledBackgroundColor: const Color(0xFF93C5FD), // Bleu pâle/faded (bahtaa)
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white.withOpacity(0.9), // Maintient le texte blanc
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4), // Bouton plus carré
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Sauvegarder',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              const SizedBox(height: 24), 
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CHIPS DES SELECTS COMMME DASHBOARD
// ─────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 1)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BOTTOM SHEET CONTENT POUR LES SELECTS
// ─────────────────────────────────────────────
class _FilterSheetContent extends StatefulWidget {
  final String title;
  final List<String> options;
  final String? currentValue;
  final Function(String) onSelected;
  final bool showSearch;

  const _FilterSheetContent({
    required this.title,
    required this.options,
    required this.currentValue,
    required this.onSelected,
    this.showSearch = true,
  });

  @override
  State<_FilterSheetContent> createState() => _FilterSheetContentState();
}

class _FilterSheetContentState extends State<_FilterSheetContent> {
  String _searchQuery = '';
  
  List<String> get _filteredOptions {
    if (_searchQuery.isEmpty) return widget.options;
    return widget.options.where((option) {
      return option.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
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
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          if (widget.showSearch) ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Rechercher...',
                  prefixIcon: Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (_filteredOptions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Aucun résultat trouvé', style: TextStyle(color: Color(0xFF64748B))),
              ),
            ),
          if (_filteredOptions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = _filteredOptions[index];
                  final isSelected = option == widget.currentValue;
                  return Container(
                    color: isSelected ? const Color(0xFFF1F5F9) : Colors.transparent,
                    child: CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: primaryBlue,
                      value: isSelected,
                      title: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      onChanged: (bool? checked) {
                        widget.onSelected(option);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WIDGET DES INPUTS MULTIPLES EMAILS
// ─────────────────────────────────────────────
class _EmailInputWidget extends StatefulWidget {
  final List<String> emails;
  final Function(String) onEmailAdded;
  final Function(String) onEmailRemoved;

  const _EmailInputWidget({
    Key? key,
    required this.emails,
    required this.onEmailAdded,
    required this.onEmailRemoved,
  }) : super(key: key);

  @override
  _EmailInputWidgetState createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<_EmailInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _processInput(String value) {
    if (value.trim().isEmpty) {
      _controller.clear();
      return;
    }
    
    // Split by semicolons, commas, or spaces
    final parsedEmails = value.split(RegExp(r'[;,;\s]')).map((e) => e.trim()).where((e) => e.isNotEmpty);
    for (final email in parsedEmails) {
      widget.onEmailAdded(email);
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.emails.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.emails.map((email) {
              return Chip(
                label: Text(
                  email,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1E40AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: const Color(0xFFEFF6FF),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 16,
                  color: Color(0xFF1E40AF),
                ),
                onDeleted: () => widget.onEmailRemoved(email),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0xFFBFDBFE)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: (value) {
            // Trigger addition if user types a space or semicolon
            if (value.endsWith(' ') || value.endsWith(';') || value.endsWith(',')) {
              _processInput(value);
            }
          },
          onSubmitted: _processInput,
          decoration: InputDecoration(
            hintText: 'Ajouter un email et appuyer sur Entrée, \';\' ou Espace',
            hintStyle: const TextStyle(
              fontSize: 13,
              color: Color(0xFF9CA3AF),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF3B82F6)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}

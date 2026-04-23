import 'package:flutter/material.dart';
import '../widgets/Dashboard/Dashbordprincpa.dart';
import '../widgets/Ajouter_visite.dart';
import 'dart:math' as math;

class ProjectConfig {
  final String typeVisite;
  final String projectName;
  final List<String> emails;

  ProjectConfig({
    required this.typeVisite,
    required this.projectName,
    required this.emails,
  });
}

class EmailsConfigScreen extends StatefulWidget {
  const EmailsConfigScreen({Key? key}) : super(key: key);

  @override
  _EmailsConfigScreenState createState() => _EmailsConfigScreenState();
}

class _EmailsConfigScreenState extends State<EmailsConfigScreen> {
  String _selectedTypeVisite = 'Réception Technique';
  final List<String> _typesVisites = [
    'Sélectionner',
    'Réception Technique',
    'Livraison Technique',
    'Livraison Client',
    'Livraison Syndic',
    'Réclamation'
  ];

  late List<ProjectConfig> _allConfigs;
  late List<ProjectConfig> _filteredConfigs;

  int _currentPage = 1;
  final int _itemsPerPage = 10;

  int get _totalPages {
    if (_filteredConfigs.isEmpty) return 1;
    return (_filteredConfigs.length + _itemsPerPage - 1) ~/ _itemsPerPage;
  }

  List<ProjectConfig> get _paginatedConfigs {
    if (_filteredConfigs.isEmpty) return [];
    int start = (_currentPage - 1) * _itemsPerPage;
    int end = start + _itemsPerPage;
    if (end > _filteredConfigs.length) end = _filteredConfigs.length;
    return _filteredConfigs.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    // Génération des données simulées (mock data)
    _allConfigs = [];
    for (var type in _typesVisites.where((t) => t != 'Sélectionner')) {
      for (int i = 1; i <= 20; i++) {
        _allConfigs.add(
          ProjectConfig(
            typeVisite: type,
            projectName: 'Projet $i',
            emails: [],
          ),
        );
      }
    }
    _filterData();
  }

  void _filterData() {
    setState(() {
      _currentPage = 1;
      if (_selectedTypeVisite == 'Sélectionner') {
        _filteredConfigs = [];
      } else {
        _filteredConfigs = _allConfigs
            .where((config) => config.typeVisite == _selectedTypeVisite)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF1E40AF);

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF), // Background global
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddVisitFlow()));
          },
          backgroundColor: const Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          elevation: 6,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildHeader(primaryBlue),
            Expanded(
              child: _buildListView(primaryBlue),
            ),
            _buildFooter(primaryBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: const Text(
        'configurations emails',
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E293B),
          letterSpacing: -0.8,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildFooter(Color primaryBlue) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton(
          onPressed: _selectedTypeVisite == 'Sélectionner' ? null : () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Configuration sauvegardée avec succès !')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedTypeVisite == 'Sélectionner' ? Colors.grey : const Color(0xFF1E40AF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // Bouton plus carré
            ),
            elevation: 0,
          ),
          child: const Text('Sauvegarder', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryBlue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configuration des emails par Type Visite et Projet',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Type Visite',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return FilterSheetContent(
                    title: 'Type Visite',
                    options: _typesVisites,
                    currentValue: _selectedTypeVisite,
                    onSelected: (value) {
                      setState(() {
                         _selectedTypeVisite = value;
                         _filterData();
                      });
                    },
                    showSearch: false,
                  );
                },
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 1)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.category_outlined, size: 16, color: Color(0xFF64748B)),
                  const SizedBox(width: 8),
                  Text(
                    _selectedTypeVisite, 
                    style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w500)
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, size: 20, color: Color(0xFF64748B)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildListView(Color primaryBlue) {
    if (_filteredConfigs.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Text("Aucune donnée disponible."),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Table container
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête du tableau
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.blueGrey.withOpacity(0.1), width: 1.5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Text('Type Visite', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[800], fontSize: 13))),
                      Expanded(flex: 2, child: Text('Projet', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[800], fontSize: 13))),
                      Expanded(flex: 5, child: Text('Emails', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey[800], fontSize: 13))),
                    ],
                  ),
                ),
                // Liste
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: false,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _paginatedConfigs.length,
                    itemBuilder: (context, index) {
                      final config = _paginatedConfigs[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(bottom: BorderSide(color: Colors.blueGrey.withOpacity(0.1))),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 3, 
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey[200]!))),
                                  child: Text(config.typeVisite, style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500)),
                                ),
                              ),
                              Expanded(
                                flex: 2, 
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                                  decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey[200]!))),
                                  child: Text(config.projectName, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                                ),
                              ),
                              Expanded(
                                flex: 5, 
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: EmailInputWidget(
                                    emails: config.emails,
                                    primaryColor: primaryBlue,
                                    onEmailsChanged: (newEmails) {
                                      setState(() {
                                        config.emails.clear();
                                        config.emails.addAll(newEmails);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
                // Pagination UI outside table container
        if (_filteredConfigs.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 24),
                  color: _currentPage > 1 ? const Color(0xFF94A3B8) : Colors.grey[300],
                  onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                  splashRadius: 20,
                ),
                const SizedBox(width: 8),
                Wrap(
                  spacing: 8,
                  children: List.generate(_totalPages, (index) {
                    final int pageNumber = index + 1;
                    final bool isActive = _currentPage == pageNumber;
                    return GestureDetector(
                      onTap: () => setState(() => _currentPage = pageNumber),
                      child: Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF1E40AF) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: isActive ? null : Border.all(color: Colors.grey[300]!),
                          boxShadow: isActive ? null : [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 1))
                          ],
                        ),
                        child: Text(
                          '$pageNumber',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                            color: isActive ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 24),
                  color: _currentPage < _totalPages ? const Color(0xFF94A3B8) : Colors.grey[300],
                  onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
                  splashRadius: 20,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class EmailInputWidget extends StatefulWidget {
  final List<String> emails;
  final Color primaryColor;
  final ValueChanged<List<String>> onEmailsChanged;

  const EmailInputWidget({
    Key? key,
    required this.emails,
    required this.primaryColor,
    required this.onEmailsChanged,
  }) : super(key: key);

  @override
  _EmailInputWidgetState createState() => _EmailInputWidgetState();
}

class _EmailInputWidgetState extends State<EmailInputWidget> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  bool _isValidEmail(String email) {
    final RegExp regex = RegExp(
      r'^[a-zA-Z0-9.\-_]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return regex.hasMatch(email);
  }

  void _addEmail(String value) {
    final email = value.trim();
    if (email.isEmpty) return;

    if (!_isValidEmail(email)) {
      setState(() {
        _errorText = 'Format email invalide';
      });
      return;
    }

    if (widget.emails.contains(email)) {
      setState(() {
        _errorText = 'Cet email a déjà été ajouté';
      });
      return;
    }

    setState(() {
      _errorText = null;
      widget.emails.add(email);
      _controller.clear();
      _focusNode.requestFocus(); // Keeps focus to allow rapid typing
    });
    
    widget.onEmailsChanged(widget.emails);
  }

  void _removeEmail(String email) {
    setState(() {
      widget.emails.remove(email);
    });
    widget.onEmailsChanged(widget.emails);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.emails.isNotEmpty)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: widget.emails.map((email) {
                  return Chip(
                    label: Text(
                      email,
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    deleteIcon: Icon(Icons.cancel, size: 18, color: widget.primaryColor.withOpacity(0.7)),
                    onDeleted: () => _removeEmail(email),
                    backgroundColor: widget.primaryColor.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: widget.primaryColor.withOpacity(0.2)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'Ajouter un email et appuyer sur Entrée',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            errorText: _errorText,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: widget.primaryColor),
            ),
            prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[400], size: 20),
          ),
          keyboardType: TextInputType.emailAddress,
          onSubmitted: _addEmail,
        ),
      ],
    );
  }
}

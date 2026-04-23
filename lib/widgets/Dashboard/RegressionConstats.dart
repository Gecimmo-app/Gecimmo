import 'package:flutter/material.dart';
import '../ui_components/modern_ui_components.dart';
import 'Dashbordprincpa.dart';
import '../Ajouter_visite.dart' hide AppTheme;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Technical Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        scaffoldBackgroundColor: AppTheme.background,
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Filtres state
  String? selectedDateObs;
  DateTimeRange? selectedDateRange;
  String? selectedPeriodePreset;
  String? selectedProjet;
  String? selectedTranche;
  String? selectedUtilisateur;

  final List<String> dateObsOptions = [
    'Toutes les dates', 'Aujourd\'hui', 'Hier', 'Semaine dernière', 'Le mois dernier'
  ];
  final List<String> periodePresetOptions = [
    'Aujourd\'hui', 'Cette semaine', 'Ce mois', 'Cette année',
    '7 derniers jours', '30 derniers jours', '90 derniers jours', '365 derniers jours',
  ];
  final List<String> projetOptions = [
    'Tous les projets', 'Projet1', 'Projet2', 'Projet3', 'Projet4', 'Projet5'
  ];
  final List<String> trancheOptions = [
    'Toutes les tranches', 'Tranche 1', 'Tranche 2', 'Tranche 3'
  ];
  final List<String> utilisateurOptions = [
    'Tous les utilisateurs', 'Admin user', 'SAV - Agent technique'
  ];

  void _showFilterSheet(
    BuildContext context,
    String title,
    List<String> options,
    String? currentValue,
    Function(String) onSelected, {
    required bool showSearch,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FilterSheetContent(
          title: title,
          options: options,
          currentValue: currentValue,
          onSelected: onSelected,
          showSearch: showSearch,
        );
      },
    );
  }

  void _showPeriodeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Période',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: periodePresetOptions.map((preset) {
                      return FilterChip(
                        label: Text(preset),
                        selected: selectedPeriodePreset == preset,
                        onSelected: (selected) {
                          setStateModal(() {
                            selectedPeriodePreset = preset;
                            selectedDateRange = _getDateRangeFromPreset(preset);
                          });
                          Navigator.pop(context);
                          setState(() {});
                        },
                        selectedColor: const Color(0xFF3B82F6).withOpacity(0.2),
                        checkmarkColor: const Color(0xFF3B82F6),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Sélection personnalisée',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDateRange: selectedDateRange,
                      );
                      if (picked != null) {
                        setStateModal(() {
                          selectedDateRange = picked;
                          selectedPeriodePreset = null;
                        });
                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Choisir une plage de dates'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (selectedDateRange != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_formatDate(selectedDateRange!.start)} - ${_formatDate(selectedDateRange!.end)}',
                        style: const TextStyle(color: Color(0xFF3B82F6)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  DateTimeRange? _getDateRangeFromPreset(String preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (preset) {
      case 'Aujourd\'hui': return DateTimeRange(start: today, end: today);
      case 'Cette semaine':
        final start = today.subtract(Duration(days: today.weekday - 1));
        return DateTimeRange(start: start, end: start.add(const Duration(days: 6)));
      case 'Ce mois':
        return DateTimeRange(start: DateTime(today.year, today.month, 1), end: DateTime(today.year, today.month + 1, 0));
      case 'Cette année':
        return DateTimeRange(start: DateTime(today.year, 1, 1), end: DateTime(today.year, 12, 31));
      case '7 derniers jours': return DateTimeRange(start: today.subtract(const Duration(days: 7)), end: today);
      case '30 derniers jours': return DateTimeRange(start: today.subtract(const Duration(days: 30)), end: today);
      case '90 derniers jours': return DateTimeRange(start: today.subtract(const Duration(days: 90)), end: today);
      case '365 derniers jours': return DateTimeRange(start: today.subtract(const Duration(days: 365)), end: today);
      default: return null;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildFiltersRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            icon: Icons.calendar_today_outlined,
            label: selectedDateObs != null && selectedDateObs != 'Toutes les dates' ? selectedDateObs! : 'Date Observation',
            onTap: () => _showFilterSheet(context, 'Date Observation', dateObsOptions, selectedDateObs, (value) => setState(() => selectedDateObs = value), showSearch: false),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            icon: Icons.calendar_today_outlined,
            label: selectedPeriodePreset ?? (selectedDateRange != null ? '${_formatDate(selectedDateRange!.start)}...' : 'Période'),
            onTap: () => _showPeriodeDialog(context),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            icon: Icons.folder_outlined,
            label: selectedProjet != null && selectedProjet != 'Tous les projets' ? selectedProjet! : 'Projets (16)',
            onTap: () => _showFilterSheet(context, 'Projets', projetOptions, selectedProjet, (value) => setState(() => selectedProjet = value), showSearch: true),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            icon: Icons.pie_chart_outline, // ou layers mais c'est tranches
            label: selectedTranche != null && selectedTranche != 'Toutes les tranches' ? selectedTranche! : 'Tranches (Toutes)',
            onTap: () => _showFilterSheet(context, 'Tranches', trancheOptions, selectedTranche, (value) => setState(() => selectedTranche = value), showSearch: true),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            icon: Icons.person_outline,
            label: selectedUtilisateur != null && selectedUtilisateur != 'Tous les utilisateurs' ? selectedUtilisateur! : 'Utilisateurs (Tous)',
            onTap: () => _showFilterSheet(context, 'Utilisateurs', utilisateurOptions, selectedUtilisateur, (value) => setState(() => selectedUtilisateur = value), showSearch: true),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedDateObs = null;
                selectedDateRange = null;
                selectedPeriodePreset = null;
                selectedProjet = null;
                selectedTranche = null;
                selectedUtilisateur = null;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 1)),
                ],
              ),
              child: const Text('Réinitialiser', style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(width: 16), // Padding de fin
        ],
      ),
    );
  }

  Widget _buildFilterChip({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), 
              blurRadius: 4, 
              offset: const Offset(0, 1)
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: const Color(0xFF64748B)),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> cards = [
    {
      'title': 'Réception Technique',
      'count': 14,
      'color': AppTheme.primaryBlue,
      'lightColor': const Color(0xFFEFF6FF),
      'summary': '6 corps métier • 6 localités • 6 prestataires',
      'sections': [
        {
          'title': 'Corps Métier',
          'items': [
            {'name': 'Plomberie', 'count': 2},
            {'name': 'Plâtrerie', 'count': 1},
            {'name': 'Peinture', 'count': 1},
            {'name': 'Electricité', 'count': 1},
          ],
          'hidden': [],
        },
        {
          'title': 'Localités',
          'items': [
            {'name': 'Chambre d\'enfant', 'count': 1},
            {'name': 'Salle de bain', 'count': 1},
            {'name': 'Cuisine', 'count': 1},
            {'name': 'Couloir', 'count': 1},
          ],
          'hidden': [
            {'name': 'Bureau', 'count': 1},
            {'name': 'Salon', 'count': 1},
          ],
        },
        {
          'title': 'Prestataires',
          'items': [
            {'name': 'Prestataire A', 'count': 1},
            {'name': 'Prestataire B', 'count': 1},
            {'name': 'Prestataire C', 'count': 1},
            {'name': 'Prestataire D', 'count': 1},
          ],
          'hidden': [
            {'name': 'Prestataire E', 'count': 1},
            {'name': 'Prestataire F', 'count': 1},
          ],
        },
      ],
    },
    {
      'title': 'Livraison Technique',
      'count': 9,
      'color': AppTheme.success,
      'lightColor': const Color(0xFFECFDF5),
      'summary': '4 corps métier • 5 localités • 5 prestataires',
      'sections': [
        {
          'title': 'Corps Métier',
          'items': [
            {'name': 'Peinture', 'count': 1},
            {'name': 'Plomberie', 'count': 1},
            {'name': 'Maçonnerie', 'count': 1},
            {'name': 'Electricité', 'count': 1},
          ],
          'hidden': [],
        },
        {
          'title': 'Localités',
          'items': [
            {'name': 'Chambre d\'enfant', 'count': 1},
            {'name': 'Bureau', 'count': 1},
            {'name': 'Couloir', 'count': 1},
            {'name': 'Salle de bain', 'count': 1},
          ],
          'hidden': [
            {'name': 'Cuisine', 'count': 1},
          ],
        },
        {
          'title': 'Prestataires',
          'items': [
            {'name': 'Prestataire 1', 'count': 1},
            {'name': 'Prestataire 2', 'count': 1},
            {'name': 'Prestataire 3', 'count': 1},
            {'name': 'Prestataire 4', 'count': 1},
          ],
          'hidden': [
            {'name': 'Prestataire 5', 'count': 1},
          ],
        },
      ],
    },
    {
      'title': 'Réclamation',
      'count': 4,
      'color': AppTheme.danger,
      'lightColor': const Color(0xFFFEF2F2),
      'summary': '4 corps métier • 6 localités • 5 prestataires',
      'sections': [
        {
          'title': 'Corps Métier',
          'items': [
            {'name': 'Maçonnerie', 'count': 1},
            {'name': 'Electricité', 'count': 1},
            {'name': 'Plâtrerie', 'count': 1},
            {'name': 'Plomberie', 'count': 1},
          ],
          'hidden': [],
        },
        {
          'title': 'Localités',
          'items': [
            {'name': 'Bureau', 'count': 1},
            {'name': 'Buanderie', 'count': 1},
            {'name': 'Chambre d\'enfant', 'count': 1},
            {'name': 'Salle de bain', 'count': 1},
          ],
          'hidden': [
            {'name': 'Cuisine', 'count': 1},
            {'name': 'Couloir', 'count': 1},
          ],
        },
        {
          'title': 'Prestataires',
          'items': [
            {'name': 'Prestataire X', 'count': 1},
            {'name': 'Prestataire Y', 'count': 1},
            {'name': 'Prestataire Z', 'count': 1},
            {'name': 'Prestataire W', 'count': 1},
          ],
          'hidden': [
            {'name': 'Prestataire V', 'count': 1},
          ],
        },
      ],
    },
    {
      'title': 'Livraison Client',
      'count': 2,
      'color': const Color(0xFF8B5CF6),
      'lightColor': const Color(0xFFF5F3FF),
      'summary': '4 corps métier • 6 localités • 5 prestataires',
      'sections': [
        {
          'title': 'Corps Métier',
          'items': [
            {'name': 'Electricité', 'count': 1},
            {'name': 'Plomberie', 'count': 1},
            {'name': 'Peinture', 'count': 1},
            {'name': 'Maçonnerie', 'count': 1},
          ],
          'hidden': [],
        },
        {
          'title': 'Localités',
          'items': [
            {'name': 'Bureau', 'count': 1},
            {'name': 'Buanderie', 'count': 1},
            {'name': 'Chambre', 'count': 1},
            {'name': 'Salon', 'count': 1},
          ],
          'hidden': [
            {'name': 'Cuisine', 'count': 1},
            {'name': 'Couloir', 'count': 1},
          ],
        },
        {
          'title': 'Prestataires',
          'items': [
            {'name': 'Prestataire 1', 'count': 1},
            {'name': 'Prestataire Alpha', 'count': 1},
            {'name': 'Prestataire Beta', 'count': 1},
            {'name': 'Prestataire Gamma', 'count': 1},
          ],
          'hidden': [
            {'name': 'Prestataire Delta', 'count': 1},
          ],
        },
      ],
    },
    {
      'title': 'Livraison Syndic',
      'count': 2,
      'color': AppTheme.warning,
      'lightColor': const Color(0xFFFEF3C7),
      'summary': '2 corps métier • 2 localités • 1 prestataires',
      'sections': [
        {
          'title': 'Corps Métier',
          'items': [
            {'name': 'Plomberie', 'count': 1},
            {'name': 'Plâtrerie', 'count': 1},
          ],
          'hidden': [],
        },
        {
          'title': 'Localités',
          'items': [
            {'name': 'Bureau', 'count': 1},
            {'name': 'Chambre des invités', 'count': 1},
          ],
          'hidden': [],
        },
        {
          'title': 'Prestataires',
          'items': [
            {'name': 'Prestataire 1', 'count': 2},
          ],
          'hidden': [],
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    void openAddVisitFlow() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddVisitFlow()),
      );
    }

    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: FloatingActionButton(
            onPressed: openAddVisitFlow,
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: Colors.white,
            elevation: 6,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 34),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildFiltersRow(),
                      ),
                      const SizedBox(height: 28),
                      ...cards.map((card) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                        child: DashboardCard(
                          title: card['title'],
                          count: card['count'],
                          summary: card['summary'],
                          sections: card['sections'],
                          cardColor: card['color'],
                          lightColor: card['lightColor'],
                        ),
                      )),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Text(
        "Regression Constats",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label, value;
  final int color1, color2;
  final IconData icon;
  const _StatTile({required this.label, required this.value, required this.color1, required this.color2, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(color1), Color(color2)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatefulWidget {
  final String title;
  final int count;
  final String summary;
  final List sections;
  final Color cardColor;
  final Color lightColor;

  const DashboardCard({
    super.key,
    required this.title,
    required this.count,
    required this.summary,
    required this.sections,
    required this.cardColor,
    required this.lightColor,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: widget.cardColor.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(width: 6, height: 32, decoration: BoxDecoration(color: widget.cardColor, borderRadius: BorderRadius.circular(10))),
                  const SizedBox(width: 12),
                  Expanded(child: Text(widget.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: widget.lightColor, borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      widget.count.toString(),
                      style: TextStyle(color: widget.cardColor, fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(Icons.keyboard_arrow_down, color: widget.cardColor, size: 24),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  for (var section in widget.sections)
                    SectionCard(
                      title: section['title'],
                      items: List<Map<String, dynamic>>.from(section['items']),
                      hiddenItems: section['hidden'] != null ? List<Map<String, dynamic>>.from(section['hidden']) : [],
                      cardColor: widget.cardColor,
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade100))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.summary, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                  const Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: Color(0xFF9CA3AF)),
                      SizedBox(width: 4),
                      Text("Mis à jour", style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SectionCard extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>> hiddenItems;
  final Color cardColor;

  const SectionCard({
    super.key,
    required this.title,
    required this.items,
    required this.hiddenItems,
    required this.cardColor,
  });

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final displayItems = _showAll ? [...widget.items, ...widget.hiddenItems] : widget.items;
    final hasMore = widget.hiddenItems.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
        const SizedBox(height: 10),
        Column(
          children: [
            for (var item in displayItems)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item['name'],
                        style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "+${item['count']}",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6B7280)),
                      ),
                    ),
                  ],
                ),
              ),
            if (hasMore && !_showAll)
              GestureDetector(
                onTap: () => setState(() => _showAll = true),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: widget.cardColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "+${widget.hiddenItems.length} autres",
                        style: TextStyle(fontSize: 14, color: widget.cardColor),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 12, color: widget.cardColor),
                    ],
                  ),
                ),
              ),
            if (_showAll && hasMore)
              GestureDetector(
                onTap: () => setState(() => _showAll = false),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: widget.cardColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Voir moins',
                        style: TextStyle(fontSize: 14, color: widget.cardColor),
                      ),
                      Icon(Icons.arrow_drop_up, size: 18, color: widget.cardColor),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
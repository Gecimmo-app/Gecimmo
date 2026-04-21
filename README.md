<<<<<<< HEAD
<<<<<<< HEAD
# sav


=======
<!-- # projet_sva

A new Flutter project.
>>>>>>> feature/dashboard-Emails-observations-parametrages
=======
<!-- # projet_sva

A new Flutter project.
>>>>>>> feature/dashboard-Emails-observations-parametrages

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
<<<<<<< HEAD
<<<<<<< HEAD
samples, guidance on mobile development, and a full API reference.
=======
=======
>>>>>>> feature/dashboard-Emails-observations-parametrages
samples, guidance on mobile development, and a full API reference. -->


















bghit nkhli app menu osidebar ofach nwrk 23la regression constats affcher liya hadik 3ndii  had codes obgt fach nwrk 3la dashbord princiap fsidebar ytl3 liya page dylo okadalik bnisbaa l regression constats voici le codes et donne moi les codes complet import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppColors {
  static const Color blue = Color(0xFF3B82F6);
  static const Color bluePale = Color(0xFFEFF6FF);
  static const Color textDark = Color(0xFF1F2937);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAFAFE);
  
  // Couleurs pour les cartes
  static const Color cardBlue = Color(0xFF3B82F6);
  static const Color cardGreen = Color(0xFF22C55E);
  static const Color cardRed = Color(0xFFEF4444);
  static const Color cardPurple = Color(0xFF8B5CF6);
  static const Color cardOrange = Color(0xFFF59E0B);
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, dynamic>> cards = [
    {
      'title': 'Réception Technique',
      'count': 14,
      'color': AppColors.cardBlue,
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
      'color': AppColors.cardGreen,
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
      'color': AppColors.cardRed,
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
      'color': AppColors.cardPurple,
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
      'color': AppColors.cardOrange,
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              onAddVisit: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ajouter une visite')),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    
                    const SizedBox(height: 28),
                    ...cards.map((card) => Padding(
                      padding: const EdgeInsets.only(bottom: 18),
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
    );
  }

 
}

class _TopBar extends StatelessWidget {
  final VoidCallback onAddVisit;

  const _TopBar({required this.onAddVisit});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bluePale,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: onAddVisit,
            icon: const Icon(Icons.add_circle_outline, size: 16),
            label: const Text('Ajouter une visite', style: TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ],
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
} import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../ajouter_visite.dart';

// ─────────────────────────────────────────────
//  THEME CONSTANTS
// ─────────────────────────────────────────────
class AppColors {
  static const blue = Color(0xFF1E40AF);
  static const blueLight = Color(0xFF3B82F6);
  static const bluePale = Color(0xFFEFF6FF);
  static const green = Color(0xFF22C55E);
  static const orange = Color(0xFFF59E0B);
  static const red = Color(0xFFEF4444);
  static const purple = Color(0xFF8B5CF6);
  static const white = Color(0xFFFFFFFF);
  static const bg = Color(0xFFF4F6FB);
  static const textDark = Color(0xFF1E293B);
  static const textMid = Color(0xFF64748B);
  static const cardBorder = Color(0xFFE2E8F0);
}

// ─────────────────────────────────────────────
//  MAIN DASHBOARD PAGE
// ─────────────────────────────────────────────
class DashbordPrincpa extends StatefulWidget {
  const DashbordPrincpa({super.key});

  @override
  State<DashbordPrincpa> createState() => _DashbordPrincpaState();
}

class _DashbordPrincpaState extends State<DashbordPrincpa> {
  // État des filtres
  String? selectedTypeVisite;
  String? selectedProjet;
  String? selectedUtilisateur;
  DateTimeRange? selectedDateRange;
  String? selectedPeriodePreset;

  // Contrôleurs pour le défilement
  final ScrollController _scrollControllerRow1 = ScrollController();
  final ScrollController _scrollControllerRow2 = ScrollController();

  // Options pour les filtres
  final List<String> typeVisiteOptions = [
    'Tous les types de visite',
    'Réception Technique',
    'Livraison Technique',
    'Livraison Client',
    'Livraison Syndic',
    'Réclamation',
  ];

  final List<String> projetOptions = [
    'Tous les projets',
    'Projet1',
    'Projet2',
    'Projet3',
    'Projet4',
    'Projet5',
    'Projet6',
    'Projet7',
    'Projet9',
    'Projet10',
    'Projet12',
    'Projet13',
    'Projet14',
    'Projet15',
    'Projet18',
    'Projet19',
  ];

  final List<String> utilisateurOptions = [
    'Tous les utilisateurs',
    'admin user',
    'utilisateur10013',
    'SAV - Agent technique',
  ];

  final List<String> periodePresetOptions = [
    'Aujourd\'hui',
    'Cette semaine',
    'Ce mois',
    'Cette année',
    '7 derniers jours',
    '30 derniers jours',
    '90 derniers jours',
    '365 derniers jours',
  ];

  void _openAddVisitFlow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddVisitFlow(),
      ),
    );
  }

  @override
  void dispose() {
    _scrollControllerRow1.dispose();
    _scrollControllerRow2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(onAddVisit: _openAddVisitFlow),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DashboardHeader(
                      onTypeVisiteTap: () => _showFilterSheet(
                        context,
                        'Type de visite',
                        typeVisiteOptions,
                        selectedTypeVisite,
                        (value) => setState(() => selectedTypeVisite = value),
                        showSearch: false,
                      ),
                      onProjetTap: () => _showFilterSheet(
                        context,
                        'Projets',
                        projetOptions,
                        selectedProjet,
                        (value) => setState(() => selectedProjet = value),
                        showSearch: true,
                      ),
                      onUtilisateurTap: () => _showFilterSheet(
                        context,
                        'Utilisateurs',
                        utilisateurOptions,
                        selectedUtilisateur,
                        (value) => setState(() => selectedUtilisateur = value),
                        showSearch: true,
                      ),
                      onPeriodeTap: () => _showPeriodeDialog(context),
                    ),
                    const SizedBox(height: 16),
                    _KpiRow1(scrollController: _scrollControllerRow1),
                    const SizedBox(height: 12),
                    _KpiRow2(scrollController: _scrollControllerRow2),
                    const SizedBox(height: 24),
                    _ChartsRow(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                      color: AppColors.textDark,
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
                        selectedColor: AppColors.blueLight.withOpacity(0.2),
                        checkmarkColor: AppColors.blue,
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
                      color: AppColors.textDark,
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
                      backgroundColor: AppColors.blue,
                      foregroundColor: AppColors.white,
                    ),
                  ),
                  if (selectedDateRange != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bluePale,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_formatDate(selectedDateRange!.start)} - ${_formatDate(selectedDateRange!.end)}',
                        style: const TextStyle(color: AppColors.blue),
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
      case 'Aujourd\'hui':
        return DateTimeRange(start: today, end: today);
      case 'Cette semaine':
        final start = today.subtract(Duration(days: today.weekday - 1));
        final end = start.add(const Duration(days: 6));
        return DateTimeRange(start: start, end: end);
      case 'Ce mois':
        final start = DateTime(today.year, today.month, 1);
        final end = DateTime(today.year, today.month + 1, 0);
        return DateTimeRange(start: start, end: end);
      case 'Cette année':
        final start = DateTime(today.year, 1, 1);
        final end = DateTime(today.year, 12, 31);
        return DateTimeRange(start: start, end: end);
      case '7 derniers jours':
        return DateTimeRange(start: today.subtract(const Duration(days: 7)), end: today);
      case '30 derniers jours':
        return DateTimeRange(start: today.subtract(const Duration(days: 30)), end: today);
      case '90 derniers jours':
        return DateTimeRange(start: today.subtract(const Duration(days: 90)), end: today);
      case '365 derniers jours':
        return DateTimeRange(start: today.subtract(const Duration(days: 365)), end: today);
      default:
        return null;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// ─────────────────────────────────────────────
//  FILTER SHEET CONTENT
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
    required this.showSearch,
  });

  @override
  State<_FilterSheetContent> createState() => _FilterSheetContentState();
}

class _FilterSheetContentState extends State<_FilterSheetContent> {
  String _searchQuery = '';
  
  List<String> get _filteredOptions {
    if (_searchQuery.isEmpty) {
      return widget.options;
    }
    return widget.options.where((option) {
      return option.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          if (widget.showSearch) ...[
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Rechercher ${widget.title.toLowerCase()}...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textMid, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  hintStyle: const TextStyle(fontSize: 14, color: AppColors.textMid),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_filteredOptions.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 48, color: AppColors.textMid),
                      const SizedBox(height: 12),
                      Text(
                        'Aucun résultat trouvé',
                        style: TextStyle(fontSize: 16, color: AppColors.textMid),
                      ),
                    ],
                  ),
                ),
              ),
          ],
          if (!widget.showSearch || _filteredOptions.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = _filteredOptions[index];
                  final isSelected = option == widget.currentValue;
                  return CheckboxListTile(
                    title: Text(
                      option,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    value: isSelected,
                    activeColor: AppColors.blue,
                    onChanged: (checked) {
                      if (checked == true) {
                        widget.onSelected(option);
                        Navigator.pop(context);
                      }
                    },
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
//  TOP BAR
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final VoidCallback onAddVisit;

  const _TopBar({required this.onAddVisit});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bluePale,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: onAddVisit,
            icon: const Icon(Icons.add_circle_outline, size: 16),
            label: const Text('Ajouter une visite', style: TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DASHBOARD HEADER
// ─────────────────────────────────────────────
class _DashboardHeader extends StatelessWidget {
  final VoidCallback onTypeVisiteTap;
  final VoidCallback onProjetTap;
  final VoidCallback onUtilisateurTap;
  final VoidCallback onPeriodeTap;

  const _DashboardHeader({
    required this.onTypeVisiteTap,
    required this.onProjetTap,
    required this.onUtilisateurTap,
    required this.onPeriodeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                icon: Icons.category_outlined,
                label: 'Type visite (5)',
                onTap: onTypeVisiteTap,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                icon: Icons.folder_outlined,
                label: 'Projets (16)',
                onTap: onProjetTap,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                icon: Icons.person_outline,
                label: 'Utilisateurs (3)',
                onTap: onUtilisateurTap,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                icon: Icons.calendar_today_outlined,
                label: 'Période',
                onTap: onPeriodeTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 1)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: AppColors.textMid),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.textMid, fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 18, color: AppColors.textMid),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DOT INDICATOR
// ─────────────────────────────────────────────
class _DotIndicator extends StatefulWidget {
  final int totalCards;
  final ScrollController scrollController;

  const _DotIndicator({
    required this.totalCards,
    required this.scrollController,
  });

  @override
  State<_DotIndicator> createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<_DotIndicator> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_updateCurrentIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateCurrentIndex();
    });
  }

  void _updateCurrentIndex() {
    if (widget.scrollController.hasClients) {
      final maxScroll = widget.scrollController.position.maxScrollExtent;
      final currentScroll = widget.scrollController.position.pixels;
      final index = maxScroll > 0 
          ? (currentScroll / maxScroll * (widget.totalCards - 1)).round()
          : 0;
      if (mounted && _currentIndex != index) {
        setState(() {
          _currentIndex = index.clamp(0, widget.totalCards - 1);
        });
      }
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateCurrentIndex);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.totalCards, (index) {
        final isActive = index == _currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: isActive ? AppColors.blue : AppColors.cardBorder,
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
//  SCROLLABLE CARDS ROW
// ─────────────────────────────────────────────
class _ScrollableCardsRow extends StatelessWidget {
  final List<Widget> cards;
  final int totalCards;
  final ScrollController scrollController;

  const _ScrollableCardsRow({
    required this.cards,
    required this.totalCards,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          child: Row(
            children: cards,
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: _DotIndicator(
            totalCards: totalCards,
            scrollController: scrollController,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  KPI ROWS
// ─────────────────────────────────────────────
class _KpiRow1 extends StatelessWidget {
  final ScrollController scrollController;

  const _KpiRow1({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return _ScrollableCardsRow(
      scrollController: scrollController,
      totalCards: 5,
      cards: [
        _KpiCard(
          icon: Icons.check_box_outlined,
          iconColor: AppColors.blue,
          value: '16',
          label: 'Visites',
        ),
        const SizedBox(width: 12),
        _KpiCard(
          icon: Icons.check_circle_outline,
          iconColor: AppColors.green,
          value: '26',
          label: 'Observations relevées',
        ),
        const SizedBox(width: 12),
        _KpiCard(
          icon: Icons.schedule_outlined,
          iconColor: AppColors.purple,
          value: '0 / 6',
          label: 'Observations planifiées / non planifiées',
          valueFontSize: 24,
        ),
        const SizedBox(width: 12),
        _KpiCard(
          icon: Icons.warning_amber_outlined,
          iconColor: AppColors.orange,
          value: '2',
          label: 'Observations à valider',
        ),
        const SizedBox(width: 12),
        _KpiCard(
          icon: Icons.check_circle_outline,
          iconColor: AppColors.green,
          value: '18',
          label: 'Observations levées',
        ),
      ],
    );
  }
}

class _KpiRow2 extends StatelessWidget {
  final ScrollController scrollController;

  const _KpiRow2({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return _ScrollableCardsRow(
      scrollController: scrollController,
      totalCards: 4,
      cards: [
        _KpiCard(
          icon: Icons.timer_outlined,
          iconColor: AppColors.red,
          value: '5',
          label: 'Délai moyen prévisionnel de planification (en jours)',
        ),
        const SizedBox(width: 12),
        _KpiCard(
          icon: Icons.warning_amber_outlined,
          iconColor: AppColors.red,
          value: '1',
          label: 'Moyenne de jours de retard de prise en charge',
        ),
        const SizedBox(width: 12),
        _KpiCard(
          icon: Icons.timer_outlined,
          iconColor: AppColors.red,
          value: '2',
          label: 'Délai moyen de réalisation',
        ),
        const SizedBox(width: 12),
        _KpiCard(
          icon: Icons.visibility_outlined,
          iconColor: AppColors.purple,
          value: '2.1',
          label: 'Moyenne des observations par bien',
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final double valueFontSize;

  const _KpiCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.valueFontSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 34),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.5,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMid,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CHARTS ROW
// ─────────────────────────────────────────────
class _ChartsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DonutChartCard(
          title: 'Top Corps de Métiers',
          centerLabel: '31',
          segments: const [
            _Segment('Plomberie', 11, 35.5, Color(0xFF3B82F6)),
            _Segment('Peinture', 6, 19.4, Color(0xFFEC4899)),
            _Segment('Plâtrerie', 5, 16.1, Color(0xFFF59E0B)),
            _Segment('Maçonnerie', 4, 12.9, Color(0xFF22C55E)),
            _Segment('Electricité', 4, 12.9, Color(0xFF8B5CF6)),
            _Segment('Carrelage', 1, 3.2, Color(0xFFF97316)),
          ],
        ),
        const SizedBox(height: 16),
        _DonutChartCard(
          title: 'Prestataires',
          centerLabel: '31',
          segments: const [
            _Segment('Prestataire 1', 31, 100.0, Color(0xFF3B82F6)),
          ],
        ),
      ],
    );
  }
}

class _Segment {
  final String label;
  final int count;
  final double pct;
  final Color color;
  const _Segment(this.label, this.count, this.pct, this.color);
}

class _DonutChartCard extends StatelessWidget {
  final String title;
  final String centerLabel;
  final List<_Segment> segments;

  const _DonutChartCard({
    required this.title,
    required this.centerLabel,
    required this.segments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 130,
                height: 130,
                child: CustomPaint(
                  painter: _DonutPainter(segments: segments, centerLabel: centerLabel),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: segments
                      .map(
                        (s) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: s.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s.label,
                                  style: const TextStyle(fontSize: 12.5, color: AppColors.textDark),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${s.count}',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${s.pct.toStringAsFixed(1)}%)',
                                style: const TextStyle(fontSize: 11.5, color: AppColors.textMid),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<_Segment> segments;
  final String centerLabel;

  const _DonutPainter({required this.segments, required this.centerLabel});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = math.min(cx, cy);
    final strokeW = radius * 0.36;
    final innerRadius = radius - strokeW;

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius - strokeW / 2);

    const gapAngle = 0.04;
    double startAngle = -math.pi / 2;
    final total = segments.fold<double>(0, (sum, s) => sum + s.pct);

    for (final seg in segments) {
      final sweep = (seg.pct / total) * (2 * math.pi) - gapAngle;
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep + gapAngle;
    }

    canvas.drawCircle(
      Offset(cx, cy),
      innerRadius - 4,
      Paint()..color = AppColors.white,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: centerLabel,
        style: TextStyle(
          fontSize: innerRadius * 0.55,
          fontWeight: FontWeight.w800,
          color: AppColors.textDark,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_DonutPainter old) => false;
} import 'package:flutter/material.dart';
import '../menu_sidebar/widgests/menuapp.dart';
import 'RegressionConstats.dart';
// import 'package:projet_sva/menu_sidebar/widgests/menuapp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SVA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const DashboardScreen(),
    );
  }
}  import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF1E40AF);

class SidebarItem {
  final String title;
  final IconData icon;
  final List<SidebarItem>? children;
  bool isExpanded;

  SidebarItem({
    required this.title,
    required this.icon,
    this.children,
    this.isExpanded = false,
  });
}

class Sidebar extends StatefulWidget {
  final AnimationController animationController;
  final VoidCallback onClose;

  const Sidebar({
    Key? key,
    required this.animationController,
    required this.onClose,
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final List<SidebarItem> _menuItems = [
    SidebarItem(
      title: 'Dashbord',
      icon: Icons.dashboard_outlined,
      isExpanded: true,
      children: [
        SidebarItem(title: 'Dashboard Principal', icon: Icons.circle),
        SidebarItem(title: 'Observations', icon: Icons.circle_outlined),
        SidebarItem(title: 'Regression Constats', icon: Icons.circle_outlined),
      ],
    ),
    SidebarItem(title: 'Visites', icon: Icons.explore_outlined),
    SidebarItem(title: 'Observations', icon: Icons.visibility_outlined),
    // SidebarItem(title: 'Reclamation', icon: Icons.notifications_outlined),
    SidebarItem(title: 'Agenda', icon: Icons.calendar_today_outlined),
    SidebarItem(
      title: 'Reporting',
      icon: Icons.bar_chart_outlined,
      isExpanded: true,
      children: [
        SidebarItem(title: 'Livraison', icon: Icons.circle_outlined),
        SidebarItem(title: 'Rapport Immeubles', icon: Icons.circle_outlined),
      ],
    ),
    SidebarItem(title: 'Parametrages', icon: Icons.settings_outlined),
  ];

  String _selectedItem = 'Dashboard Principal';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.73;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(widget.animationController),

      child: Material(
        elevation: 24,
        child: Container(
          width: width,
          color: Colors.white,
          child: Column(
            children: [
              // 🔵 HEADER
              _buildHeader(),

              // 🔵 LINE HEADER → MENU
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: primaryBlue.withOpacity(0.08),
              ),

              // 🔵 MENU
              Expanded(
                child: ListView(
                  children: _menuItems.map(_buildMenuItem).toList(),
                ),
              ),

              // 🔵 LINE MENU → FOOTER
              Container(
                height: 1,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: primaryBlue.withOpacity(0.08),
              ),

              // 🔵 FOOTER
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // 🔵 HEADER
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 15,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),

              const Text(
                "SVA",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),

          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔵 MENU ITEM
  Widget _buildMenuItem(SidebarItem item) {
    final hasChildren = item.children != null;
    final isSelected = _selectedItem == item.title;

    if (hasChildren) {
      return Column(
        children: [
          ListTile(
            leading: Icon(item.icon, color: primaryBlue),
            title: Text(item.title),
            trailing: IconButton(
              icon: Icon(
                item.isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: primaryBlue,
              ),
              onPressed: () {
                setState(() {
                  item.isExpanded = !item.isExpanded;
                });
              },
            ),
          ),
          if (item.isExpanded)
            ...item.children!.map(_buildChild),
        ],
      );
    }

    return ListTile(
      leading: Icon(
        item.icon,
        color: isSelected
            ? primaryBlue
            : primaryBlue.withOpacity(0.6),
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: isSelected ? primaryBlue : Colors.black87,
        ),
      ),
      onTap: () {
        setState(() => _selectedItem = item.title);
        widget.onClose();
      },
    );
  }

  // 🔵 CHILD ITEM
  Widget _buildChild(SidebarItem child) {
    final isSelected = _selectedItem == child.title;

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        leading: Icon(
          child.icon,
          size: 10,
          color: isSelected
              ? primaryBlue
              : primaryBlue.withOpacity(0.4),
        ),
        title: Text(
          child.title,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? primaryBlue : Colors.black54,
          ),
        ),
        onTap: () {
          setState(() => _selectedItem = child.title);
          widget.onClose();
        },
      ),
    );
  }

  // 🔵 FOOTER
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: primaryBlue.withOpacity(0.1),
            child: const Text(
              "A",
              style: TextStyle(color: primaryBlue),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(child: Text("Admin User")),
          const Icon(
            Icons.logout_outlined,
            color: primaryBlue,
          ),
        ],
      ),
    );
  }
<<<<<<< HEAD
} 
>>>>>>> feature/dashboard-Emails-observations-parametrages
=======
} 
>>>>>>> feature/dashboard-Emails-observations-parametrages

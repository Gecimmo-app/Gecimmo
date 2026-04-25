import 'package:flutter/material.dart';
import 'add_ticket_page.dart';
import 'cloturer_visite_page.dart';
import 'tickets_page.dart';
import 'observations_page.dart';

class _PagePalette {
  static const Color primary = Color(0xFF1E40AF);
  static const Color background = Color(0xFFEFF6FF);
  static const Color surface = Colors.white;
  static const Color title = Color(0xFF0F172A);
  static const Color subtitle = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
}

class DetailsVisitePage extends StatefulWidget {
  final String projetName;
  const DetailsVisitePage({super.key, required this.projetName});

  @override
  State<DetailsVisitePage> createState() => _DetailsVisitePageState();
}

class _DetailsVisitePageState extends State<DetailsVisitePage> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _PagePalette.background,
      appBar: AppBar(
        backgroundColor: _PagePalette.primary,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          widget.projetName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const SliverToBoxAdapter(child: HeaderSection()),
            SliverToBoxAdapter(
              child: TabsSection(
                currentIndex: _currentTabIndex,
                onTabChanged: (index) =>
                    setState(() => _currentTabIndex = index),
              ),
            ),
          ];
        },
        body: IndexedStack(
          index: _currentTabIndex,
          children: const [
            VueGlobalContent(),
            TicketsPage(),
            ObservationsPage(),
          ],
        ),
      ),
    );
  }
}

// ============ HEADER WIDGET ============
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _PagePalette.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Projet1 - Tranche3 - GH1.1 - I1 - 1er - Bien4",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _PagePalette.title,
                letterSpacing: -0.2,
                height: 1.25,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 14,
                    color: _PagePalette.primary,
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Réclamation",
                    style: TextStyle(
                      color: _PagePalette.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    text: "Ajouter un Ticket",
                    icon: Icons.add_circle_outline,
                    bg: _PagePalette.primary,
                    textCol: Colors.white,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTicketPage(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    text: "Clôturer la visite",
                    icon: Icons.task_alt_outlined,
                    bg: const Color(0xFFDC2626),
                    textCol: Colors.white,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => const CloturerVisitePage(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color bg;
  final Color textCol;
  final VoidCallback onTap;

  const _ActionButton({
    required this.text,
    required this.icon,
    required this.bg,
    required this.textCol,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: textCol,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============ TABS WIDGET ============
class TabsSection extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const TabsSection({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _PagePalette.surface,
        border: const Border(bottom: BorderSide(color: _PagePalette.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _TabItem(
                title: "Vue global",
                index: 0,
                currentIndex: currentIndex,
                onTap: onTabChanged,
              ),
              const SizedBox(width: 24),
              _TabItem(
                title: "Tickets",
                index: 1,
                currentIndex: currentIndex,
                onTap: onTabChanged,
              ),
              const SizedBox(width: 24),
              _TabItem(
                title: "Observations",
                index: 2,
                currentIndex: currentIndex,
                onTap: onTabChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _TabItem({
    required this.title,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? _PagePalette.primary : Colors.transparent,
              width: 2.4,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? _PagePalette.primary : _PagePalette.subtitle,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// ============ MAIN CONTENT (RESPONSIVE) ============
class VueGlobalContent extends StatelessWidget {
  const VueGlobalContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1000) return const _DesktopLayout();
        if (constraints.maxWidth >= 600) return const _TabletLayout();
        return const _MobileLayout();
      },
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          StatsGrid(crossAxisCount: 5),
          SizedBox(height: 16),
          CategoriesList(),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(width: 350, child: DetailsCard()),
          ),
          SizedBox(height: 16),
          ReportsSection(),
        ],
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          StatsGrid(crossAxisCount: 3),
          SizedBox(height: 16),
          CategoriesList(),
          SizedBox(height: 16),
          DetailsCard(),
          SizedBox(height: 16),
          ReportsSection(),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          StatsGrid(crossAxisCount: 2),
          SizedBox(height: 12),
          CategoriesList(),
          SizedBox(height: 12),
          DetailsCard(),
          SizedBox(height: 12),
          ReportsSection(),
        ],
      ),
    );
  }
}

// ============ DETAILS CARD WIDGET ============
class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _PagePalette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _PagePalette.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Détails",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: _PagePalette.title,
            ),
          ),
          SizedBox(height: 22),
          _DetailRow(label: "Date de début", value: "07/04/2026 11:38"),
          SizedBox(height: 14),
          _DetailRow(label: "Date de fin", value: "Non définie"),
          SizedBox(height: 14),
          _DetailRow(label: "Type de visite", value: "Réclamation"),
          SizedBox(height: 14),
          _DetailRow(label: "Projet", value: "Projet1"),
          SizedBox(height: 14),
          _DetailRow(label: "Tranche", value: "Tranche3"),
          SizedBox(height: 14),
          _DetailRow(label: "Groupement", value: "GH1.1"),
          SizedBox(height: 14),
          _DetailRow(label: "Immeuble", value: "I1"),
          SizedBox(height: 14),
          _DetailRow(label: "Étage", value: "Non"),
          SizedBox(height: 14),
          _DetailRow(label: "Bien", value: "Bien4"),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: const TextStyle(
              color: _PagePalette.subtitle,
              fontSize: 13.5,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: _PagePalette.title,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ============ STATS SECTION ============
class StatsGrid extends StatelessWidget {
  final int crossAxisCount;

  const StatsGrid({super.key, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "val": "1",
        "label": "Tickets",
        "icon": Icons.confirmation_num_outlined,
        "color": _PagePalette.primary,
      },
      {
        "val": "1",
        "label": "Observations",
        "icon": Icons.chat_bubble_outline,
        "color": const Color(0xFFEA580C),
      },
      {
        "val": "0",
        "label": "En attente de planification",
        "icon": Icons.timer_outlined,
        "color": const Color(0xFFD97706),
      },
      {
        "val": "0",
        "label": "Observations en cours",
        "icon": Icons.sync,
        "color": const Color(0xFFD97706),
      },
      {
        "val": "1",
        "label": "Observations réalisées",
        "icon": Icons.check_circle_outline,
        "color": const Color(0xFF16A34A),
      },
    ];

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final Map<String, dynamic> item = items[index];
        return StatCard(
          value: item["val"] as String,
          label: item["label"] as String,
          icon: item["icon"] as IconData,
          iconColor: item["color"] as Color,
        );
      },
    );
  }
}

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color iconColor;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _PagePalette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _PagePalette.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: _PagePalette.title,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: _PagePalette.subtitle,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ============ CATEGORIES WIDGET ============
class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Map<String, String>> items = [
      {"title": "Corps metier", "val": "Plomberie"},
      {"title": "Emplacements", "val": "Buanderie"},
      {"title": "Prestataires", "val": "Prestataire 1"},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 1;
        if (constraints.maxWidth >= 900) {
          columns = 3;
        } else if (constraints.maxWidth >= 600) {
          columns = 2;
        }

        return GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: 100,
          ),
          itemBuilder: (context, index) {
            return CategoryCard(
              title: items[index]["title"]!,
              val: items[index]["val"]!,
            );
          },
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String val;

  const CategoryCard({super.key, required this.title, required this.val});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _PagePalette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _PagePalette.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14.5,
              color: _PagePalette.title,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _PagePalette.border),
              ),
              child: Text(
                val,
                style: const TextStyle(
                  color: _PagePalette.subtitle,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============ REPORTS WIDGET ============
class ReportsSection extends StatefulWidget {
  const ReportsSection({super.key});

  @override
  State<ReportsSection> createState() => _ReportsSectionState();
}

class _ReportsSectionState extends State<ReportsSection> {
  String _selectedFilter = "Tous les documents";
  final GlobalKey _buttonKey = GlobalKey();

  final List<String> _filterOptions = [
    "Tous les documents",
    "Ticket",
    "TicketMarker",
    "Rapport",
  ];

  void _showFilterMenu() {
    final RenderBox button =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height,
        offset.dx + button.size.width,
        offset.dy + button.size.height,
      ),
      items: _filterOptions.map((option) {
        return PopupMenuItem<String>(
          value: option,
          child: Row(
            children: [
              if (_selectedFilter == option)
                const Icon(Icons.check, size: 18, color: _PagePalette.primary),
              if (_selectedFilter == option) const SizedBox(width: 8),
              Text(
                option,
                style: TextStyle(
                  fontWeight: _selectedFilter == option
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: _selectedFilter == option
                      ? _PagePalette.primary
                      : _PagePalette.title,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ).then((value) {
      if (value != null && value is String) {
        setState(() {
          _selectedFilter = value;
        });
      }
    });
  }

  void _showDocumentMenu(String filename, String type) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.visibility_outlined,
                    color: _PagePalette.primary,
                  ),
                ),
                title: const Text(
                  "Aperçu",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Aperçu de $filename'),
                      backgroundColor: _PagePalette.primary,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.download_outlined,
                    color: Color(0xFF16A34A),
                  ),
                ),
                title: const Text(
                  "Télécharger",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Téléchargement de $filename'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _PagePalette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _PagePalette.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Rapports",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: _PagePalette.title,
                ),
              ),
              GestureDetector(
                key: _buttonKey,
                onTap: _showFilterMenu,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: _PagePalette.border),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _selectedFilter,
                        style: const TextStyle(
                          fontSize: 13,
                          color: _PagePalette.subtitle,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.unfold_more,
                        size: 16,
                        color: _PagePalette.subtitle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFilteredReports(),
        ],
      ),
    );
  }

  Widget _buildFilteredReports() {
    List<Map<String, String>> reports = [
      {
        "filename": "ordinateur.jpg",
        "subtitle": "Image - 07/04/2026 11:43",
        "type": "Ticket",
      },
      {
        "filename": "ordinateur.jpg",
        "subtitle": "Image - 07/04/2026 11:38",
        "type": "Ticket",
      },
      {
        "filename": "document.pdf",
        "subtitle": "PDF - 07/04/2026 10:00",
        "type": "Rapport",
      },
      {
        "filename": "marker.png",
        "subtitle": "Image - 07/04/2026 09:30",
        "type": "TicketMarker",
      },
    ];

    List<Map<String, String>> filteredReports = reports;

    if (_selectedFilter != "Tous les documents") {
      filteredReports = reports
          .where((report) => report["type"] == _selectedFilter)
          .toList();
    }

    if (filteredReports.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(Icons.folder_open, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                "Aucun document ${_selectedFilter != "Tous les documents" ? "de type $_selectedFilter" : ""}",
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: filteredReports.asMap().entries.map((entry) {
        int index = entry.key;
        var report = entry.value;
        return Column(
          children: [
            ReportItem(
              filename: report["filename"]!,
              subtitle: report["subtitle"]!,
              type: report["type"]!,
              onMenuTap: () =>
                  _showDocumentMenu(report["filename"]!, report["type"]!),
            ),
            if (index < filteredReports.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(height: 1, color: _PagePalette.border),
              ),
          ],
        );
      }).toList(),
    );
  }
}

class ReportItem extends StatelessWidget {
  final String filename;
  final String subtitle;
  final String type;
  final VoidCallback onMenuTap;

  const ReportItem({
    super.key,
    required this.filename,
    required this.subtitle,
    required this.type,
    required this.onMenuTap,
  });

  Color _getIconColor() {
    switch (type) {
      case "Ticket":
        return const Color(0xFF16A34A);
      case "TicketMarker":
        return const Color(0xFFD97706);
      case "Rapport":
        return const Color(0xFF1E40AF);
      default:
        return const Color(0xFF16A34A);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getIconColor().withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            type == "Ticket"
                ? Icons.description_outlined
                : type == "TicketMarker"
                ? Icons.flag_outlined
                : Icons.picture_as_pdf_outlined,
            color: _getIconColor(),
            size: 23,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                filename,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: _PagePalette.title,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: _PagePalette.subtitle,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getIconColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            type,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _getIconColor(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onMenuTap,
          child: Icon(Icons.more_horiz_rounded, color: Colors.grey.shade400),
        ),
      ],
    );
  }
}

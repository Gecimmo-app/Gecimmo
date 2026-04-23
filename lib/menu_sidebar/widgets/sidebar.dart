import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF6366F1);
const Color darkGrey = Color(0xFF374151);
const Color lightGrey = Color(0xFF6B7280);

class SidebarItem {
  final String title;
  final String? displayTitle;
  final IconData? icon;
  final List<SidebarItem>? children;
  bool isExpanded;

  SidebarItem({
    required this.title,
    this.displayTitle,
    this.icon,
    this.children,
    this.isExpanded = false,
  });

  String get name => displayTitle ?? title;
}

class Sidebar extends StatefulWidget {
  final AnimationController animationController;
  final VoidCallback onClose;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.animationController,
    required this.onClose,
    required this.onItemSelected,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  String selected = "Dashboard Principal";

  final List<SidebarItem> items = [
    SidebarItem(
      title: 'Dashbord',
      icon: Icons.grid_view,
      children: [
        SidebarItem(title: 'Dashboard Principal'),
        SidebarItem(title: 'Dashboard Observations', displayTitle: 'Dashboard Observations'),
        SidebarItem(title: 'Regression Constats'),
      ],
    ),
    SidebarItem(title: 'Visites', icon: Icons.explore),
    SidebarItem(title: 'Observations', icon: Icons.visibility),
    SidebarItem(title: 'Reclamation', icon: Icons.notifications_outlined),
    SidebarItem(title: 'Agenda', icon: Icons.calendar_month),
    SidebarItem(
      title: 'Reporting',
      icon: Icons.bar_chart,
      children: [
        SidebarItem(title: 'Livraison'),
        SidebarItem(title: 'Rapport Immeubles'),
      ],
    ),
    SidebarItem(
      title: 'Paramétrages',
      icon: Icons.settings,
      children: [
        SidebarItem(title: 'Emails'),
        SidebarItem(title: 'Emails par étape'),
        SidebarItem(
          title: 'Prestataires',
          children: [
            SidebarItem(title: 'Prestataires Emails'),
            SidebarItem(title: 'Liste des prestataires'),
          ],
        ),
        SidebarItem(title: 'Corps de métier'),
        SidebarItem(title: 'Localite'),
        SidebarItem(title: 'Switch Session'),
        SidebarItem(title: 'Configurations'),
        SidebarItem(title: 'Configurations Pv'),
        SidebarItem(title: 'Configurations Profil'),
        SidebarItem(title: 'Pilote Project'),
        SidebarItem(title: 'Agent De Livraison Project'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.75;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(widget.animationController),
      child: Material(
        elevation: 20,
        child: Container(
          width: width,
          color: Colors.white,
          child: Column(
            children: [
              _header(),
              Expanded(child: ListView(children: items.map(buildItem).toList())),
              _footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.bolt, color: primaryBlue, size: 24),
              const SizedBox(width: 8),
              const Text("SVA",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: darkGrey)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, color: darkGrey, size: 24),
            onPressed: widget.onClose,
          )
        ],
      ),
    );
  }

  Widget buildItem(SidebarItem item, {int depth = 0}) {
    final hasChildren = item.children != null;
    final isSelected = selected == item.name;

    double paddingLeft = depth == 0 ? 0 : 44.0;

    if (hasChildren) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: depth == 0 ? 16.0 : paddingLeft, right: 16.0),
            leading: item.icon != null ? Icon(item.icon, color: primaryBlue, size: 22) : null,
            title: Text(item.name, style: TextStyle(
              fontSize: depth == 0 ? 15 : 14,
              color: darkGrey,
              fontWeight: depth == 0 ? FontWeight.w500 : FontWeight.normal,
            )),
            trailing: Icon(
              item.isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
              color: lightGrey,
              size: 20,
            ),
            onTap: () {
              setState(() => item.isExpanded = !item.isExpanded);
            },
          ),
          if (item.isExpanded)
            Container(
              margin: const EdgeInsets.only(left: 28),
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Colors.grey.withOpacity(0.15), width: 1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: item.children!.map((child) => buildItem(child, depth: depth + 1)).toList(),
              ),
            ),
        ],
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() => selected = item.name);
          widget.onItemSelected(_index(item.name));
          widget.onClose();
        },
        child: Container(
          margin: depth == 0
              ? const EdgeInsets.symmetric(horizontal: 8, vertical: 2)
              : const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isSelected ? primaryBlue.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.only(left: depth == 0 ? 16.0 : 8.0, right: 16.0),
            leading: depth == 0
                ? (item.icon != null ? Icon(item.icon, size: 22, color: isSelected ? primaryBlue : primaryBlue.withOpacity(0.7)) : null)
                : Icon(Icons.circle, size: 8, color: isSelected ? primaryBlue : Colors.grey),
            minLeadingWidth: depth == 0 ? null : 16,
            title: Text(item.name, style: TextStyle(
              fontSize: depth == 0 ? 15 : 14,
              color: isSelected
                  ? primaryBlue
                  : (depth == 0 ? darkGrey : lightGrey),
              fontWeight: depth == 0 ? FontWeight.w500 : FontWeight.normal,
            )),
          ),
        ),
      ),
    );
  }

  // MATCHED TO HOME_PAGE INDEXES
  int _index(String t) {
    switch (t) {
      case 'Dashboard Principal': return 0;
      case 'Dashboard Observations': return 1;
      case 'Observations': return 4;
      case 'Regression Constats': return 2;
      case 'Visites': return 3;
      case 'Reclamation': return 5;
      case 'Agenda': return 6;
      case 'Livraison': return 7;
      case 'Rapport Immeubles': return 8;
      case 'Emails': return 9;
      case 'Emails par étape': return 10;
      case 'Prestataires': return 11;
      case 'Prestataires Emails': return 21;
      case 'Liste des prestataires': return 11;
      case 'Corps de métier': return 13;
      case 'Localite': return 14;
      case 'Switch Session': return 15;
      case 'Configurations': return 16;
      case 'Configurations Pv': return 17;
      case 'Configurations Profil': return 18;
      case 'Pilote Project': return 19;
      case 'Agent De Livraison Project': return 20;
      default: return 0;
    }
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: primaryBlue.withOpacity(0.1),
            child: Text("A", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text("Admin User",
              style: TextStyle(
                color: darkGrey,
                fontSize: 15,
                fontWeight: FontWeight.w500
              )
            ),
          ),
          Icon(Icons.logout, color: lightGrey, size: 20),
        ],
      ),
    );
  }
}
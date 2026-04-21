import 'package:flutter/material.dart';

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
  String selected = "Visites";

  final List<SidebarItem> items = [
    SidebarItem(title: 'Visites', icon: Icons.explore_outlined),
    SidebarItem(title: 'Observations', icon: Icons.visibility_outlined),
    SidebarItem(title: 'Reclamations', icon: Icons.report_outlined),
    SidebarItem(title: 'Agenda', icon: Icons.calendar_today_outlined),

    SidebarItem(
      title: 'Reporting',
      icon: Icons.bar_chart_outlined,
      isExpanded: true,
      children: [
        SidebarItem(title: 'Livraison', icon: Icons.circle),
        SidebarItem(title: 'Rapport Immeubles', icon: Icons.circle),
      ],
    ),

    SidebarItem(
      title: 'Parametrages',
      icon: Icons.settings_outlined,
      isExpanded: true,
      children: [
        SidebarItem(title: 'Agent Livraison', icon: Icons.circle),
        SidebarItem(title: 'Configurations', icon: Icons.circle),
        SidebarItem(title: 'Configurations Profil', icon: Icons.circle),
        SidebarItem(title: 'Configurations PV', icon: Icons.circle),
        SidebarItem(title: 'Pilote Project', icon: Icons.circle),
        SidebarItem(title: 'Switch Session', icon: Icons.circle),
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
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("SVA MENU",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue)),
          IconButton(
            icon: const Icon(Icons.close, color: primaryBlue),
            onPressed: widget.onClose,
          )
        ],
      ),
    );
  }

  Widget buildItem(SidebarItem item) {
    final hasChildren = item.children != null;
    final isSelected = selected == item.title;

    if (hasChildren) {
      return Column(
        children: [
          ListTile(
            leading: Icon(item.icon, color: primaryBlue),
            title: Text(item.title),
            trailing: IconButton(
              icon: Icon(item.isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
              onPressed: () {
                setState(() => item.isExpanded = !item.isExpanded);
              },
            ),
          ),
          if (item.isExpanded) ...item.children!.map(buildChild),
        ],
      );
    }

    return ListTile(
      leading: Icon(item.icon,
          color: isSelected ? primaryBlue : primaryBlue.withOpacity(0.5)),
      title: Text(item.title),
      onTap: () {
        setState(() => selected = item.title);
        widget.onItemSelected(_index(item.title));
        widget.onClose();
      },
    );
  }

  Widget buildChild(SidebarItem child) {
    final isSelected = selected == child.title;

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        leading: Icon(child.icon,
            size: 14,
            color: isSelected ? primaryBlue : primaryBlue.withOpacity(0.4)),
        title: Text(child.title,
            style: TextStyle(
                fontSize: 13,
                color: isSelected ? primaryBlue : Colors.black54)),
        onTap: () {
          setState(() => selected = child.title);
          widget.onItemSelected(_index(child.title));
          widget.onClose();
        },
      ),
    );
  }

  // 🔥 ONLY FIXED PART
  int _index(String t) {
    switch (t) {
      case 'Visites':
        return 0;
      case 'Observations':
        return 1;
      case 'Reclamations':
        return 2;
      case 'Agenda':
        return 3;

      case 'Livraison':
        return 4;
      case 'Rapport Immeubles':
        return 5;

      case 'Agent Livraison':
        return 6;
      case 'Configurations':
        return 7;
      case 'Configurations Profil':
        return 8;
      case 'Configurations PV':
        return 9;
      case 'Pilote Project':
        return 10;
      case 'Switch Session':
        return 11;

      default:
        return 0;
    }
  }

  Widget _footer() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(child: Text("A")),
          SizedBox(width: 10),
          Expanded(child: Text("Admin")),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF1E40AF);

class SidebarItem {
  final String title;
  final String? id; // Sert d'identifiant unique si plusieurs menus ont le même nom (ex: Emails)
  final IconData icon;
  final List<SidebarItem>? children;
  bool isExpanded;

  SidebarItem({
    required this.title,
    this.id,
    required this.icon,
    this.children,
    this.isExpanded = false,
  });
}

class Sidebar extends StatefulWidget {
  final AnimationController animationController;
  final VoidCallback onClose;
    final Function(String) onItemSelected; // 👈 الجديد

  const Sidebar({
    Key? key,
    required this.animationController,
    required this.onClose,
    required this.onItemSelected,
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
        SidebarItem(title: 'Observations (Dashboard)', icon: Icons.circle_outlined),
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
    SidebarItem(
      title: 'Paramétrages',
      icon: Icons.settings_outlined,
      isExpanded: false,
      children: [
        SidebarItem(title: 'Emails', icon: Icons.circle_outlined),
        SidebarItem(title: 'Emails par étape', icon: Icons.circle_outlined),
        SidebarItem(title: 'Corps de métier', icon: Icons.work_outline),
        SidebarItem(title: 'Localités', icon: Icons.location_on_outlined),
        SidebarItem(title: 'Utilisateurs', icon: Icons.group_outlined),
        SidebarItem(
          title: 'Prestataires',
          icon: Icons.business_outlined,
          isExpanded: false,
          children: [
            SidebarItem(title: 'Emails', id: 'Emails Prestataires', icon: Icons.circle_outlined),
            SidebarItem(title: 'Liste des prestataires', icon: Icons.circle_outlined),
          ],
        ),
      ],
    ),
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
    final isSelected = _selectedItem == (item.id ?? item.title);

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
        setState(() => _selectedItem = item.id ?? item.title);
        widget.onItemSelected(item.id ?? item.title);
        widget.onClose();
      },
    );
  }

  // 🔵 CHILD ITEM
  Widget _buildChild(SidebarItem child) {
    final hasChildren = child.children != null;
    final isSelected = _selectedItem == (child.id ?? child.title);

    if (hasChildren) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              leading: Icon(child.icon, size: 14, color: primaryBlue),
              title: Text(child.title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
              trailing: IconButton(
                icon: Icon(
                  child.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: primaryBlue,
                  size: 16,
                ),
                onPressed: () {
                  setState(() {
                    child.isExpanded = !child.isExpanded;
                  });
                },
              ),
            ),
          ),
          if (child.isExpanded)
            ...child.children!.map(_buildGrandChild),
        ],
      );
    }

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
          setState(() => _selectedItem = child.id ?? child.title);
          widget.onItemSelected(child.id ?? child.title);
          widget.onClose();
        },
      ),
    );
  }

  // 🔵 GRANDCHILD ITEM
  Widget _buildGrandChild(SidebarItem grandChild) {
    final isSelected = _selectedItem == (grandChild.id ?? grandChild.title);

    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: ListTile(
        leading: Icon(
          grandChild.icon,
          size: 8,
          color: isSelected ? primaryBlue : primaryBlue.withOpacity(0.4),
        ),
        title: Text(
          grandChild.title,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? primaryBlue : Colors.black54,
          ),
        ),
        onTap: () {
          setState(() => _selectedItem = grandChild.id ?? grandChild.title);
          widget.onItemSelected(grandChild.id ?? grandChild.title);
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
}
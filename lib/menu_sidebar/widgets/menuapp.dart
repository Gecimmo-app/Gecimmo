import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'package:geccimo/Agenda/agenda_page.dart';

// 📌 Paramétrages
import 'package:geccimo/Parametrages/agent_livraison_page.dart';
import 'package:geccimo/Parametrages/configurations_page.dart';
import 'package:geccimo/Parametrages/configurations_profil_page.dart';
import 'package:geccimo/Parametrages/configurations_pv_page.dart';
import 'package:geccimo/Parametrages/pilote_project_page.dart';
import 'package:geccimo/Parametrages/switch_session_page.dart';

// 📌 Reporting
import 'package:geccimo/Reporting/livraison_page.dart';
import 'package:geccimo/Reporting/rapport_immeubles_page.dart';

// 📌 Visites
import 'package:geccimo/Visites/visites_page.dart';

class MenuApp extends StatefulWidget {
  const MenuApp({super.key});

  @override
  State<MenuApp> createState() => _MenuAppState();
}

class _MenuAppState extends State<MenuApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  int selectedPage = 0;

  final List<Widget> pages = [
    const VisitesPage(),
    const Center(child: Text("Observations")),
    const Center(child: Text("Reclamations")),
    const AgendaPage(),

    const LivraisonPage(),
    const RapportImmeublesPage(),

    // 🟣 Paramétrages
    const AgentLivraisonPage(),
    const ConfigurationsPage(),
    const ConfigurationsProfilPage(),
    const ConfigurationsPvPage(),
    const PiloteProjectPage(),
    const SwitchSessionPage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void openMenu() {
    setState(() => _isOpen = true);
    _controller.forward();
  }

  Future<void> closeMenu() async {
    await _controller.reverse();
    if (mounted) setState(() => _isOpen = false);
  }

  void changePage(int index) {
    setState(() => selectedPage = index);
    closeMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        title: const Text("SAV"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: openMenu,
        ),
      ),
      body: Stack(
        children: [
          pages[selectedPage],

          if (_isOpen)
            GestureDetector(
              onTap: closeMenu,
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),

          if (_isOpen)
            Align(
              alignment: Alignment.centerLeft,
              child: Sidebar(
                animationController: _controller,
                onClose: closeMenu,
                onItemSelected: changePage,
              ),
            ),
        ],
      ),
    );
  }
}
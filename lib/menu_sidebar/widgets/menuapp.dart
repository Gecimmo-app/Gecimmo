import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'package:sav/Agenda/agenda_page.dart';

// 📌 Paramétrages
import 'package:sav/Parametrages/agent_livraison_page.dart';
import 'package:sav/Parametrages/configurations_page.dart';
import 'package:sav/Parametrages/configurations_profil_page.dart';
import 'package:sav/Parametrages/configurations_pv_page.dart';
import 'package:sav/Parametrages/pilote_project_page.dart';
import 'package:sav/Parametrages/Prestataires/EmailsPrest.dart';
import 'package:sav/Parametrages/switch_session_page.dart';

// 📌 Reporting
import 'package:sav/Reporting/livraison_page.dart';
import 'package:sav/Reporting/rapport_immeubles_page.dart';

// 📌 Visites
import 'package:sav/Visites/visites_page.dart';

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
    // 0..2 Dashboards
    const Center(child: Text("Dashboard Principal")),
    const Center(child: Text("Observations (Dashboard)")),
    const Center(child: Text("Regression Constats")),

    // 3..6 Main
    const VisitesPage(),
    const Center(child: Text("Observations")),
    const Center(child: Text("Reclamation")),
    const AgendaPage(),

    // 7..8 Reporting
    const LivraisonPage(),
    const RapportImmeublesPage(),

    // 9..20 Paramétrages
    const Center(child: Text("Emails")),
    const Center(child: Text("Emails par étape")),
    const Center(child: Text("Prestataires")),
    const Center(child: Text("Utilisateur")),
    const Center(child: Text("Corps de métier")),
    const Center(child: Text("Localite")),
    const SwitchSessionPage(),
    const ConfigurationsPage(),
    const ConfigurationsPvPage(),
    const ConfigurationsProfilPage(),
    const PiloteProjectPage(),
    const AgentLivraisonPage(),
    const EmailsPrestScreen(),
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
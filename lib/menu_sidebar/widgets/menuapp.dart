import 'package:flutter/material.dart';
import 'sidebar.dart';
// import 'dashbordprincpa.dart';
class MenuApp extends StatefulWidget {
  const MenuApp({super.key});

  @override
  State<MenuApp> createState() => _MenuAppState();
}

class _MenuAppState extends State<MenuApp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isOpen = false;

  int selectedPage = 0;

  final List<Widget> pages = [
    // const DashbordPrincpa(),
    const Center(child: Text("Visites")),
    const Center(child: Text("Observations")),
    const Center(child: Text("Reclamations")),
    const Center(child: Text("Agenda")),
    const Center(child: Text("Reporting")),
    const Center(child: Text("Settings")),
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
    setState(() {
      selectedPage = index;
    });
    closeMenu();
  }

  void _handlePersonIconTap() {
    // Action à exécuter quand l'icône person est tapée
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Profil"),
          content: const Text("Action de l'icône person"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
    // Vous pouvez aussi naviguer vers une page de profil:
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
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
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: _handlePersonIconTap,
            tooltip: 'Profil', // Texte qui apparaît au survol (optionnel)
          ),
        ],
      ),
      body: Stack(
        children: [
          pages[selectedPage],
          if (_isOpen)
            GestureDetector(
              onTap: closeMenu,
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          if (_isOpen)
            Align(
              alignment: Alignment.centerLeft,
              child: Sidebar(
                animationController: _controller,
                onClose: closeMenu,
              ),
            ),
        ],
      ),
    );
  }
}
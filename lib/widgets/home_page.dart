import 'package:flutter/material.dart';
import 'package:projet_sva/widgets/Dashbordprincpa.dart';
import '../widgets/RegressionConstats.dart';
import '../menu_sidebar/widgests/sidebar.dart';
import '../Observations.dart' as observations_page;
import 'DashboardObservations.dart' as dashboard_obs;
import '../screens/parametrage/Emails.dart';
import '../screens/parametrage/EmailsParEtape.dart';
import '../screens/parametrage/Prestataires/EmailsPrest.dart';
import '../screens/parametrage/Prestataires/ListePrestataires.dart';
import '../screens/parametrage/corps_de_metier_page.dart';
import '../screens/parametrage/localites_page.dart';
import '../screens/parametrage/utilisateurs/utilisateurs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  bool _isOpen = false;

  int selectedPage = 1;

  // 🔥 PAGES (SAV بدل Dashboard Principal)
  List<Widget> get pages => [
    const Center(child: Text("SAV")), // 0 👈 CHANGED HERE
    const DashbordPrincpa(), // 1
    const Center(child: Text("Visites")), // 2
    const dashboard_obs.ObservationsScreen(), // 3  -> Observations (sous Dashboard)
    const Center(child: Text("Reclamations")), // 4
    const Center(child: Text("Agenda")), // 5
    const Center(child: Text("Reporting")), // 6
    const DashboardScreen(), // 7 Regression Constats
    const observations_page.ObservationsScreen(), // 8  -> Observations (menu principal)
    const EmailsConfigScreen(), // 9 -> Emails
    const EmailsParEtapeScreen(), // 10 -> Emails par étape
    const EmailsPrestScreen(), // 11 -> Emails Prestataires
    const ListePrestatairesScreen(), // 12 -> Liste des prestataires
    const CorpsDeMetierScreen(), // 13 -> Corps de métier
    const LocalitesScreen(), // 14 -> Localités
    const UtilisateursScreen(), // 15 -> Utilisateurs
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
  backgroundColor: const Color(0xFF1E40AF),

  // 🔥 TITLE CENTER + WHITE
  title: const Text(
    "SAV",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
  ),
  centerTitle: true,

  leading: IconButton(
    icon: const Icon(Icons.menu, color: Colors.white),
    onPressed: openMenu,
  ),

  // 🔥 PERSON ACTION ADDED
  actions: [
    IconButton(
      icon: const Icon(Icons.person, color: Colors.white),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Profil"),
            content: const Text("Action de l'icône person"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Fermer"),
              ),
            ],
          ),
        );
      },
    ),
  ],
),

      body: Stack(
        children: [

          // 🔥 PAGE CONTENT
          pages[selectedPage],

          // 🔥 DARK OVERLAY
          if (_isOpen)
            GestureDetector(
              onTap: closeMenu,
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),

          // 🔥 SIDEBAR
          if (_isOpen)
            Align(
              alignment: Alignment.centerLeft,
              child: Sidebar(
                animationController: _controller,
                onClose: closeMenu,

                onItemSelected: (title) {
                  if (title == "SAV") changePage(0);
                  else if (title == "Dashboard Principal") changePage(1);
                  else if (title == "Visites") changePage(2);
                  else if (title == "Observations (Dashboard)") changePage(3);
                  else if (title == "Observations") changePage(8);
                  else if (title == "Reclamations") changePage(4);
                  else if (title == "Agenda") changePage(5);
                  else if (title == "Reporting") changePage(6);
                  else if (title == "Regression Constats") changePage(7);
                  else if (title == "Emails") changePage(9);
                  else if (title == "Emails par étape") changePage(10);
                  else if (title == "Emails Prestataires") changePage(11);
                  else if (title == "Liste des prestataires") changePage(12);
                  else if (title == "Corps de métier") changePage(13);
                  else if (title == "Localités") changePage(14);
                  else if (title == "Utilisateurs") changePage(15);
                },
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'Dashboard/Dashbordprincpa.dart';
import 'Dashboard/RegressionConstats.dart';
import '../menu_sidebar/widgets/sidebar.dart';
import 'Observations/Observations.dart' as observations_page;
import 'Dashboard/DashboardObservations.dart' as dashboard_obs;
import '../Parametrages/Emails.dart';
import '../Parametrages/EmailsParEtape.dart';
import '../Parametrages/Prestataires/ListePrestataires.dart';
import '../Parametrages/Prestataires/EmailsPrest.dart';
import '../Parametrages/corps_de_metier_page.dart';
import '../Parametrages/localites_page.dart';
import '../Parametrages/utilisateurs/utilisateurs_page.dart';
import '../Parametrages/switch_session_page.dart';
import '../Parametrages/configurations_page.dart';
import '../Parametrages/configurations_pv_page.dart';
import '../Parametrages/configurations_profil_page.dart';
import '../Parametrages/pilote_project_page.dart';
import '../Parametrages/agent_livraison_page.dart';
import '../Visites/visites_page.dart';
import '../Agenda/agenda_page.dart';
import '../Reporting/livraison_page.dart';
import '../Reporting/rapport_immeubles_page.dart';
import 'Ajouter_visite.dart';

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

  List<Widget> get pages => [
    const DashbordPrincpa(), // 0
    const dashboard_obs.ObservationsScreen(), // 1
    const DashboardScreen(), // 2
    const VisitesPage(), // 3
    const observations_page.ObservationsScreen(), // 4
    const Center(child: Text("Reclamation")), // 5
    const AgendaPage(), // 6
    const LivraisonPage(), // 7
    const RapportImmeublesPage(), // 8
    const EmailsConfigScreen(), // 9
    const EmailsParEtapeScreen(), // 10
    const ListePrestatairesScreen(), // 11
    const UtilisateursScreen(), // 12
    const CorpsDeMetierScreen(), // 13
    const LocalitesScreen(), // 14
    const SwitchSessionPage(), // 15
    const ConfigurationsPage(), // 16
    const ConfigurationsPvPage(), // 17
    const ConfigurationsProfilPage(), // 18
    const PiloteProjectPage(), // 19
    const AgentLivraisonPage(), // 20
    const EmailsPrestScreen(), // 21
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

                onItemSelected: (index) {
                  changePage(index);
                },
              ),
            ),
        ],
      ),
    );
  }
}

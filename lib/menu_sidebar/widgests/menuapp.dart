// import 'package:flutter/material.dart';
// import './sidebar.dart';
// import '../../widgets/Dashbordprincpa.dart';
// import '../../screens/parametrage/EmailsParEtape.dart';

// class MenuApp extends StatefulWidget {
//   const MenuApp({super.key});

//   @override
//   State<MenuApp> createState() => _MenuAppState();
// }

// class _MenuAppState extends State<MenuApp>
//     with SingleTickerProviderStateMixin {

//   late final AnimationController _controller;
//   bool _isOpen = false;

//   int selectedPage = 0;

//   // 🟢 PAGES LIST
//   final List<Widget> pages = [
//     const DashbordPrincpa(), // 0
//     const Center(child: Text("Visites")), // 1
//     const Center(child: Text("Observations")), // 2
//     const Center(child: Text("Reclamations")), // 3
//     const Center(child: Text("Agenda")), // 4
//     const Center(child: Text("Reporting")), // 5
//     const Center(child: Text("Settings")), // 6
//     const EmailsParEtape(), // 7
//     const Center(child: Text("Regression Constats")), // 8
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   // 🟢 OPEN MENU
//   void openMenu() {
//     setState(() => _isOpen = true);
//     _controller.forward();
//   }

//   // 🟢 CLOSE MENU
//   Future<void> closeMenu() async {
//     await _controller.reverse();
//     if (mounted) setState(() => _isOpen = false);
//   }

//   // 🟢 CHANGE PAGE
//   void changePage(int index) {
//     setState(() {
//       selectedPage = index;
//     });
//     closeMenu();
//   }

//   // 🟢 PROFILE ACTION
//   void _handlePersonIconTap() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Profil"),
//           content: const Text("Action de l'icône person"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Fermer"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1E40AF),
//         title: const Text("SAV"),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.menu, color: Colors.white),
//           onPressed: openMenu,
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person, color: Colors.white),
//             onPressed: _handlePersonIconTap,
//           ),
//         ],
//       ),

//       body: Stack(
//         children: [

//           // 🟢 PAGE DISPLAY
//           pages[selectedPage],

//           // 🟢 DARK OVERLAY
//           if (_isOpen)
//             GestureDetector(
//               onTap: closeMenu,
//               child: Container(
//                 color: Colors.black.withOpacity(0.4),
//               ),
//             ),

//           // 🟢 SIDEBAR
//           if (_isOpen)
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Sidebar(
//                 animationController: _controller,
//                 onClose: closeMenu,

//                 // 🔥 NAVIGATION CORE
//                 onItemSelected: (title) {
//                   if (title == "Dashboard Principal") changePage(0);
//                   else if (title == "Visites") changePage(1);
//                   else if (title == "Observations") changePage(2);
//                   else if (title == "Reclamations") changePage(3);
//                   else if (title == "Agenda") changePage(4);
//                   else if (title == "Reporting") changePage(5);
//                   else if (title == "Parametrages") changePage(6);
//                   else if (title == "Regression Constats") changePage(7);
//                   else if (title == "Emails par étape") changePage(8);
//                 },
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
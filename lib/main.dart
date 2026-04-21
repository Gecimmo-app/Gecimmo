import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import 'menu_sidebar/widgets/menuapp.dart';
=======
import './widgets/home_page.dart';
>>>>>>> feature/dashboard-Emails-observations-parametrages
=======
import 'package:geccimo/menu_sidebar/widgets/menuapp.dart';  // Importez la page que vous voulez afficher

>>>>>>> feature-visites-parametres-agenda
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geccimo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E40AF),
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
<<<<<<< HEAD
<<<<<<< HEAD
      home: const MenuApp(),
=======
      home: MenuApp(),  // ← Enlevez le 'const' ici
>>>>>>> feature-visites-parametres-agenda
    );
  }
}
=======
      home: const HomePage(),
    );
  }
} 
>>>>>>> feature/dashboard-Emails-observations-parametrages

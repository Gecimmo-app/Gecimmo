import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
import 'menu_sidebar/widgets/menuapp.dart';
=======
import './widgets/home_page.dart';
>>>>>>> feature/dashboard-Emails-observations-parametrages
=======
import 'package:geccimo/menu_sidebar/widgets/menuapp.dart';  // Importez la page que vous voulez afficher

>>>>>>> feature-visites-parametres-agenda
=======
import './widgets/home_page.dart';
>>>>>>> feature/dashboard-Emails-observations-parametrages
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
<<<<<<< HEAD
  const MyApp({super.key});
=======
  const MyApp({Key? key}) : super(key: key);
>>>>>>> feature/dashboard-Emails-observations-parametrages

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
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
=======
      title: 'SVA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
      home: const HomePage(),
    );
  }
} 
>>>>>>> feature/dashboard-Emails-observations-parametrages

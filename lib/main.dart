import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'menu_sidebar/widgets/menuapp.dart';
=======
import './widgets/home_page.dart';
>>>>>>> feature/dashboard-Emails-observations-parametrages
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SVA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),
<<<<<<< HEAD
      home: const MenuApp(),
    );
  }
}
=======
      home: const HomePage(),
    );
  }
} 
>>>>>>> feature/dashboard-Emails-observations-parametrages

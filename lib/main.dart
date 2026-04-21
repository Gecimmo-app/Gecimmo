import 'package:flutter/material.dart';
import 'package:geccimo/menu_sidebar/widgets/menuapp.dart';  // Importez la page que vous voulez afficher

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
      home: MenuApp(),  // ← Enlevez le 'const' ici
    );
  }
}
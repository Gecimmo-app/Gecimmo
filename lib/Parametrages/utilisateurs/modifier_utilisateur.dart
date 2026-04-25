import 'package:flutter/material.dart';
import 'utilisateurs_page.dart'; // Pour UtilisateurData

class ModifierUtilisateurScreen extends StatefulWidget {
  final UtilisateurData initial;

  const ModifierUtilisateurScreen({super.key, required this.initial});

  @override
  State<ModifierUtilisateurScreen> createState() => _ModifierUtilisateurScreenState();
}

class _ModifierUtilisateurScreenState extends State<ModifierUtilisateurScreen> {
  static const Color _primaryBlue = Color(0xFF1E40AF); // Bleu élégant et moderne
  static const Color _bgLight = Color(0xFFEFF6FF);
  static const Color _textTitle = Color(0xFF0F172A);
  static const Color _textSubtitle = Color(0xFF64748B);
  
  late final TextEditingController _nomCtrl;
  late final TextEditingController _loginCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.initial.nomComplet);
    _loginCtrl = TextEditingController(text: widget.initial.role == 'Admin' ? 'Admin' : widget.initial.nomComplet);
    _emailCtrl = TextEditingController(text: widget.initial.email);
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _loginCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Interface pensée pour un style mobile : éléments verticaux, grandes zones de clic, ombres douces.
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Modifier le profil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Avatar (Touche très pro pour le mobile)
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _primaryBlue.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Center(
                  child: Text(
                    _nomCtrl.text.isNotEmpty ? _nomCtrl.text[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: _primaryBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 2. Section Formulaire (Style carte avec ombres)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Nom Complet'),
                    _buildTextField(
                      controller: _nomCtrl,
                      icon: Icons.person_outline,
                      hint: 'Entrez le nom complet',
                    ),
                    const SizedBox(height: 24),
                    
                    _buildLabel('Login'),
                    _buildTextField(
                      controller: _loginCtrl,
                      icon: Icons.badge_outlined,
                      hint: 'Entrez le login',
                    ),
                    const SizedBox(height: 24),
                    
                    _buildLabel('Adresse Email'),
                    _buildTextField(
                      controller: _emailCtrl,
                      icon: Icons.email_outlined,
                      hint: 'Entrez l\'email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // 3. Boutons d'Action (Superposés pour le mobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: _primaryBlue.withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Enregistrer les modifications',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Action reset pwd
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: _primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: _primaryBlue.withOpacity(0.3), width: 1.5),
                      ),
                      backgroundColor: _primaryBlue.withOpacity(0.05),
                    ),
                    child: const Text(
                      'Réinitialiser le mot de passe',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Sous-composant pour le label du champ
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _textTitle,
        ),
      ),
    );
  }

  // Sous-composant pour les champs de texte
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _bgLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: _textTitle,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _textSubtitle, fontSize: 14, fontWeight: FontWeight.w400),
          prefixIcon: Icon(icon, color: _primaryBlue.withOpacity(0.7), size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _primaryBlue, width: 1.5),
          ),
        ),
      ),
    );
  }
}

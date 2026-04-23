import 'package:flutter/material.dart';
import 'utilisateurs_page.dart'; // Pour UtilisateurData

class ModifierUtilisateurScreen extends StatefulWidget {
  final UtilisateurData initial;

  const ModifierUtilisateurScreen({super.key, required this.initial});

  @override
  State<ModifierUtilisateurScreen> createState() => _ModifierUtilisateurScreenState();
}

class _ModifierUtilisateurScreenState extends State<ModifierUtilisateurScreen> {
  static const Color _primaryBlue = Color(0xFF3B82F6);
  static const Color _pageBg = Color(0xFFF8FAFC);
  static const Color _textTitle = Color(0xFF1D2939);
  static const Color _textMuted = Color(0xFF667085);
  static const Color _border = Color(0xFFEAECF0);

  late final TextEditingController _nomCtrl;
  late final TextEditingController _loginCtrl;
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _nomCtrl = TextEditingController(text: widget.initial.nomComplet);
    // On n'a pas gardé le "Login" exact dans le modèle UtilisateurData, on utilise le rôle pour le dummy UI ou just 'Admin'
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
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: _textTitle),
        title: const Text(
          'Modifier l\'utilisateur',
          style: TextStyle(
            color: _textTitle,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildField('Nom Complet', TextField(
                      controller: _nomCtrl,
                      decoration: _inputDeco(''),
                    )),
                    const SizedBox(height: 20),
                    _buildField('Login', TextField(
                      controller: _loginCtrl,
                      decoration: _inputDeco(''),
                    )),
                    const SizedBox(height: 20),
                    _buildField('Email', TextField(
                      controller: _emailCtrl,
                      decoration: _inputDeco(''),
                    )),
                  ],
                ),
              ),
              Container(height: 1, color: _border),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // Action reset pwd
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _textTitle,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: const BorderSide(color: _border),
                        backgroundColor: const Color(0xFFF9FAFB),
                      ),
                      child: const Text('Réinitialiser le mot de passe', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Enregistrer', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, Widget child) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _textTitle.withValues(alpha: 0.85)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: child),
      ],
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: _textMuted.withValues(alpha: 0.6)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _primaryBlue, width: 1.5),
      ),
    );
  }
}

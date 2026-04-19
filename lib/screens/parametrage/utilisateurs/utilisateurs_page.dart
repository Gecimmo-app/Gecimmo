import 'package:flutter/material.dart';
import 'ajouter_utilisateur.dart';
import 'modifier_utilisateur.dart';

class UtilisateurData {
  final String id;
  final String nomComplet;
  final String role;
  final String email;

  const UtilisateurData({
    required this.id,
    required this.nomComplet,
    required this.role,
    required this.email,
  });
}

class UtilisateursScreen extends StatefulWidget {
  const UtilisateursScreen({super.key});

  @override
  State<UtilisateursScreen> createState() => _UtilisateursScreenState();
}

class _UtilisateursScreenState extends State<UtilisateursScreen> {
  static const Color _primaryBlue = Color(0xFF1E40AF);
  static const Color _pageBg = Color(0xFFF8FAFC);
  static const Color _textTitle = Color(0xFF1D2939);
  static const Color _textMuted = Color(0xFF667085);
  static const Color _border = Color(0xFFEAECF0);

  final List<UtilisateurData> _items = [
    const UtilisateurData(id: '1', nomComplet: 'admin user', role: 'Admin', email: 'hibarostom1999@gmail.com'),
    const UtilisateurData(id: '2', nomComplet: 'utilisateur10013', role: 'commercial', email: 'hibarostom1999@gmail.com'),
    const UtilisateurData(id: '3', nomComplet: 'utilisateur10014', role: 'ADV', email: 'hibarostom1999@gmail.com'),
    const UtilisateurData(id: '4', nomComplet: 'utilisateur10015', role: 'Comptable', email: 'hibarostom1999@gmail.com'),
    const UtilisateurData(id: '5', nomComplet: 'utilisateur10016', role: 'Recouvrement', email: 'hibarostom1999@gmail.com'),
    const UtilisateurData(id: '6', nomComplet: 'utilisateur10017', role: 'SI', email: 'hibarostom1999@gmail.com'),
    const UtilisateurData(id: '7', nomComplet: 'utilisateur10023', role: 'Marketing', email: 'hibarostom1999@gmail.com'),
    const UtilisateurData(id: '8', nomComplet: 'utilisateur10028', role: 'responsable commercial', email: 'hibarostom1999@gmail.com'),
  ];

  void _navToAjouter() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AjouterUtilisateurScreen()),
    );
  }

  void _navToModifier(UtilisateurData u) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ModifierUtilisateurScreen(initial: u)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeaderRow(context),
                    const SizedBox(height: 32),
                    _buildGrid(constraints.maxWidth),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 600;
    
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Utilisateur',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _textTitle,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Paramétrez les utilisateurs',
          style: TextStyle(
            fontSize: narrow ? 13 : 14,
            height: 1.35,
            color: _textMuted.withValues(alpha: 0.95),
          ),
        ),
      ],
    );

    final addBtn = ElevatedButton(
      onPressed: _navToAjouter,
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        'Ajouter un utilisateur',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );

    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleBlock,
          const SizedBox(height: 16),
          Align(alignment: Alignment.centerLeft, child: addBtn),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        titleBlock,
        addBtn,
      ],
    );
  }

  Widget _buildGrid(double maxWidth) {
    final narrow = maxWidth < 800; // Breakpoint for 2 columns

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: _items.map((u) {
        final cardWidth = narrow ? maxWidth : (maxWidth - 24) / 2;
        return SizedBox(
          width: cardWidth,
          child: _buildUserCard(u),
        );
      }).toList(),
    );
  }

  Widget _buildUserCard(UtilisateurData user) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          // Haut de la carte : Infos
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Text(
                  user.nomComplet,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2939),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_outline, size: 16, color: _textMuted.withValues(alpha: 0.8)),
                        const SizedBox(width: 6),
                        Text(
                          user.role,
                          style: TextStyle(fontSize: 13, color: _textMuted.withValues(alpha: 0.9)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mail_outline, size: 16, color: _textMuted.withValues(alpha: 0.8)),
                        const SizedBox(width: 6),
                        Text(
                          user.email,
                          style: TextStyle(fontSize: 13, color: _textMuted.withValues(alpha: 0.9)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Ligne de séparation
          Container(height: 1, color: _border.withValues(alpha: 0.8)),
          
          // Bas de la carte : Actions
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () {}, // Action détail non spécifiée
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('Détail', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _textTitle,
                    side: BorderSide(color: _border),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _navToModifier(user),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Modifier', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6), // Bleu plus clair comme sur la maquette
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

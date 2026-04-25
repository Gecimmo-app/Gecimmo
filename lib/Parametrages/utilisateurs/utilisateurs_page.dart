import 'package:flutter/material.dart';
import 'ajouter_utilisateur.dart';
import 'modifier_utilisateur.dart';
import 'detail_utilisateur.dart';
import '../../widgets/Ajouter_visite.dart';

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
  static const Color _pageBg = Color(0xFFEFF6FF);
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

  void _navToDetail(UtilisateurData u) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetailUtilisateurScreen(utilisateur: u)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddVisitFlow(),
              ),
            );
          },
          backgroundColor: const Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          elevation: 6,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Utilisateurs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Paramétrez et gérez les accès de vos utilisateurs.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: _navToAjouter,
          icon: const Icon(Icons.add, size: 18),
          label: const Text(
            'Ajouter un utilisateur',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E40AF),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(double maxWidth) {
    final narrow = maxWidth < 700; 

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
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFEFF6FF),
                  radius: 24,
                  child: Text(
                    user.nomComplet.isNotEmpty ? user.nomComplet.substring(0, 1).toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Color(0xFF3B82F6), 
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.nomComplet,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          user.role,
                          style: const TextStyle(
                            fontSize: 12, 
                            fontWeight: FontWeight.w600, 
                            color: Color(0xFF475569)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.mail_outline, size: 16, color: Color(0xFF94A3B8)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user.email,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _navToDetail(user),
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('Détails'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF475569),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _navToModifier(user),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Modifier'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

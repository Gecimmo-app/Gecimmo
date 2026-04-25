import 'package:flutter/material.dart';
import 'Ajouter_prestataire.dart';

class ListePrestatairesScreen extends StatelessWidget {
  const ListePrestatairesScreen({Key? key}) : super(key: key);

  static const Color _primaryBlue = Color(0xFF1E40AF);
  static const Color _textTitle = Color(0xFF1D2939);
  static const Color _textMuted = Color(0xFF667085);

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFEFF6FF);

    // Données fictives
    final List<Map<String, String>> prestataires = [
      {
        'nom': 'Prestataire 1',
        'ice': 'IC-459021',
        'raisonSociale': 'Nextorch Industries',
        'adresse': '123 Avenue Mohamed V, Casablanca',
        'email': 'nextorchq@gmail.com',
      },
      {
        'nom': 'Tech Services SARL',
        'ice': 'IC-993812',
        'raisonSociale': 'Tech Services',
        'adresse': '45 Rue Hassan II, Rabat',
        'email': 'contact@techservices.com',
      },
    ];

    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = screenWidth > 800 ? 380.0 : double.infinity;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderRow(context),
              const SizedBox(height: 24),
              
              // 🔵 Grid of Cards
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: prestataires.map((p) => _buildModernCard(context, p, cardWidth)).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Même logique que [CorpsDeMetierScreen] : titre + sous-titre + bouton bleu aligné.
  Widget _buildHeaderRow(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final narrow = w < 520;

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Liste des prestataires',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _textTitle,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Gérez et paramétrez vos agences et prestataires',
          style: TextStyle(
            fontSize: narrow ? 13 : 14,
            height: 1.35,
            color: _textMuted.withValues(alpha: 0.95),
          ),
        ),
      ],
    );

    final addBtn = ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AjouterPrestataireScreen()),
        );
      },
      icon: const Icon(Icons.add_rounded, size: 20),
      label: const Text(
        'Ajouter un prestataire',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleBlock,
          const SizedBox(height: 16),
          addBtn,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: titleBlock),
        const SizedBox(width: 16),
        addBtn,
      ],
    );
  }

  Widget _buildModernCard(BuildContext context, Map<String, String> p, double cardWidth) {
    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top section: Avatar + Name
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFEFF6FF),
                      child: Text(
                        p['nom']!.substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: _primaryBlue, fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p['nom']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p['raisonSociale']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 28),
                
                // Info sections
                _buildInfoRow(Icons.mail_rounded, p['email']!),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.location_on_rounded, p['adresse']!),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.badge_rounded, 'ICE: ${p['ice']}'),
              ],
            ),
          ),
          
          const Divider(color: Color(0xFFEFF6FF), height: 1, thickness: 1),
          
          // Footer action
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AjouterPrestataireScreen(prestataire: p)),
              );
            },
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: const Text(
                'Modifier le prestataire',
                style: TextStyle(
                  color: _primaryBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

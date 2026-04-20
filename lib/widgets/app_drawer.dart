import 'package:flutter/material.dart';
import '../pages/reclamations_page.dart';
import '../pages/Login_page.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _selectedItem = 'Welcome';
  bool _crmExpanded = true;
  bool _advExpanded = false;
  bool _afterSalesExpanded = false;

  static const _primaryBlack = Color(0xFF000000);
  static const _primaryWhite = Color(0xFFFFFFFF);
  static const _grayLight = Color(0xFFF5F5F5);
  static const _grayMedium = Color(0xFFE0E0E0);
  static const _grayDark = Color(0xFF424242);
  static const _textDark = Color(0xFF212121);
  static const _textLight = Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 270,
      backgroundColor: _primaryWhite,
      child: Column(
        children: [
          // ── Logo Header ──
          Container(
            margin: const EdgeInsets.only(top: 30), 
            width: 140,
            height: 90,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/image/logo.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 15),

          // ── Menu List ──
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: _primaryWhite),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  // Section label
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    child: Text(
                      'GECIMMO',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _textLight,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  // ── CRM ──
                  _buildGroupHeader(
                    label: 'CRM',
                    icon: Icons.people_outline,
                    isExpanded: _crmExpanded,
                    onTap: () => setState(() => _crmExpanded = !_crmExpanded),
                  ),
                  if (_crmExpanded) ...[
                    _buildMenuItem(
                      'Welcome',
                      Icons.home_outlined,
                      onTap: () => _navigateTo(context, 'Welcome'),
                    ),
                    _buildMenuItem(
                      'Agenda',
                      Icons.calendar_month_outlined,
                      onTap: () => _navigateTo(context, 'Agenda'),
                    ),
                    _buildMenuItem(
                      'Leads',
                      Icons.person_add_outlined,
                      onTap: () => _navigateTo(context, 'Leads'),
                    ),
                    _buildMenuItem(
                      'Nouvel appel prospect',
                      Icons.phone_forwarded_outlined,
                      onTap: () => _navigateTo(context, 'Nouvel appel prospect'),
                    ),
                    _buildMenuItem(
                      'Réaffectation',
                      Icons.swap_horiz,
                      hasArrow: true,
                      onTap: () => _navigateTo(context, 'Réaffectation'),
                    ),

                    // ✅ Réclamations avec navigation
                    _buildMenuItem(
                      'Réclamations',
                      Icons.description_outlined,
                      onTap: () {
                        setState(() => _selectedItem = 'Réclamations');
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReclamationsPage(),
                          ),
                        );
                      },
                    ),

                    _buildMenuItem(
                      'Rapports',
                      Icons.bar_chart_outlined,
                      onTap: () => _navigateTo(context, 'Rapports'),
                    ),
                    _buildMenuItem(
                      'Paramétrage',
                      Icons.settings_outlined,
                      onTap: () => _navigateTo(context, 'Paramétrage'),
                    ),
                  ],

                  const SizedBox(height: 6),

                  // ── ADV ──
                  _buildGroupHeader(
                    label: 'ADV',
                    icon: Icons.article_outlined,
                    isExpanded: _advExpanded,
                    onTap: () => setState(() => _advExpanded = !_advExpanded),
                  ),
                  if (_advExpanded) ...[
                    _buildMenuItem(
                      'Contrats',
                      Icons.assignment_outlined,
                      onTap: () => _navigateTo(context, 'Contrats'),
                    ),
                    _buildMenuItem(
                      'Factures',
                      Icons.receipt_outlined,
                      onTap: () => _navigateTo(context, 'Factures'),
                    ),
                  ],

                  const SizedBox(height: 6),

                  // ── After-sales ──
                  _buildGroupHeader(
                    label: 'After-sales service',
                    icon: Icons.support_agent_outlined,
                    isExpanded: _afterSalesExpanded,
                    onTap: () => setState(() => _afterSalesExpanded = !_afterSalesExpanded),
                  ),
                  if (_afterSalesExpanded) ...[
                    _buildMenuItem(
                      'Tickets',
                      Icons.confirmation_number_outlined,
                      onTap: () => _navigateTo(context, 'Tickets'),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── User Footer ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            decoration: const BoxDecoration(
              color: _primaryWhite,
              border: Border(
                top: BorderSide(color: _grayMedium, width: 1),
              ),
            ),
            child: GestureDetector(
              onTap: () => _showProfileCard(context),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: _grayLight,
                    child: const Icon(Icons.person, color: _primaryBlack, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'riahi Marouane',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _textDark,
                          ),
                        ),
                        Text(
                          'Super Admin',
                          style: TextStyle(fontSize: 11, color: _textLight),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: _textLight, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Navigation par défaut ──
  void _navigateTo(BuildContext context, String label) {
    setState(() => _selectedItem = label);
    Navigator.pop(context);
  }

  // ── Popup Profil / Déconnexion ──
  void _showProfileCard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _primaryWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            // Avatar + info
            CircleAvatar(
              radius: 30,
              backgroundColor: _grayLight,
              child: const Icon(Icons.person, color: _primaryBlack, size: 30),
            ),
            const SizedBox(height: 10),
            const Text(
              'riahi Marouane',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
            const Text(
              'Super Admin',
              style: TextStyle(fontSize: 13, color: _textLight),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: _grayMedium),

            // Mon Profil
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _grayLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_outline, color: _primaryBlack, size: 20),
              ),
              title: const Text(
                'Mon Profil',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _textDark,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: _textLight, size: 20),
              onTap: () {
                Navigator.pop(ctx);
                // TODO: naviguer vers la page profil
              },
            ),

            // Déconnexion
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _grayLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.logout, color: _primaryBlack, size: 20),
              ),
              title: const Text(
                'Déconnexion',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _textDark,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: _textLight, size: 20),
              onTap: () async {
                Navigator.pop(ctx); // fermer le popup
                Navigator.pop(context); // fermer le drawer
                await AuthService().logout();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Group Header ──
  Widget _buildGroupHeader({
    required String label,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _grayLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: _primaryBlack),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
            ),
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 18,
              color: _primaryBlack,
            ),
          ],
        ),
      ),
    );
  }

  // ── Menu Item ──
  Widget _buildMenuItem(
    String label,
    IconData icon, {
    bool hasArrow = false,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedItem == label;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _grayLight : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? _primaryBlack : _textLight,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? _textDark : _textLight,
                ),
              ),
            ),
            if (hasArrow)
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: _textLight,
              ),
          ],
        ),
      ),
    );
  }
}
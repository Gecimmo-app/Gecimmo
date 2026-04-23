import 'package:flutter/material.dart';
import '../widgets/ui_components/modern_ui_components.dart';
import '../widgets/Ajouter_visite.dart' hide AppTheme;

class SwitchSessionPage extends StatefulWidget {
  const SwitchSessionPage({super.key});

  @override
  State<SwitchSessionPage> createState() => _SwitchSessionPageState();
}

class _SwitchSessionPageState extends State<SwitchSessionPage> {

  final TextEditingController _searchController = TextEditingController();

  final List<_SessionUser> _users = <_SessionUser>[
    const _SessionUser(
      name: 'admin user',
      email: 'admin@geccimo.com',
      description: 'Administrateur principal',
      isActive: true,
    ),
    const _SessionUser(
      name: 'utilisateur10013',
      email: 'utilisateur10013@geccimo.com',
      description: 'Opérateur terrain',
    ),
    const _SessionUser(
      name: 'SAV - Agent technique',
      email: 'sav.technique@geccimo.com',
      description: 'Support SAV',
    ),
  ];

  String _searchQuery = '';

  List<_SessionUser> get _filteredUsers {
    final String query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return _users;
    }

    return _users.where((_SessionUser user) {
      return user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          user.description.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<_SessionUser> usersToDisplay = _filteredUsers;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddVisitFlow()),
            );
          },
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Gestion des Utilisateurs',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Cliquez sur "Se connecter" pour vous connecter en tant qu\'un autre utilisateur',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              ModernInput(
                hint: 'Rechercher par nom, email, description...',
                prefixIcon: Icons.search,
                controller: _searchController,
                onChanged: (String value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: AppTheme.spacingSmall),
              Text(
                '${usersToDisplay.length} utilisateur(s) trouvé(s)',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: AppTheme.spacingMedium),
              Expanded(
                child: ListView.separated(
                  itemCount: usersToDisplay.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (BuildContext context, int index) {
                    final _SessionUser user = usersToDisplay[index];
                    return _buildUserCard(user);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(_SessionUser user) {
    return ModernCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: <Widget>[
          ModernAvatar(
            name: user.name,
            size: 44,
            backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
          ),
          const SizedBox(width: AppTheme.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                if (user.description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    user.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingSmall),
          user.isActive ? _buildConnectedBadge() : _buildConnectButton(),
        ],
      ),
    );
  }

  Widget _buildConnectedBadge() {
    return ModernBadge(
      text: 'Connecté',
      type: BadgeType.secondary,
      size: BadgeSize.medium,
    );
  }

  Widget _buildConnectButton() {
    return ModernButton(
      text: 'Se connecter',
      icon: Icons.login_rounded,
      onPressed: () {},
      size: ButtonSize.small,
    );
  }
}

class _SessionUser {
  const _SessionUser({
    required this.name,
    required this.email,
    required this.description,
    this.isActive = false,
  });

  final String name;
  final String email;
  final String description;
  final bool isActive;
}

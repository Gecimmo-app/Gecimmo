import 'package:flutter/material.dart';

class SwitchSessionPage extends StatefulWidget {
  const SwitchSessionPage({super.key});

  @override
  State<SwitchSessionPage> createState() => _SwitchSessionPageState();
}

class _SwitchSessionPageState extends State<SwitchSessionPage> {
  static const Color _primaryBlue = Color(0xFF1E40AF);

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
      backgroundColor: const Color(0xFFF8FAFC),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: _primaryBlue,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Gestion des Utilisateurs',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'Cliquez sur "Se connecter" pour vous connecter en tant qu\'un autre utilisateur',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _searchController,
                onChanged: (String value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Rechercher par nom, email, description...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _primaryBlue, width: 1.4),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${usersToDisplay.length} utilisateur(s) trouvé(s)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
              ),
              const SizedBox(height: 12),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFE0EEFF),
            child: Icon(
              Icons.person_outline_rounded,
              color: _primaryBlue.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              user.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 8),
          user.isActive ? _buildConnectedBadge() : _buildConnectButton(),
        ],
      ),
    );
  }

  Widget _buildConnectedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.check_circle_outline, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(
            'Connecté',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectButton() {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: const Icon(Icons.login_rounded, size: 18),
      label: const Text(
        'Se connecter',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
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

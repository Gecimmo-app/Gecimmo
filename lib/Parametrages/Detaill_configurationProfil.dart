import 'package:flutter/material.dart';

class DettailPage extends StatefulWidget {
  final String? roleId;
  final String? roleName;

  const DettailPage({super.key, this.roleId, this.roleName});

  @override
  State<DettailPage> createState() => _DettailPageState();
}

class _DettailPageState extends State<DettailPage> {
  List<String> _allProjects = [
    'Projet1',
    'Projet2',
    'Projet3',
    'Projet4',
    'Projet5',
    'Projet6',
    'Projet7',
  ];
  List<String> _selectedProjects = ['Projet1', 'Projet3', 'Projet5', 'Projet7'];

  List<Map<String, dynamic>> formRights = [
    {
      'formulaire': 'Visites',
      'description': 'Visites SAV',
      'consulter': false,
      'ajouter': false,
      'modifier': false,
      'supprimer': false,
    },
    {
      'formulaire': 'Tickets',
      'description': 'Tickets SAV',
      'consulter': false,
      'ajouter': false,
      'modifier': false,
      'supprimer': false,
    },
    {
      'formulaire': 'Tickets SAV',
      'description': 'Consultation des Tickets et Objets de Service (TSOS) SAV',
      'consulter': false,
      'ajouter': false,
      'modifier': false,
      'supprimer': false,
    },
    {
      'formulaire': 'Agenda SAV',
      'description': 'Gestion des réunions et du suivi SAV',
      'consulter': false,
      'ajouter': false,
      'modifier': false,
      'supprimer': false,
    },
    {
      'formulaire': 'Reclamations SAV',
      'description': 'Gérer les réclamations SAV',
      'consulter': false,
      'ajouter': false,
      'modifier': false,
      'supprimer': false,
    },
    {
      'formulaire': 'Prestataires',
      'description': 'Gestion des prestataires',
      'consulter': false,
      'ajouter': false,
      'modifier': false,
      'supprimer': false,
    },
    {
      'formulaire': 'Parametrage SAV',
      'description': 'Paramétrages des listes SAV',
      'consulter': false,
      'ajouter': false,
      'modifier': false,
      'supprimer': false,
    },
    {
      'formulaire': 'Utilisateur SAV',
      'description': 'Gestion des utilisateurs',
      'consulter': false,
      'ajouter': false,
      'modifier': false,
      'supprimer': false,
    },
    {
      'formulaire': 'Dashboards SAV',
      'description': 'Consultation des Dashboards SAV',
      'consulter': false,
      'ajouter': false,
      'modifier': false,
      'supprimer': false,
    },
  ];

  List<Map<String, dynamic>> specialRights = [
    {
      'cle': '6000001',
      'droit': 'RealiserObservation',
      'cleFormulaire': '6000002',
      'description': 'Réaliser une observation',
      'active': false,
    },
    {
      'cle': '6000002',
      'droit': 'AcceptObservation',
      'cleFormulaire': '6000002',
      'description': 'Accepter une observation',
      'active': false,
    },
    {
      'cle': '6000003',
      'droit': 'RefusObservation',
      'cleFormulaire': '6000002',
      'description': 'Refuser une observation',
      'active': false,
    },
    {
      'cle': '6000004',
      'droit': 'PlanificationTravaux',
      'cleFormulaire': '6000002',
      'description': 'Planification Travaux',
      'active': false,
    },
    {
      'cle': '6000006',
      'droit': 'PlanificationTravauxObservation',
      'cleFormulaire': '6000002',
      'description': 'Planification travaux de l\'observation',
      'active': false,
    },
    {
      'cle': '6000012',
      'droit': 'CommercialConsulteDetail',
      'cleFormulaire': '1000000000',
      'description':
          'Les commerciaux peuvent accéder uniquement à la reclamation',
      'active': false,
    },
    {
      'cle': '6000013',
      'droit': 'Add',
      'cleFormulaire': '1000000000',
      'description': 'Peuvent ajouter la reclamation',
      'active': false,
    },
    {
      'cle': '6000014',
      'droit': 'Edit',
      'cleFormulaire': '1000000000',
      'description': 'Peuvent modifier la reclamation',
      'active': false,
    },
    {
      'cle': '999999709',
      'droit': 'Réception Technique',
      'cleFormulaire': '1000000005',
      'description':
          'Consulter et Ajouter Les Visites De Type Réception Technique',
      'active': false,
    },
    {
      'cle': '999999710',
      'droit': 'Livraison Technique',
      'cleFormulaire': '1000000005',
      'description':
          'Consulter et ajouter les visites de type Livraison Technique',
      'active': false,
    },
    {
      'cle': '999999711',
      'droit': 'Livraison Client',
      'cleFormulaire': '1000000005',
      'description':
          'Consulter et ajouter les visites de type Livraison Client',
      'active': false,
    },
    {
      'cle': '999999712',
      'droit': 'Livraison Syndic',
      'cleFormulaire': '1000000005',
      'description':
          'Consulter et ajouter les visites de type Livraison Syndic',
      'active': false,
    },
    {
      'cle': '999999713',
      'droit': 'Réclamation SAV',
      'cleFormulaire': '1000000005',
      'description': 'Consulter et ajouter les visites de type Réclamation SAV',
      'active': false,
    },
    {
      'cle': '999999714',
      'droit': 'CheckAllAgenda',
      'cleFormulaire': '1000000007',
      'description': 'Consulter toutes les réunions de l\'Agenda SAV',
      'active': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Détails de l'utilisateur",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 800) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildInfoUserCard()),
                            const SizedBox(width: 24),
                            Expanded(child: _buildProjectConfigCard()),
                          ],
                        );
                      }
                      return Column(
                        children: [
                          _buildInfoUserCard(),
                          const SizedBox(height: 24),
                          _buildProjectConfigCard(),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Droits formulaires',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...formRights.map(
                    (right) => _buildProfessionalFormCard(right),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Droits spéciaux',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...specialRights.map(
                    (right) => _buildProfessionalSpecialCard(right),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoUserCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFEFF6FF),
                  child: Icon(Icons.person_outline, color: Colors.blue[700]),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations utilisateur',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Détails du profil',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildInfoField(
                    'Nom complet',
                    'utilisateur${widget.roleId ?? '10013'}',
                    Icons.badge_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoField(
                    'Login',
                    widget.roleName ?? 'commercial',
                    null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              'Email',
              'hibarostom1999@gmail.com',
              Icons.email_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value, IconData? icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectConfigCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFF1F5F9),
                  child: Icon(Icons.settings_outlined, color: Colors.grey[700]),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Configuration des projets',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Attribution et gestion',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Sélection des projets',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Attribuez des projets à cet utilisateur pour lui donner accès aux fonctionnalités spécifiques.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _showMultiSelectProjects,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF3B82F6)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedProjects.isEmpty
                      ? 'Sélectionner des projets...'
                      : _selectedProjects.join(', '),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF334155),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFEF3C7)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attention',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB45309),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Les modifications ne seront appliquées qu\'après avoir cliqué sur "Enregistrer". L\'utilisateur perdra l\'accès aux projets désélectionnés.',
                    style: TextStyle(fontSize: 12, color: Color(0xFFB45309)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Projets sélectionnés: ${_selectedProjects.length}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Projets enregistrés avec succès'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Enregistrer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMultiSelectProjects() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Sélectionner des projets',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              contentPadding: const EdgeInsets.only(top: 12, bottom: 12),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _allProjects.length,
                  itemBuilder: (context, index) {
                    final projet = _allProjects[index];
                    final isSelected = _selectedProjects.contains(projet);
                    return ListTile(
                      leading: isSelected
                          ? const Icon(Icons.check, color: Color(0xFF3B82F6))
                          : const SizedBox(width: 24),
                      title: Text(
                        projet,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFF1E293B),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                      tileColor: isSelected ? const Color(0xFFEFF6FF) : null,
                      onTap: () {
                        setDialogState(() {
                          if (isSelected) {
                            _selectedProjects.remove(projet);
                          } else {
                            _selectedProjects.add(projet);
                          }
                        });
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fermer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildProfessionalFormCard(Map<String, dynamic> right) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Color(0xFF4F46E5),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        right['formulaire'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        right['description'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'FORM',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'PERMISSIONS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFF3F4F6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  children: [
                    _buildPermissionChip(
                      'Consulter',
                      right['consulter'],
                      (v) => setState(() => right['consulter'] = v),
                      Icons.visibility_outlined,
                    ),
                    _buildPermissionChip(
                      'Ajouter',
                      right['ajouter'],
                      (v) => setState(() => right['ajouter'] = v),
                      Icons.add_circle_outline,
                    ),
                    _buildPermissionChip(
                      'Modifier',
                      right['modifier'],
                      (v) => setState(() => right['modifier'] = v),
                      Icons.edit_outlined,
                    ),
                    _buildPermissionChip(
                      'Supprimer',
                      right['supprimer'],
                      (v) => setState(() => right['supprimer'] = v),
                      Icons.delete_outline,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionChip(
    String label,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: value ? const Color(0xFFEEF2FF) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB),
            width: value ? 1.2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 12,
              color: value ? const Color(0xFF6366F1) : const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: value ? FontWeight.w600 : FontWeight.w500,
                color: value
                    ? const Color(0xFF6366F1)
                    : const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(width: 4),
            Transform.scale(
              scale: 0.7,
              child: Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                activeColor: const Color(0xFF6366F1),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalSpecialCard(Map<String, dynamic> right) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.star_border,
              size: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (right['cle'] != null &&
                        right['cle']!.toString().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          right['cle'],
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ),
                    if (right['droit'] != null &&
                        right['droit']!.toString().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          right['droit'],
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    if (right['cleFormulaire'] != null &&
                        right['cleFormulaire']!.toString().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          right['cleFormulaire'],
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFD97706),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  right['description'],
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: right['active'],
            onChanged: (v) => setState(() => right['active'] = v),
            activeColor: const Color(0xFF6366F1),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

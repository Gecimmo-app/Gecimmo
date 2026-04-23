import 'package:flutter/material.dart';
import '../widgets/ui_components/modern_ui_components.dart';
import '../widgets/Ajouter_visite.dart' hide AppTheme;
import 'Detaill_configurationProfil.dart';

class ConfigurationsProfilPage extends StatefulWidget {
  const ConfigurationsProfilPage({super.key});

  @override
  State<ConfigurationsProfilPage> createState() =>
      _ConfigurationsProfilPageState();
}

class _ConfigurationsProfilPageState extends State<ConfigurationsProfilPage> {
  List<Map<String, String>> roles = [
    {'id': '10013', 'nom': 'commercial'},
    {'id': '10145', 'nom': 'SAV - Agent technique'},
  ];

  String rechercheGlobale = '';

  void _refreshList() {
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Liste actualisée'),
        backgroundColor: Color(0xFF1E40AF),
      ),
    );
  }

  void _viewRole(String id, String nom) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DettailPage(roleId: id, roleName: nom),
      ),
    );
  }

  void _openAddRoleForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddRoleForm(
          isEditing: false,
          onRoleAdded: (newRole) => setState(() => roles.add(newRole)),
        ),
      ),
    );
  }

  void _ajouterVisite() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddVisitFlow()),
    );
  }

  List<Map<String, String>> get _filteredRoles {
    if (rechercheGlobale.isEmpty) return roles;
    return roles.where((role) {
      return role['nom']!.toLowerCase().contains(
            rechercheGlobale.toLowerCase(),
          ) ||
          role['id']!.contains(rechercheGlobale);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRoles = _filteredRoles;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      appBar: AppBar(
        title: const Text(
          'Gestion des Pilotes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.cardBackground,
        elevation: 0.5,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _refreshList,
            icon: const Icon(Icons.refresh, color: AppTheme.textSecondary),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLarge),
            child: ModernButton(
              text: 'Ajouter un pilote',
              icon: Icons.add,
              onPressed: _openAddRoleForm,
              fullWidth: true,
            ),
          ),
          // Barre de recherche
          Container(
            color: AppTheme.cardBackground,
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingLarge,
              0,
              AppTheme.spacingLarge,
              AppTheme.spacingMedium,
            ),
            child: ModernInput(
              hint: 'Rechercher...',
              prefixIcon: Icons.search,
              onChanged: (v) => setState(() => rechercheGlobale = v),
            ),
          ),
          const SizedBox(height: 8),
          // Liste des cartes
          Expanded(
            child: filteredRoles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun rôle trouvé',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingLarge,
                      vertical: AppTheme.spacingSmall,
                    ),
                    itemCount: filteredRoles.length,
                    itemBuilder: (context, index) {
                      final role = filteredRoles[index];
                      return _buildRoleCard(role);
                    },
                  ),
          ),
          // Compteur
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppTheme.spacingLarge,
              AppTheme.spacingMedium,
              AppTheme.spacingLarge,
              AppTheme.spacingLarge,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredRoles.length} rôle(s)',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton(
          onPressed: _ajouterVisite,
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: const CircleBorder(),
          tooltip: 'Ajouter une visite',
          child: const Icon(Icons.add, size: 34),
        ),
      ),
    );
  }

  Widget _buildRoleCard(Map<String, String> role) {
    return ModernCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      onTap: () => _viewRole(role['id']!, role['nom']!),
      child: Row(
        children: [
          // Badge ID avec dégradé
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.primaryBlue, AppTheme.primaryBlueLight],
              ),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                role['id']!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMedium),
          // Informations
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role['nom']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.tag, size: 14, color: AppTheme.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      'ID: ${role['id']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bouton Voir (icône œil)
          ModernButton(
            text: '',
            icon: Icons.remove_red_eye_outlined,
            onPressed: () => _viewRole(role['id']!, role['nom']!),
            type: ButtonType.outlined,
            size: ButtonSize.small,
          ),
        ],
      ),
    );
  }
}

// ==================== FORMULAIRE D'AJOUT/MODIFICATION DE RÔLE ====================
class AddRoleForm extends StatefulWidget {
  final bool isEditing;
  final String? roleId;
  final String? roleName;
  final Function(Map<String, String>)? onRoleAdded;
  final Function(Map<String, String>)? onRoleSaved;

  const AddRoleForm({
    super.key,
    this.isEditing = false,
    this.roleId,
    this.roleName,
    this.onRoleAdded,
    this.onRoleSaved,
  });

  @override
  State<AddRoleForm> createState() => _AddRoleFormState();
}

class _AddRoleFormState extends State<AddRoleForm> {
  late final TextEditingController _roleNameController;

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
      'description': 'Gestion des réunions et du suivi des activités',
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
      'cleFormulaire': '6000002',
      'description': 'Réaliser une observation',
      'active': false,
    },
    {
      'cleFormulaire': '6000002',
      'description': 'Accepter une observation',
      'active': false,
    },
    {
      'cleFormulaire': '6000002',
      'description': 'Refuser une observation',
      'active': false,
    },
    {
      'cleFormulaire': '6000002',
      'description': 'Planification Travaux',
      'active': false,
    },
    {
      'cleFormulaire': '6000002',
      'description': 'Planification travaux de l\'observation',
      'active': false,
    },
    {
      'cleFormulaire': '1000000000',
      'description':
          'Les commerciaux peuvent accéder uniquement à la reclamation',
      'active': false,
    },
    {
      'cleFormulaire': '6000013',
      'description': 'Peuvent ajouter la reclamation',
      'active': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _roleNameController = TextEditingController(text: widget.roleName ?? '');
  }

  void _submit() {
    if (_roleNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un nom de rôle'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.isEditing) {
      final updatedRole = {
        'id': widget.roleId!,
        'nom': _roleNameController.text.trim(),
      };
      widget.onRoleSaved?.call(updatedRole);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rôle modifié avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      final newRole = {
        'id': (DateTime.now().millisecondsSinceEpoch % 100000).toString(),
        'nom': _roleNameController.text.trim(),
      };
      widget.onRoleAdded?.call(newRole);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rôle créé avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEditing ? 'Modifier le rôle' : 'Ajouter un rôle',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informations du rôle - Card
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informations du rôle',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildRequiredLabel('Nom du rôle'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _roleNameController,
                        decoration: InputDecoration(
                          hintText: 'Nom du rôle',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionCard(
                title: 'Droits formulaires',
                child: _buildBorderedTable(
                  header: const [
                    _TableColumnConfig(
                      width: 150,
                      label: 'FORMULAIRE',
                      alignment: TextAlign.center,
                    ),
                    _TableColumnConfig(
                      width: 250,
                      label: 'DESCRIPTION',
                      alignment: TextAlign.center,
                    ),
                    _TableColumnConfig(
                      width: 100,
                      label: 'CONSULTER',
                      alignment: TextAlign.center,
                    ),
                    _TableColumnConfig(
                      width: 90,
                      label: 'AJOUTER',
                      alignment: TextAlign.center,
                    ),
                    _TableColumnConfig(
                      width: 90,
                      label: 'MODIFIER',
                      alignment: TextAlign.center,
                    ),
                    _TableColumnConfig(
                      width: 100,
                      label: 'SUPPRIMER',
                      alignment: TextAlign.center,
                    ),
                  ],
                  rows: formRights.map((right) {
                    return _buildTableRow(
                      cells: [
                        _buildTableTextCell(
                          right['formulaire'],
                          width: 150,
                          alignment: TextAlign.center,
                          isPrimary: true,
                        ),
                        _buildTableTextCell(
                          right['description'],
                          width: 250,
                          alignment: TextAlign.center,
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        _buildTableCheckboxCell(
                          value: right['consulter'],
                          width: 100,
                          onChanged: (v) =>
                              setState(() => right['consulter'] = v),
                        ),
                        _buildTableCheckboxCell(
                          value: right['ajouter'],
                          width: 90,
                          onChanged: (v) =>
                              setState(() => right['ajouter'] = v),
                        ),
                        _buildTableCheckboxCell(
                          value: right['modifier'],
                          width: 90,
                          onChanged: (v) =>
                              setState(() => right['modifier'] = v),
                        ),
                        _buildTableCheckboxCell(
                          value: right['supprimer'],
                          width: 100,
                          onChanged: (v) =>
                              setState(() => right['supprimer'] = v),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Droits spéciaux
              const Text(
                'Droits spéciaux',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Scrollbar(
                      thumbVisibility: true,
                      thickness: 8,
                      radius: const Radius.circular(10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              // Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[200]!,
                                    ),
                                  ),
                                ),
                                child: const IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          'CLÉ FORM.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 280,
                                        child: Text(
                                          'DESCRIPTION',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          'ACT.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Rows
                              ...specialRights.asMap().entries.map((entry) {
                                final right = entry.value;
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[200]!,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          right['cleFormulaire'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 280,
                                        child: Text(
                                          right['description'],
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Center(
                                          child: _buildCheckbox(
                                            right['active'],
                                            (v) => setState(
                                              () => right['active'] = v,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[400]!),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E40AF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        widget.isEditing ? 'Modifier' : 'Créer le rôle',
                        style: const TextStyle(color: Colors.white),
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

  Widget _buildRequiredLabel(String text) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
          const TextSpan(
            text: ' *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(bool value, Function(bool) onChanged) {
    return Checkbox(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      activeColor: const Color(0xFF1E40AF),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    );
  }

  Widget _buildPermissionCard(
    String label,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: value ? const Color(0xFFEFF6FF) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value ? const Color(0xFF3B82F6) : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: value ? const Color(0xFF3B82F6) : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: value ? FontWeight.w600 : FontWeight.w500,
                color: value ? const Color(0xFF3B82F6) : Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 6),
            Transform.scale(
              scale: 0.8,
              child: Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                activeColor: const Color(0xFF3B82F6),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _roleNameController.dispose();
    super.dispose();
  }
}

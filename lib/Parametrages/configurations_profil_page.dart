import 'package:flutter/material.dart';

class ConfigurationsProfilPage extends StatefulWidget {
  const ConfigurationsProfilPage({super.key});

  @override
  State<ConfigurationsProfilPage> createState() => _ConfigurationsProfilPageState();
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
      const SnackBar(content: Text('Liste actualisée'), backgroundColor: Color(0xFF1E40AF)),
    );
  }

  void _viewRole(String id, String nom) {
   
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => AddRoleForm(
        isEditing: true,
        roleId: id,
        roleName: nom,
        onRoleSaved: (updatedRole) {
          setState(() {
            // Update the role in the list
            final index = roles.indexWhere((role) => role['id'] == id);
            if (index != -1) {
              roles[index] = updatedRole;
            }
          });
        },
      ),
    );
  }

  void _openAddRoleForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => AddRoleForm(
        isEditing: false,
        onRoleAdded: (newRole) => setState(() => roles.add(newRole)),
      ),
    );
  }

  void _ajouterVisite() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ajouter une visite (fonctionnalité à venir)'),
        backgroundColor: Color(0xFF1E40AF),
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<Map<String, String>> get _filteredRoles {
    if (rechercheGlobale.isEmpty) return roles;
    return roles.where((role) {
      return role['nom']!.toLowerCase().contains(rechercheGlobale.toLowerCase()) ||
          role['id']!.contains(rechercheGlobale);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRoles = _filteredRoles;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Gestion des Rôles'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _refreshList,
            icon: const Icon(Icons.refresh, color: Color(0xFF64748B)),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openAddRoleForm,
                icon: const Icon(Icons.add, size: 18),
                label: const Text(
                  ' Ajouter un rôle',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E40AF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          // Barre de recherche
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => rechercheGlobale = v),
              decoration: InputDecoration(
                hintText: 'Rechercher...',
                prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
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
                        Icon(Icons.admin_panel_settings, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('Aucun rôle trouvé', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredRoles.length,
                    itemBuilder: (context, index) {
                      final role = filteredRoles[index];
                      return _buildRoleCard(role);
                    },
                  ),
          ),
          // Compteur
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredRoles.length} rôle(s)',
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterVisite,
        backgroundColor: const Color(0xFF1E40AF),
        child: const Icon(Icons.add, size: 28, color: Colors.white), // Hna bdalt lon l byad
        tooltip: 'Ajouter une visite',
      ),
    );
  }

  Widget _buildRoleCard(Map<String, String> role) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () => _viewRole(role['id']!, role['nom']!),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                      colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1E40AF).withOpacity(0.3),
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
                const SizedBox(width: 16),
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
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.tag, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            'ID: ${role['id']}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Bouton Voir (icône œil)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () => _viewRole(role['id']!, role['nom']!),
                    icon: const Icon(Icons.remove_red_eye_outlined, size: 20, color: Color(0xFF1E40AF)),
                    tooltip: 'Modifier le rôle',
                  ),
                ),
              ],
            ),
          ),
        ),
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
    {'formulaire': 'Visites', 'description': 'Visites SAV', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Tickets', 'description': 'Tickets SAV', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Tickets SAV', 'description': 'Consultation des Tickets et Objets de Service (TSOS) SAV', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Agenda SAV', 'description': 'Gestion des réunions et du suivi des activités', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Reclamations SAV', 'description': 'Gérer les réclamations SAV', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Prestataires', 'description': 'Gestion des prestataires', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Parametrage SAV', 'description': 'Paramétrages des listes SAV', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Utilisateur SAV', 'description': 'Gestion des utilisateurs', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Dashboards SAV', 'description': 'Consultation des Dashboards SAV', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
  ];

  List<Map<String, dynamic>> specialRights = [
    {'cleFormulaire': '6000002', 'description': 'Réaliser une observation', 'active': false},
    {'cleFormulaire': '6000002', 'description': 'Accepter une observation', 'active': false},
    {'cleFormulaire': '6000002', 'description': 'Refuser une observation', 'active': false},
    {'cleFormulaire': '6000002', 'description': 'Planification Travaux', 'active': false},
    {'cleFormulaire': '6000002', 'description': 'Planification travaux de l\'observation', 'active': false},
    {'cleFormulaire': '1000000000', 'description': 'Les commerciaux peuvent accéder uniquement à la reclamation', 'active': false},
    {'cleFormulaire': '6000013', 'description': 'Peuvent ajouter la reclamation', 'active': false},
  ];

  @override
  void initState() {
    super.initState();
    _roleNameController = TextEditingController(text: widget.roleName ?? '');
  }

  void _submit() {
    if (_roleNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un nom de rôle'), backgroundColor: Colors.red),
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
        const SnackBar(content: Text('Rôle modifié avec succès'), backgroundColor: Colors.green),
      );
    } else {
      final newRole = {
        'id': (DateTime.now().millisecondsSinceEpoch % 100000).toString(),
        'nom': _roleNameController.text.trim(),
      };
      widget.onRoleAdded?.call(newRole);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rôle créé avec succès'), backgroundColor: Colors.green),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.isEditing ? 'Modifier le rôle' : 'Ajouter un nouveau rôle',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            
            // Informations du rôle - Card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Informations du rôle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 16),
                    _buildRequiredLabel('Nom du rôle'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _roleNameController,
                      decoration: InputDecoration(
                        hintText: 'Nom du rôle',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Droits formulaires
            const Text('Droits formulaires', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
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
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                              ),
                              child: const IntrinsicHeight(
                                child: Row(
                                  children: [
                                    SizedBox(width: 150, child: Text('FORMULAIRE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                                    SizedBox(width: 250, child: Text('DESCRIPTION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                                    SizedBox(width: 100, child: Text('CONSULTER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                                    SizedBox(width: 90, child: Text('AJOUTER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                                    SizedBox(width: 90, child: Text('MODIFIER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                                    SizedBox(width: 100, child: Text('SUPPRIMER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                                  ],
                                ),
                              ),
                            ),
                            // Rows
                            ...formRights.asMap().entries.map((entry) {
                              final right = entry.value;
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 150, child: Text(right['formulaire'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center)),
                                    SizedBox(width: 250, child: Text(right['description'], style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center)),
                                    SizedBox(width: 100, child: Center(child: _buildCheckbox(right['consulter'], (v) => setState(() => right['consulter'] = v)))),
                                    SizedBox(width: 90, child: Center(child: _buildCheckbox(right['ajouter'], (v) => setState(() => right['ajouter'] = v)))),
                                    SizedBox(width: 90, child: Center(child: _buildCheckbox(right['modifier'], (v) => setState(() => right['modifier'] = v)))),
                                    SizedBox(width: 100, child: Center(child: _buildCheckbox(right['supprimer'], (v) => setState(() => right['supprimer'] = v)))),
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
            
            const SizedBox(height: 24),
            
            // Droits spéciaux
            const Text('Droits spéciaux', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
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
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                              ),
                              child: const IntrinsicHeight(
                                child: Row(
                                  children: [
                                    SizedBox(width: 120, child: Text('CLÉ FORM.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                                    SizedBox(width: 280, child: Text('DESCRIPTION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                                    SizedBox(width: 80, child: Text('ACT.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                                  ],
                                ),
                              ),
                            ),
                            // Rows
                            ...specialRights.asMap().entries.map((entry) {
                              final right = entry.value;
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 120, child: Text(right['cleFormulaire'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center)),
                                    SizedBox(width: 280, child: Text(right['description'], style: const TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.left)),
                                    SizedBox(width: 80, child: Center(child: _buildCheckbox(right['active'], (v) => setState(() => right['active'] = v)))),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(widget.isEditing ? 'Modifier' : 'Créer le rôle'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRequiredLabel(String text) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
          const TextSpan(text: ' *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)),
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

  @override
  void dispose() {
    _roleNameController.dispose();
    super.dispose();
  }
}
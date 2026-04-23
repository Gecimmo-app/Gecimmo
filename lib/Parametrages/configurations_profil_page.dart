import 'package:flutter/material.dart';

import 'Detaill_configurationProfil.dart';

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
      builder: (context) => DettailPage(
        roleId: id,
        roleName: nom,
      ),
    );
  }

  void _openAddRoleForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => AddRoleForm(
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
        child: const Icon(Icons.add, size: 28, color: Colors.white),
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
  final Function(Map<String, String>)? onRoleAdded;

  const AddRoleForm({
    super.key,
    this.onRoleAdded,
  });

  @override
  State<AddRoleForm> createState() => _AddRoleFormState();
}

class _AddRoleFormState extends State<AddRoleForm> {
  late final TextEditingController _roleNameController;
  
  List<String> _allProjects = ['Projet1', 'Projet2', 'Projet3', 'Projet4', 'Projet5', 'Projet6', 'Projet7'];
  List<String> _selectedProjects = ['Projet1', 'Projet3', 'Projet5', 'Projet7'];
  
  List<Map<String, dynamic>> formRights = [
    {'formulaire': 'Visites', 'description': 'Visites SAV', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Tickets', 'description': 'Tickets SAV', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Tickets SAV', 'description': 'Consultation des Tickets et Objets de Service (TSOS) SAV', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Agenda SAV', 'description': 'Gestion des réunions et du suivi SAV', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Reclamations SAV', 'description': 'Gérer les réclamations SAV', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Prestataires', 'description': 'Gestion des prestataires', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Parametrage SAV', 'description': 'Paramétrages des listes SAV', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Utilisateur SAV', 'description': 'Gestion des utilisateurs', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
    {'formulaire': 'Dashboards SAV', 'description': 'Consultation des Dashboards SAV', 'consulter': false, 'ajouter': false, 'modifier': false, 'supprimer': false},
  ];

  // ==================== ANCIENS DROITS SPÉCIAUX (CONSERVÉS) ====================
  // ==================== NOUVEAUX DROITS SPÉCIAUX AJOUTÉS ====================
  List<Map<String, dynamic>> specialRights = [
    // Anciens droits (conservés)
    {'cle': '6000001', 'droit': 'RealiserObservation', 'cleFormulaire': '6000002', 'description': 'Réaliser une observation', 'active': false},
    {'cle': '6000002', 'droit': 'AcceptObservation', 'cleFormulaire': '6000002', 'description': 'Accepter une observation', 'active': false},
    {'cle': '6000003', 'droit': 'RefusObservation', 'cleFormulaire': '6000002', 'description': 'Refuser une observation', 'active': false},
    {'cle': '6000004', 'droit': 'PlanificationTravaux', 'cleFormulaire': '6000002', 'description': 'Planification Travaux', 'active': false},
    {'cle': '6000006', 'droit': 'PlanificationTravauxObservation', 'cleFormulaire': '6000002', 'description': 'Planification travaux de l\'observation', 'active': false},
    {'cle': '6000012', 'droit': 'CommercialConsulteDetail', 'cleFormulaire': '1000000000', 'description': 'Les commerciaux peuvent accéder uniquement à la reclamation', 'active': false},
    {'cle': '6000013', 'droit': 'Add', 'cleFormulaire': '1000000000', 'description': 'Peuvent ajouter la reclamation', 'active': false},
    
    // Nouveaux droits ajoutés
    {'cle': '6000014', 'droit': 'Edit', 'cleFormulaire': '1000000000', 'description': 'Peuvent modifier la reclamation', 'active': false},
    {'cle': '999999709', 'droit': 'Réception Technique', 'cleFormulaire': '1000000005', 'description': 'Consulter et Ajouter Les Visites De Type Réception Technique', 'active': false},
    {'cle': '999999710', 'droit': 'Livraison Technique', 'cleFormulaire': '1000000005', 'description': 'Consulter et ajouter les visites de type Livraison Technique', 'active': false},
    {'cle': '999999711', 'droit': 'Livraison Client', 'cleFormulaire': '1000000005', 'description': 'Consulter et ajouter les visites de type Livraison Client', 'active': false},
    {'cle': '999999712', 'droit': 'Livraison Syndic', 'cleFormulaire': '1000000005', 'description': 'Consulter et ajouter les visites de type Livraison Syndic', 'active': false},
    {'cle': '999999713', 'droit': 'Réclamation SAV', 'cleFormulaire': '1000000005', 'description': 'Consulter et ajouter les visites de type Réclamation SAV', 'active': false},
    {'cle': '999999714', 'droit': 'CheckAllAgenda', 'cleFormulaire': '1000000007', 'description': 'Consulter toutes les réunions de l\'Agenda SAV', 'active': false},
  ];

  @override
  void initState() {
    super.initState();
    _roleNameController = TextEditingController();
  }

  void _submit() {
    if (_roleNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un nom de rôle'), backgroundColor: Colors.red),
      );
      return;
    }

    final newRole = {
      'id': (DateTime.now().millisecondsSinceEpoch % 100000).toString(),
      'nom': _roleNameController.text.trim(),
    };
    widget.onRoleAdded?.call(newRole);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rôle créé avec succès'), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildAddRoleForm(context);
  }

  Widget _buildAddRoleForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ajouter un nouveau rôle',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Informations du rôle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
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
            
            const Text('Droits formulaires', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
            const SizedBox(height: 12),
            ...formRights.map((right) => _buildProfessionalFormCard(right)),
            
            const SizedBox(height: 24),
            
            const Text('Droits spéciaux', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
            const SizedBox(height: 12),
            ...specialRights.map((right) => _buildProfessionalSpecialCard(right)),
            
            const SizedBox(height: 32),
            
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
                    child: const Text('Créer le rôle'),
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

  // ==================== CARTES PROFESSIONNELLES ====================
  
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
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: const Border(
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
                  child: const Icon(Icons.description_outlined, color: Color(0xFF4F46E5), size: 18),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    const Icon(Icons.lock_outline, size: 12, color: Color(0xFF9CA3AF)),
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
                      child: Container(height: 1, color: const Color(0xFFF3F4F6)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  children: [
                    _buildPermissionChip('Consulter', right['consulter'], (v) => setState(() => right['consulter'] = v), Icons.visibility_outlined),
                    _buildPermissionChip('Ajouter', right['ajouter'], (v) => setState(() => right['ajouter'] = v), Icons.add_circle_outline),
                    _buildPermissionChip('Modifier', right['modifier'], (v) => setState(() => right['modifier'] = v), Icons.edit_outlined),
                    _buildPermissionChip('Supprimer', right['supprimer'], (v) => setState(() => right['supprimer'] = v), Icons.delete_outline),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionChip(String label, bool value, Function(bool) onChanged, IconData icon) {
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
                color: value ? const Color(0xFF6366F1) : const Color(0xFF6B7280),
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
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
            child: const Icon(Icons.star_border, size: 14, color: Color(0xFF6B7280)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toujours afficher le Wrap pour montrer au moins cleFormulaire
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (right['cle'] != null && right['cle']!.toString().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                    if (right['droit'] != null && right['droit']!.toString().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                    if (right['cleFormulaire'] != null && right['cleFormulaire']!.toString().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF111827)),
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

  @override
  void dispose() {
    _roleNameController.dispose();
    super.dispose();
  }
}
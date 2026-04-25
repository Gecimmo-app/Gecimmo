import 'package:flutter/material.dart';
import '../widgets/ui_components/modern_ui_components.dart';
import '../widgets/Ajouter_visite.dart' hide AppTheme;
import '../widgets/Dashboard/Dashbordprincpa.dart';

class PiloteProjectPage extends StatefulWidget {
  const PiloteProjectPage({super.key});

  @override
  State<PiloteProjectPage> createState() => _PiloteProjectPageState();
}

class _PiloteProjectPageState extends State<PiloteProjectPage> {
  List<Map<String, String>> pilotes = [
    {'utilisateur': 'utilisateur10013', 'projet': 'Projet7', 'tranche': 'Tranche5', 'groupement': '-'},
    {'utilisateur': 'utilisateur10017', 'projet': 'Projet7', 'tranche': 'Tranche7', 'groupement': 'GH2'},
    {'utilisateur': 'utilisateur10013', 'projet': 'Projet2', 'tranche': '-', 'groupement': '-'},
    {'utilisateur': 'utilisateur10016', 'projet': 'Projet2', 'tranche': '-', 'groupement': '-'},
  ];

  String rechercheGlobale = '';
  String selectedUtilisateur = 'Tous les utilisateurs';
  String selectedProjet = 'Tous les projets';
  String selectedTranche = 'Toutes les tranches';
  String selectedGroupement = 'Tous les groupements';

  final List<String> utilisateurs = ['Tous les utilisateurs', 'utilisateur10013', 'utilisateur10016', 'utilisateur10017'];
  final List<String> projets = ['Tous les projets', 'Projet2', 'Projet7'];
  final List<String> tranches = ['Toutes les tranches', 'Tranche5', 'Tranche7'];
  final List<String> groupements = ['Tous les groupements', 'GH2', '-'];

  void _refreshList() {
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Liste actualisée'), backgroundColor: Color(0xFF1E40AF)),
    );
  }

  void _deletePilote(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer ce pilote ?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              setState(() => pilotes.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pilote supprimé'), backgroundColor: Colors.red),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _openAddPiloteForm() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddPiloteForm(
        onPiloteAdded: (newPilote) => setState(() => pilotes.add(newPilote)),
      ),
    );
  }

  void _ajouterVisite() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddVisitFlow()),
    );
  }

  List<Map<String, String>> get _filteredPilotes {
    return pilotes.where((pilote) {
      if (rechercheGlobale.isNotEmpty) {
        final searchLower = rechercheGlobale.toLowerCase();
        if (!pilote['utilisateur']!.toLowerCase().contains(searchLower) &&
            !pilote['projet']!.toLowerCase().contains(searchLower)) {
          return false;
        }
      }
      if (selectedUtilisateur != 'Tous les utilisateurs' && pilote['utilisateur'] != selectedUtilisateur) return false;
      if (selectedProjet != 'Tous les projets' && pilote['projet'] != selectedProjet) return false;
      if (selectedTranche != 'Toutes les tranches' && pilote['tranche'] != selectedTranche) return false;
      if (selectedGroupement != 'Tous les groupements' && pilote['groupement'] != selectedGroupement) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPilotes = _filteredPilotes;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Gestion des Pilotes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Button "Ajouter un pilote" fouq les selects (tftah l formulaire)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              child: ModernButton(
                text: 'Ajouter un pilote',
                icon: Icons.person_add,
                onPressed: _openAddPiloteForm,
                fullWidth: true,
              ),
            ),
            // Barre de recherche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
              child: ModernInput(
                hint: 'Chercher...',
                prefixIcon: Icons.search,
                onChanged: (v) => setState(() => rechercheGlobale = v),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            // Filtres en scroll horizontal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      icon: Icons.person_outline,
                      label: selectedUtilisateur,
                      onTap: () => _showFilterSheet(context, 'Utilisateurs', utilisateurs, selectedUtilisateur, (v) => setState(() => selectedUtilisateur = v), showSearch: true),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      icon: Icons.folder_outlined,
                      label: selectedProjet,
                      onTap: () => _showFilterSheet(context, 'Projets', projets, selectedProjet, (v) => setState(() => selectedProjet = v), showSearch: true),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      icon: Icons.layers_outlined,
                      label: selectedTranche,
                      onTap: () => _showFilterSheet(context, 'Tranches', tranches, selectedTranche, (v) => setState(() => selectedTranche = v), showSearch: true),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      icon: Icons.group_work_outlined,
                      label: selectedGroupement,
                      onTap: () => _showFilterSheet(context, 'Groupements', groupements, selectedGroupement, (v) => setState(() => selectedGroupement = v), showSearch: true),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            // Liste des cartes
            filteredPilotes.isEmpty
                ? SizedBox(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 64, color: AppTheme.textMuted),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun pilote trouvé',
                            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge),
                    itemCount: filteredPilotes.length,
                    itemBuilder: (context, index) {
                      final pilote = filteredPilotes[index];
                      final originalIndex = pilotes.indexOf(pilote);
                      return ModernCard(
                        margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // En-tête avec l'utilisateur et icône de suppression
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Avatar avec initiale
                                ModernAvatar(
                                  name: pilote['utilisateur'],
                                  size: 50,
                                ),
                                const SizedBox(width: AppTheme.spacingMedium),
                                // Nom de l'utilisateur
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pilote['utilisateur']!,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryBlue,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      ModernBadge(
                                        text: 'Pilote de projet',
                                        type: BadgeType.primary,
                                        size: BadgeSize.small,
                                      ),
                                    ],
                                  ),
                                ),
                                // Bouton supprimer
                                InkWell(
                                  onTap: () => _deletePilote(originalIndex),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacingLarge),
                            const Divider(height: 1, color: AppTheme.border),
                            const SizedBox(height: AppTheme.spacingMedium),
                            // Informations du projet, tranche et groupement
                            Row(
                              children: [
                                Expanded(
                                  child: ModernInfoBox(
                                    label: 'Projet',
                                    value: pilote['projet']!,
                                    icon: Icons.business_outlined,
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingMedium),
                                Expanded(
                                  child: ModernInfoBox(
                                    label: 'Tranche',
                                    value: pilote['tranche']!,
                                    icon: Icons.layers_outlined,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppTheme.spacingMedium),
                            // Groupement
                            ModernInfoBox(
                              label: 'Groupement',
                              value: pilote['groupement']!,
                              icon: Icons.group_outlined,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            // Compteur aligné à gauche
            Padding(
              padding: const EdgeInsets.fromLTRB(AppTheme.spacingLarge, AppTheme.spacingMedium, AppTheme.spacingLarge, AppTheme.spacingLarge),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Affichage de ${filteredPilotes.length} pilote(s)',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
              ),
            ),
          ],
        ),
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

  void _showFilterSheet(BuildContext context, String title, List<String> options, String currentValue, Function(String) onSelected, {required bool showSearch}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return FilterSheetContent(
          title: title,
          options: options,
          currentValue: currentValue,
          onSelected: onSelected,
          showSearch: showSearch,
        );
      },
    );
  }

  Widget _buildFilterChip({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), 
              blurRadius: 4, 
              offset: const Offset(0, 1)
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: const Color(0xFF64748B)),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}

// ==================== FORMULAIRE D'AJOUT DE PILOTE ====================
class AddPiloteForm extends StatefulWidget {
  final Function(Map<String, String>) onPiloteAdded;

  const AddPiloteForm({super.key, required this.onPiloteAdded});

  @override
  State<AddPiloteForm> createState() => _AddPiloteFormState();
}

class _AddPiloteFormState extends State<AddPiloteForm> {
  String? selectedPilote;
  String? selectedProjet;
  String? selectedTranche;
  String? selectedGroupement;

  final List<String> pilotes = ['utilisateur10013', 'utilisateur10016', 'utilisateur10017'];
  final List<String> projets = ['Projet2', 'Projet7'];
  final Map<String, List<String>> tranchesParProjet = {
    'Projet2': [],
    'Projet7': ['Tranche5', 'Tranche7'],
  };
  final Map<String, List<String>> groupementsParProjet = {
    'Projet2': [],
    'Projet7': ['GH2'],
  };

  List<String> get tranchesDisponibles {
    if (selectedProjet == null) return [];
    return tranchesParProjet[selectedProjet] ?? [];
  }

  List<String> get groupementsDisponibles {
    if (selectedProjet == null) return [];
    return groupementsParProjet[selectedProjet] ?? [];
  }

  void _submit() {
    if (selectedPilote == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un pilote'), backgroundColor: Colors.red),
      );
      return;
    }
    if (selectedProjet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un projet'), backgroundColor: Colors.red),
      );
      return;
    }

    final newPilote = {
      'utilisateur': selectedPilote!,
      'projet': selectedProjet!,
      'tranche': selectedTranche ?? '-',
      'groupement': selectedGroupement ?? '-',
    };

    widget.onPiloteAdded(newPilote);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pilote assigné avec succès'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFEFF6FF), // Fond légèrement grisé/bleuté
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assigner un Pilote à un Projet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 24),
              ModernDropdown(
                label: 'Pilote',
                value: selectedPilote,
                hint: 'Sélectionner un pilote',
                required: true,
                items: pilotes.map((pilote) => DropdownMenuItem(value: pilote, child: Text(pilote))).toList(),
                onChanged: (v) => setState(() => selectedPilote = v),
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              ModernDropdown(
                label: 'Projet',
                value: selectedProjet,
                hint: 'Sélectionner un projet',
                required: true,
                items: projets.map((projet) => DropdownMenuItem(value: projet, child: Text(projet))).toList(),
                onChanged: (v) {
                  setState(() {
                    selectedProjet = v;
                    selectedTranche = null;
                    selectedGroupement = null;
                  });
                },
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              ModernDropdown(
                label: 'Tranche',
                value: selectedTranche,
                hint: selectedProjet == null ? 'Sélectionnez d\'abord un projet' : 'Sélectionner une tranche',
                enabled: selectedProjet != null,
                items: tranchesDisponibles.map((tranche) => DropdownMenuItem(value: tranche, child: Text(tranche))).toList(),
                onChanged: (v) => setState(() => selectedTranche = v),
              ),
              const SizedBox(height: AppTheme.spacingLarge),
              ModernDropdown(
                label: 'Groupement',
                value: selectedGroupement,
                hint: selectedProjet == null ? 'Sélectionnez d\'abord un projet' : 'Sélectionner un groupement',
                enabled: selectedProjet != null,
                items: groupementsDisponibles.map((groupement) => DropdownMenuItem(value: groupement, child: Text(groupement))).toList(),
                onChanged: (v) => setState(() => selectedGroupement = v),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ModernButton(
                      text: 'Annuler',
                      onPressed: () => Navigator.pop(context),
                      type: ButtonType.outlined,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMedium),
                  Expanded(
                    child: ModernButton(
                      text: 'Créer',
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
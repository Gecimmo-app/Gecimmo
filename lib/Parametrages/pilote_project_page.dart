import 'package:flutter/material.dart';

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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => AddPiloteForm(
        onPiloteAdded: (newPilote) => setState(() => pilotes.add(newPilote)),
      ),
    );
  }

  void _ajouterVisite() {
    // Ajouter une visite
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ajouter une visite (fonctionnalité à venir)'), backgroundColor: Color(0xFF1E40AF)),
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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Gestion des Pilotes',
          style: TextStyle(fontSize: 18),
        ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Button "Ajouter un pilote" fouq les selects (tftah l formulaire)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openAddPiloteForm,
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text(
                    'Ajouter un pilote',
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
                  hintText: 'Chercher...',
                  prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            // Filtres en scroll horizontal
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterDropdown(selectedUtilisateur, utilisateurs, (v) => setState(() => selectedUtilisateur = v!), 'Utilisateur'),
                    const SizedBox(width: 12),
                    _buildFilterDropdown(selectedProjet, projets, (v) => setState(() => selectedProjet = v!), 'Projet'),
                    const SizedBox(width: 12),
                    _buildFilterDropdown(selectedTranche, tranches, (v) => setState(() => selectedTranche = v!), 'Tranche'),
                    const SizedBox(width: 12),
                    _buildFilterDropdown(selectedGroupement, groupements, (v) => setState(() => selectedGroupement = v!), 'Groupement'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Liste des cartes
            filteredPilotes.isEmpty
                ? SizedBox(
                    height: 300,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun pilote trouvé',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredPilotes.length,
                    itemBuilder: (context, index) {
                      final pilote = filteredPilotes[index];
                      final originalIndex = pilotes.indexOf(pilote);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // En-tête avec l'utilisateur et icône de suppression
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Avatar avec initiale
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          pilote['utilisateur']!.substring(0, 1).toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
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
                                              color: Color(0xFF1E40AF),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEFF6FF),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              'Pilote de projet',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFF1E40AF),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Bouton supprimer
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: IconButton(
                                        onPressed: () => _deletePilote(originalIndex),
                                        icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                        tooltip: 'Supprimer',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                                const SizedBox(height: 12),
                                // Informations du projet, tranche et groupement
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.business_outlined,
                                              size: 16,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Projet',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey[500],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  pilote['projet']!,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF1E293B),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.layers_outlined,
                                              size: 16,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Tranche',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey[500],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  pilote['tranche']!,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF1E293B),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Groupement
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.group_outlined,
                                        size: 16,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Groupement',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          pilote['groupement']!,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            // Compteur aligné à gauche
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Affichage de ${filteredPilotes.length} pilote(s)',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterVisite,
        backgroundColor: const Color(0xFF1E40AF),
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Ajouter une visite',
      ),
    );
  }

  Widget _buildFilterDropdown(String value, List<String> items, Function(String?) onChanged, String label) {
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1E40AF)),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 13)));
          }).toList(),
          onChanged: onChanged,
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
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Assigner un Pilote à un Projet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            _buildRequiredLabel('Pilote'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedPilote,
              items: pilotes,
              hint: 'Sélectionner un pilote',
              onChanged: (v) => setState(() => selectedPilote = v),
            ),
            const SizedBox(height: 20),
            _buildRequiredLabel('Projet'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedProjet,
              items: projets,
              hint: 'Sélectionner un projet',
              onChanged: (v) {
                setState(() {
                  selectedProjet = v;
                  selectedTranche = null;
                  selectedGroupement = null;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('Tranche', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedTranche,
              items: tranchesDisponibles,
              hint: selectedProjet == null ? 'Sélectionnez d\'abord un projet' : 'Sélectionner une tranche',
              enabled: selectedProjet != null,
              onChanged: (v) => setState(() => selectedTranche = v),
            ),
            const SizedBox(height: 20),
            const Text('Groupement', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedGroupement,
              items: groupementsDisponibles,
              hint: selectedProjet == null ? 'Sélectionnez d\'abord un projet' : 'Sélectionner un groupement',
              enabled: selectedProjet != null,
              onChanged: (v) => setState(() => selectedGroupement = v),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E40AF)),
                    child: const Text('Créer'),
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

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
    bool enabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
        color: enabled ? Colors.white : const Color(0xFFF5F7FA),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: enabled ? Colors.grey[600] : Colors.grey[400])),
          icon: Icon(Icons.arrow_drop_down, color: enabled ? const Color(0xFF1E40AF) : Colors.grey[400]),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}
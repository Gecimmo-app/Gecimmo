import 'package:flutter/material.dart';

class AgentLivraisonPage extends StatefulWidget {
  const AgentLivraisonPage({super.key});

  @override
  State<AgentLivraisonPage> createState() => _AgentLivraisonPageState();
}

class _AgentLivraisonPageState extends State<AgentLivraisonPage> {
  List<Map<String, String>> agents = [
    {'agent': 'utilisateur10013', 'projet': 'Projet14', 'tranche': 'Tranche39'},
    {'agent': 'utilisateur10013', 'projet': 'Projet2', 'tranche': 'Tranche18'},
  ];

  String recherche = '';

  void _refreshList() {
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Liste actualisée'),
        backgroundColor: Color(0xFF1E40AF),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteAgent(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer cet agent ?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => agents.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Agent supprimé'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _openAddAgentForm() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddAgentDialog(
        onAgentAdded: (newAgent) {
          setState(() {
            agents.add(newAgent);
          });
        },
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

  List<Map<String, String>> get _filteredAgents {
    if (recherche.isEmpty) return agents;
    return agents.where((agent) {
      return agent['agent']!.toLowerCase().contains(recherche.toLowerCase()) ||
          agent['projet']!.toLowerCase().contains(recherche.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredAgents = _filteredAgents;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Gestion des Agents de Livraison',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
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
            // Button "Ajouter un agent" fouq l'recherche (tftah l formulaire)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _openAddAgentForm,
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text(
                    'Ajouter un agent',
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
                onChanged: (value) => setState(() => recherche = value),
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
            filteredAgents.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_off_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun agent trouvé',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredAgents.length,
                    itemBuilder: (context, index) {
                      final agent = filteredAgents[index];
                      final originalIndex = agents.indexOf(agent);
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
                                // En-tête avec l'agent et icône de suppression
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
                                          agent['agent']!.substring(0, 1).toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Nom de l'agent
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            agent['agent']!,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E293B),
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
                                              'Agent de livraison',
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
                                        onPressed: () => _deleteAgent(originalIndex),
                                        icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                        tooltip: 'Supprimer',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                                const SizedBox(height: 12),
                                // Informations du projet et tranche
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
                                                  agent['projet']!,
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
                                                  agent['tranche']!,
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
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            // Compteur
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filteredAgents.length} affectation(s) trouvée(s)',
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
}

// ==================== DIALOG D'AJOUT D'AGENT ====================
class AddAgentDialog extends StatefulWidget {
  final Function(Map<String, String>) onAgentAdded;

  const AddAgentDialog({super.key, required this.onAgentAdded});

  @override
  State<AddAgentDialog> createState() => _AddAgentDialogState();
}

class _AddAgentDialogState extends State<AddAgentDialog> {
  String? selectedAgent;
  String? selectedProjet;
  String? selectedTranche;

  final List<String> agents = ['utilisateur10013', 'utilisateur10016', 'utilisateur10017'];
  final List<String> projets = ['Projet2', 'Projet14'];
  final Map<String, List<String>> tranchesParProjet = {
    'Projet2': ['Tranche18'],
    'Projet14': ['Tranche39'],
  };

  List<String> get tranchesDisponibles {
    if (selectedProjet == null) return [];
    return tranchesParProjet[selectedProjet] ?? [];
  }

  void _submit() {
    if (selectedAgent == null) {
      _showError('Veuillez sélectionner un agent');
      return;
    }
    if (selectedProjet == null) {
      _showError('Veuillez sélectionner un projet');
      return;
    }
    if (selectedTranche == null) {
      _showError('Veuillez sélectionner une tranche');
      return;
    }

    final newAgent = {
      'agent': selectedAgent!,
      'projet': selectedProjet!,
      'tranche': selectedTranche!,
    };

    widget.onAgentAdded(newAgent);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Agent assigné avec succès'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Assigner un Agent de Livraison à un Projet',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agent de Livraison
            _buildRequiredLabel('Agent de Livraison'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedAgent,
              items: agents,
              hint: 'Sélectionner un agent',
              onChanged: (v) => setState(() => selectedAgent = v),
            ),
            const SizedBox(height: 20),
            // Projet
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
                });
              },
            ),
            const SizedBox(height: 20),
            // Tranche
            _buildRequiredLabel('Tranche'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedTranche,
              items: tranchesDisponibles,
              hint: selectedProjet == null ? 'Sélectionnez d\'abord un projet' : 'Sélectionner une tranche',
              enabled: selectedProjet != null,
              onChanged: (v) => setState(() => selectedTranche = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            side: BorderSide(color: Colors.grey[400]!),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E40AF),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Créer'),
        ),
      ],
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
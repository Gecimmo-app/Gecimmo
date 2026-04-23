import 'package:flutter/material.dart';
import '../widgets/ui_components/modern_ui_components.dart';
import '../widgets/Ajouter_visite.dart' hide AppTheme;

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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddVisitFlow()),
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
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Gestion des Agents de Livraison',
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
            // Button "Ajouter un agent" fouq l'recherche (tftah l formulaire)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              child: ModernButton(
                text: 'Ajouter un agent',
                icon: Icons.person_add,
                onPressed: _openAddAgentForm,
                fullWidth: true,
              ),
            ),
            // Barre de recherche
            Container(
              color: AppTheme.cardBackground,
              padding: const EdgeInsets.fromLTRB(AppTheme.spacingLarge, 0, AppTheme.spacingLarge, AppTheme.spacingMedium),
              child: ModernInput(
                hint: 'Rechercher...',
                prefixIcon: Icons.search,
                onChanged: (value) => setState(() => recherche = value),
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
                          Icon(Icons.person_off_outlined, size: 64, color: AppTheme.textMuted),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun agent trouvé',
                            style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLarge, vertical: AppTheme.spacingSmall),
                    itemCount: filteredAgents.length,
                    itemBuilder: (context, index) {
                      final agent = filteredAgents[index];
                      final originalIndex = agents.indexOf(agent);
                      return ModernCard(
                        margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // En-tête avec l'agent et icône de suppression
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Avatar avec initiale
                                ModernAvatar(
                                  name: agent['agent'],
                                  size: 50,
                                ),
                                const SizedBox(width: AppTheme.spacingMedium),
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
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      ModernBadge(
                                        text: 'Agent de livraison',
                                        type: BadgeType.primary,
                                        size: BadgeSize.small,
                                      ),
                                    ],
                                  ),
                                ),
                                // Bouton supprimer
                                InkWell(
                                  onTap: () => _deleteAgent(originalIndex),
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
                            // Informations du projet et tranche
                            Row(
                              children: [
                                Expanded(
                                  child: ModernInfoBox(
                                    label: 'Projet',
                                    value: agent['projet']!,
                                    icon: Icons.business_outlined,
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingMedium),
                                Expanded(
                                  child: ModernInfoBox(
                                    label: 'Tranche',
                                    value: agent['tranche']!,
                                    icon: Icons.layers_outlined,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            // Compteur
            Padding(
              padding: const EdgeInsets.fromLTRB(AppTheme.spacingLarge, AppTheme.spacingMedium, AppTheme.spacingLarge, AppTheme.spacingLarge),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filteredAgents.length} affectation(s) trouvée(s)',
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFF1F5F9), // Fond légèrement grisé/bleuté
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assigner un Agent de Livraison à un Projet',
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold, 
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 24),
            // Agent de Livraison
            ModernDropdown(
              label: 'Agent de Livraison',
              value: selectedAgent,
              hint: 'Sélectionner un agent',
              required: true,
              items: agents.map((agent) => DropdownMenuItem(value: agent, child: Text(agent))).toList(),
              onChanged: (v) => setState(() => selectedAgent = v),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            // Projet
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
                });
              },
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            // Tranche
            ModernDropdown(
              label: 'Tranche',
              value: selectedTranche,
              hint: selectedProjet == null ? 'Sélectionnez d\'abord un projet' : 'Sélectionner une tranche',
              required: true,
              enabled: selectedProjet != null,
              items: tranchesDisponibles.map((tranche) => DropdownMenuItem(value: tranche, child: Text(tranche))).toList(),
              onChanged: (v) => setState(() => selectedTranche = v),
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
    );
  }
}
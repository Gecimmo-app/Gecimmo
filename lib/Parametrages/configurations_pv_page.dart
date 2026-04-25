import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/Ajouter_visite.dart' hide AppTheme;
import '../widgets/Dashboard/Dashbordprincpa.dart';

class ConfigurationsPvPage extends StatefulWidget {
  const ConfigurationsPvPage({super.key});

  @override
  State<ConfigurationsPvPage> createState() => _ConfigurationsPvPageState();
}

class ModelPV {
  final String typeRapport;
  final String projet;
  final String tranche;
  final String nature;
  final String typeVisite;
  final String fichier;

  ModelPV({
    required this.typeRapport,
    required this.projet,
    required this.tranche,
    required this.nature,
    required this.typeVisite,
    required this.fichier,
  });
}

class _ConfigurationsPvPageState extends State<ConfigurationsPvPage> {
  List<ModelPV> models = [
    ModelPV(
      typeRapport: 'Générique',
      projet: 'Tous',
      tranche: 'Toutes',
      nature: 'Toutes',
      typeVisite: 'Tous',
      fichier: 'Multi-RapportTicket (3).mrt',
    ),
    ModelPV(
      typeRapport: 'Standard',
      projet: 'Projet7',
      tranche: 'Toutes',
      nature: 'Toutes',
      typeVisite: 'Réclamation',
      fichier: 'RapportTicket (3).mrt',
    ),
    ModelPV(
      typeRapport: 'Standard',
      projet: 'Projet7',
      tranche: 'Toutes',
      nature: 'Toutes',
      typeVisite: 'Livraison Syndic',
      fichier: 'RapportTicket (3).mrt',
    ),
    ModelPV(
      typeRapport: 'Standard',
      projet: 'Projet7',
      tranche: 'Toutes',
      nature: 'Toutes',
      typeVisite: 'Client',
      fichier: 'RapportTicket (3).mrt',
    ),
    ModelPV(
      typeRapport: 'Standard',
      projet: 'Projet7',
      tranche: 'Toutes',
      nature: 'Toutes',
      typeVisite: 'Livraison',
      fichier: 'RapportTicket (3).mrt',
    ),
    ModelPV(
      typeRapport: 'Standard',
      projet: 'Projet7',
      tranche: 'Toutes',
      nature: 'Toutes',
      typeVisite: 'Technique',
      fichier: 'RapportTicket (3).mrt',
    ),
  ];

  String rechercheGlobale = '';
  String selectedTypeRapport = 'Tous les types';
  String selectedProjet = 'Tous les projets';
  String selectedTranche = 'Toutes les tranches';
  String selectedNature = 'Toutes les natures';
  String selectedTypeVisite = 'Tous les types';

  final List<String> typeRapports = ['Tous les types', 'Générique', 'Standard'];
  final List<String> projets = ['Tous les projets', 'Projet7', 'Projet2'];
  final List<String> tranches = ['Toutes les tranches', 'Tranche1', 'Tranche2', 'Tranche3'];
  final List<String> natures = ['Toutes les natures', 'Bien', 'Prestataire'];
  final List<String> typeVisites = ['Tous les types', 'Réclamation', 'Livraison Syndic', 'Client', 'Livraison', 'Technique'];

  void _deleteModel(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer ce modèle ?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              setState(() => models.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Modèle supprimé'), backgroundColor: Colors.red),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _downloadFile(String filename) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Téléchargement de $filename'), backgroundColor: Colors.green),
    );
  }

  void _ajouterVisite() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddVisitFlow()),
    );
  }

  List<ModelPV> get _filteredModels {
    return models.where((model) {
      if (rechercheGlobale.isNotEmpty) {
        final searchLower = rechercheGlobale.toLowerCase();
        if (!model.typeRapport.toLowerCase().contains(searchLower) &&
            !model.projet.toLowerCase().contains(searchLower) &&
            !model.fichier.toLowerCase().contains(searchLower)) {
          return false;
        }
      }
      if (selectedTypeRapport != 'Tous les types' && model.typeRapport != selectedTypeRapport) return false;
      if (selectedProjet != 'Tous les projets' && model.projet != selectedProjet) return false;
      if (selectedTranche != 'Toutes les tranches' && model.tranche != selectedTranche) return false;
      if (selectedNature != 'Toutes les natures' && model.nature != selectedNature) return false;
      if (selectedTypeVisite != 'Tous les types' && model.typeVisite != selectedTypeVisite) return false;
      return true;
    }).toList();
  }

  void _showAddModal() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: NewAddModelForm(
            onModelAdded: (newModel) {
              setState(() {
                models.add(newModel);
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredModels = _filteredModels;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      appBar: AppBar(
        title: const Text(
          'Gestion des Modèles PV',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        backgroundColor: const Color(0xFFEFF6FF),
        elevation: 0.5,
        centerTitle: false,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showAddModal,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'Ajouter un modèle',
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    onChanged: (v) => setState(() => rechercheGlobale = v),
                    decoration: InputDecoration(
                      hintText: 'Chercher...',
                      prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(
                          icon: Icons.article_outlined,
                          label: selectedTypeRapport != 'Tous les types' ? selectedTypeRapport : 'Type Rapport',
                          onTap: () => _showFilterSheet(context, 'Type Rapport', typeRapports, selectedTypeRapport, (v) => setState(() => selectedTypeRapport = v), showSearch: false),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          icon: Icons.folder_outlined,
                          label: selectedProjet != 'Tous les projets' ? selectedProjet : 'Projet',
                          onTap: () => _showFilterSheet(context, 'Projet', projets, selectedProjet, (v) => setState(() => selectedProjet = v), showSearch: true),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          icon: Icons.layers_outlined,
                          label: selectedTranche != 'Toutes les tranches' ? selectedTranche : 'Tranche',
                          onTap: () => _showFilterSheet(context, 'Tranche', tranches, selectedTranche, (v) => setState(() => selectedTranche = v), showSearch: true),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          icon: Icons.category_outlined,
                          label: selectedNature != 'Toutes les natures' ? selectedNature : 'Nature',
                          onTap: () => _showFilterSheet(context, 'Nature', natures, selectedNature, (v) => setState(() => selectedNature = v), showSearch: false),
                        ),
                        const SizedBox(width: 8),
                        _buildFilterChip(
                          icon: Icons.event_note_outlined,
                          label: selectedTypeVisite != 'Tous les types' ? selectedTypeVisite : 'Type Visite',
                          onTap: () => _showFilterSheet(context, 'Type Visite', typeVisites, selectedTypeVisite, (v) => setState(() => selectedTypeVisite = v), showSearch: false),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTypeRapport = 'Tous les types';
                              selectedProjet = 'Tous les projets';
                              selectedTranche = 'Toutes les tranches';
                              selectedNature = 'Toutes les natures';
                              selectedTypeVisite = 'Tous les types';
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 1)),
                              ],
                            ),
                            child: const Text('Réinitialiser', style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            filteredModels.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.description_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun modèle trouvé',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredModels.length,
                    itemBuilder: (context, index) {
                      final model = filteredModels[index];
                      final originalIndex = models.indexOf(model);
                      return _buildModelCard(model, originalIndex);
                    },
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Affichage de ${filteredModels.length} modèle(s)',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
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
          backgroundColor: const Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          elevation: 6,
          shape: const CircleBorder(),
          tooltip: 'Ajouter une visite',
          child: const Icon(Icons.add, size: 34),
        ),
      ),
    );
  }

  void _showFilterSheet(
    BuildContext context,
    String title,
    List<String> options,
    String? currentValue,
    Function(String) onSelected, {
    required bool showSearch,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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

  Widget _buildModelCard(ModelPV model, int index) {
    Color getBadgeColor(String type) {
      switch (type) {
        case 'Générique':
          return Colors.green;
        case 'Standard':
          return Colors.blue;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: getBadgeColor(model.typeRapport).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: getBadgeColor(model.typeRapport).withOpacity(0.3)),
                    ),
                    child: Text(
                      model.typeRapport,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: getBadgeColor(model.typeRapport),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.insert_drive_file, size: 16, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        model.fichier,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(Icons.business_outlined, 'Projet', model.projet),
                  ),
                  Expanded(
                    child: _buildInfoRow(Icons.layers_outlined, 'Tranche', model.tranche),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(Icons.category_outlined, 'Nature', model.nature),
                  ),
                  Expanded(
                    child: _buildInfoRow(Icons.event_note_outlined, 'Type Visite', model.typeVisite),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _downloadFile(model.fichier),
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Télécharger'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: BorderSide(color: Colors.green.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _deleteModel(index),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Supprimer'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF64748B)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.w500),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== FORMULAIRE D'AJOUT DE MODÈLE ====================
class NewAddModelForm extends StatefulWidget {
  final Function(ModelPV) onModelAdded;

  const NewAddModelForm({super.key, required this.onModelAdded});

  @override
  State<NewAddModelForm> createState() => _NewAddModelFormState();
}

class _NewAddModelFormState extends State<NewAddModelForm> {
  String? selectedTypeRapport;
  String? selectedProjet;
  String? selectedTranche;
  String? selectedNature;
  String? selectedTypeVisite;
  String? selectedFichierName;

  final List<String> allTypeRapports = ['Standard', 'Générique'];
  final List<String> allProjets = ['Projet1', 'Projet2', 'Projet3', 'Projet4', 'Projet5', 'Projet6', 'Projet7'];
  final List<String> allTranches = ['Toutes (Générique)', 'Tranche1', 'Tranche2', 'Tranche3', 'Tranche4', 'Tranche5'];
  final List<String> allNatures = ['Toutes (Générique)', 'Bien', 'Prestataire'];
  final List<String> allTypeVisites = ['Réclamation', 'Livraison Syndic', 'Client', 'Livraison', 'Technique'];

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mrt'],
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          selectedFichierName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la sélection du fichier'), backgroundColor: Colors.red),
      );
    }
  }

  void _submit() {
    if (selectedTypeRapport == null) {
      _showError('Veuillez sélectionner un type de rapport');
      return;
    }
    if (selectedProjet == null) {
      _showError('Veuillez sélectionner un projet');
      return;
    }
    if (selectedTypeVisite == null) {
      _showError('Veuillez sélectionner un type de visite');
      return;
    }
    if (selectedFichierName == null) {
      _showError('Veuillez sélectionner un fichier .mrt');
      return;
    }

    final newModel = ModelPV(
      typeRapport: selectedTypeRapport!,
      projet: selectedProjet!,
      tranche: selectedTranche ?? 'Toutes',
      nature: selectedNature ?? 'Toutes',
      typeVisite: selectedTypeVisite!,
      fichier: selectedFichierName!,
    );

    widget.onModelAdded(newModel);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Modèle ajouté avec succès'), backgroundColor: Colors.green),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Nouveau Modèle PV',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            
            // Type de Rapport *
            _buildLabel('Type de Rapport *'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedTypeRapport,
              items: allTypeRapports,
              hint: 'Sélectionner un type',
              onChanged: (v) => setState(() => selectedTypeRapport = v),
            ),
            const SizedBox(height: 20),
            
            // Projet *
            _buildLabel('Projet *'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedProjet,
              items: allProjets,
              hint: 'Sélectionner un projet',
              onChanged: (v) => setState(() => selectedProjet = v),
            ),
            const SizedBox(height: 20),
            
            // Tranche
            const Text('Tranche', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedTranche,
              items: allTranches,
              hint: 'Toutes (Générique)',
              onChanged: (v) => setState(() => selectedTranche = v),
            ),
            const SizedBox(height: 20),
            
            // Nature de Bien
            const Text('Nature de Bien', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedNature,
              items: allNatures,
              hint: 'Toutes (Générique)',
              onChanged: (v) => setState(() => selectedNature = v),
            ),
            const SizedBox(height: 20),
            
            // Type de Visite *
            _buildLabel('Type de Visite *'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: selectedTypeVisite,
              items: allTypeVisites,
              hint: 'Sélectionner le type',
              onChanged: (v) => setState(() => selectedTypeVisite = v),
            ),
            const SizedBox(height: 20),
            
            // Modèle (.mrt) *
            _buildLabel('Modèle (.mrt) *'),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickFile,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.cloud_upload_outlined, color: const Color(0xFF1E40AF), size: 20),
                    const SizedBox(width: 12),
                    Text(
                      selectedFichierName ?? 'Téléverser un fichier',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: selectedFichierName != null ? FontWeight.w500 : FontWeight.normal,
                        color: selectedFichierName != null ? const Color(0xFF1E293B) : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedFichierName == null)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  'Fichiers .MRT uniquement',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
            const SizedBox(height: 32),
            
            // Boutons
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
                    child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
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

  Widget _buildLabel(String text) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: text.replaceAll(' *', ''), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
          if (text.contains('*'))
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
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: Colors.grey[600])),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1E40AF)),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Row(
                children: [
                  if (value == item)
                    const Icon(Icons.check, size: 16, color: Color(0xFF1E40AF)),
                  if (value == item) const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
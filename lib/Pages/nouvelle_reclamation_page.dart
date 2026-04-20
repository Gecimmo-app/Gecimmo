// lib/Pages/nouvelle_reclamation_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/reclamation_service.dart';

class NouvelleReclamationPage extends StatefulWidget {
  const NouvelleReclamationPage({super.key});

  @override
  State<NouvelleReclamationPage> createState() =>
      _NouvelleReclamationPageState();
}

class _NouvelleReclamationPageState extends State<NouvelleReclamationPage> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedType;
  String? _selectedProjet;
  String? _selectedPriorite;
  bool _loading = false;

  final List<String> _types = [
    'Technique',
    'Commercial',
    'Facturation',
    'Autre'
  ];
  final List<String> _projets = ['Projet A', 'Projet B', 'Projet C'];
  final List<String> _priorites = ['Haute', 'Moyenne', 'Basse'];

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nomController.text.isEmpty ||
        _prenomController.text.isEmpty ||
        _telController.text.isEmpty ||
        _selectedType == null ||
        _selectedProjet == null ||
        _selectedPriorite == null ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final reclamation = await ReclamationService.create(
        nom: '${_nomController.text} ${_prenomController.text}',
        tel: '+212 ${_telController.text}',
        description: _descriptionController.text,
        priorite: _selectedPriorite!,
        type: _selectedType!,
        sousType: 'Autre',
        observation: _descriptionController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Réclamation créée avec succès'),
            backgroundColor: Color(0xFF22C55E),
          ),
        );
        // Retourne l'objet Reclamation à la page liste
        Navigator.pop(context, reclamation);
      }
    } catch (e) {
      // Fallback local si l'API n'est pas accessible
      if (mounted) {
        final localReclamation = Reclamation(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nom: '${_nomController.text} ${_prenomController.text}',
          tel: '+212 ${_telController.text}',
          description: _descriptionController.text,
          priorite: _selectedPriorite!,
          statut: 'Nouveau',
          type: _selectedType!,
          sousType: 'Autre',
          observation: _descriptionController.text,
          date: DateTime.now().toString().substring(0, 10),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Réclamation créée localement'),
            backgroundColor: Color(0xFF22C55E),
          ),
        );
        Navigator.pop(context, localReclamation);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _loading ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          'Nouvelle Réclamation',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_loading)
            IconButton(
              icon: const Icon(Icons.save_outlined, color: Color(0xFF2563EB)),
              onPressed: _submit,
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(
                      label: 'Nom',
                      hint: 'Entrez votre nom',
                      controller: _nomController,
                    ),
                    const SizedBox(height: 14),
                    _buildField(
                      label: 'Prénom',
                      hint: 'Entrez votre prénom',
                      controller: _prenomController,
                    ),
                    const SizedBox(height: 14),

                    // Téléphone
                    _buildLabel('Numéro de téléphone'),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        border: Border.all(color: const Color(0xFFD1D5DB)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 13),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xFFD1D5DB)),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.phone_outlined,
                                    size: 14, color: Colors.black45),
                                SizedBox(width: 4),
                                Text('+212',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black54)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _telController,
                              keyboardType: TextInputType.phone,
                              maxLength: 9,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9),
                              ],
                              style: const TextStyle(fontSize: 13),
                              decoration: const InputDecoration(
                                hintText: '06 XX XX XX XX',
                                hintStyle: TextStyle(
                                    color: Colors.black38, fontSize: 13),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Type
                    _buildLabel('Type de réclamation'),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      hint: 'Sélectionner un type',
                      value: _selectedType,
                      items: _types,
                      onChanged: (v) => setState(() => _selectedType = v),
                    ),
                    const SizedBox(height: 14),

                    // Projet
                    _buildLabel('Projet'),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      hint: 'Sélectionner un projet',
                      value: _selectedProjet,
                      items: _projets,
                      onChanged: (v) => setState(() => _selectedProjet = v),
                    ),
                    const SizedBox(height: 14),

                    // Priorité
                    _buildLabel('Priorité'),
                    const SizedBox(height: 6),
                    _buildDropdown(
                      hint: 'Sélectionner une priorité',
                      value: _selectedPriorite,
                      items: _priorites,
                      onChanged: (v) =>
                          setState(() => _selectedPriorite = v),
                    ),
                    const SizedBox(height: 14),

                    // Description
                    _buildLabel('Description'),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        border: Border.all(color: const Color(0xFFD1D5DB)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 5,
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'Décrire la réclamation...',
                          hintStyle: TextStyle(
                              color: Colors.black38, fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bouton Créer
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              const Color(0xFF93C5FD),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Créer',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87)),
        const Text(' *',
            style: TextStyle(color: Color(0xFFEF4444), fontSize: 13)),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle:
                  const TextStyle(color: Colors.black38, fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 13),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint,
              style:
                  const TextStyle(fontSize: 13, color: Colors.black38)),
          icon: const Icon(Icons.keyboard_arrow_down,
              size: 18, color: Colors.black45),
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
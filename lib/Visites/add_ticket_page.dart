import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddTicketPage extends StatefulWidget {
  const AddTicketPage({super.key});

  @override
  State<AddTicketPage> createState() => _AddTicketPageState();
}

class _AddTicketPageState extends State<AddTicketPage> {
  int currentStep = 0;
  final PageController _pageController = PageController();
  
  // ============ NATURE VISITE SELECTION ============
  String? selectedNatureVisite;
  
  // Step 1 fields (Partie Commune)
  String? selectedNatureStructure;
  String? selectedTranche;
  String? selectedGroupement;
  String? selectedPiloteTechnique;
  
  // Step 1 fields (Bien - additional)
  String? selectedImmeuble;
  String? selectedEtage;
  String? selectedBien;
  String? selectedPiloteLivraison;
  
  // Step 2
  String? selectedPlan;
  final List<String> plans = ['Plan 1 - RDC', 'Plan 2 - 1er étage', 'Plan 3 - 2ème étage'];
  
  // Step 3
  String? selectedLocalite;
  String? selectedCorpsMetier;
  String? selectedPrestataire;
  final TextEditingController observationController = TextEditingController();
  List<File> attachedFiles = [];
  
  // Lists des observations ajoutées
  List<Map<String, dynamic>> addedObservations = [];
  
  // ============ OPTIONS ============
  final List<String> natureVisiteOptions = [
    'Partie Commune',
    'Bien',
  ];
  
  final List<String> natureStructureOptions = [
    'Appartement',
    'Maison',
    'Villa',
    'Bureau',
    'Local commercial',
    'Extralimmeuble',
  ];
  
  final List<String> trancheOptions = [
    'Tranche1', 'Tranche2', 'Tranche3', 'Tranche4', 'Tranche5', 'Tranche6', 'Tranche7', 'Tranche8', 'Tranche9', 'Tranche10', 'Tranche11', 'Tranche12', 'Tranche13', 'Tranche14',
  ];
  
  final List<String> groupementOptions = [
    'GH1.1', 'GH1.2', 'GH2.1', 'GH2.2', 'GH3.1',
  ];
  
  final List<String> immeubleOptions = [
    'I1', 'I2', 'I3', 'I4', 'I5',
  ];
  
  final List<String> etageOptions = [
    'Rez-de-chaussée', '1er étage', '2ème étage', '3ème étage', '4ème étage',
  ];
  
  final List<String> bienOptions = [
    'Bien1', 'Bien2', 'Bien3', 'Bien4', 'Bien5', 'Bien6', 'Bien7', 'Bien8', 'Bien9', 'Bien10',
  ];
  
  final List<String> piloteTechniqueOptions = [
    'Admin user', 'Technicien 1', 'Technicien 2', 'utilisateur10013',
  ];
  
  final List<String> piloteLivraisonOptions = [
    'Admin user', 'Livraison 1', 'Livraison 2',
  ];
  
  final List<String> localiteOptions = ['Bureau', 'Salon', 'Cuisine', 'Chambre', 'Chambre d\'enfant'];
  final List<String> corpsMetierOptions = ['Plomberie', 'Électricité', 'Peinture', 'Maçonnerie'];
  final List<String> prestataireOptions = ['Prestataire 1', 'Prestataire 2', 'Prestataire 3'];

  void _nextStep() {
    if (currentStep < 3) {
      setState(() => currentStep++);
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _onPrimaryFooterPressed() {
    if (currentStep == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ticket validé avec succès")),
      );
      Navigator.pop(context);
      return;
    }
    _nextStep();
  }

  void _goToStep(int step) {
    setState(() => currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _closeDialog() => Navigator.pop(context);

  void _addAttachment() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          attachedFiles.add(File(result.files.single.path!));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la sélection de l'image")),
      );
    }
  }

  void _addObservation() {
    if (selectedLocalite == null || selectedCorpsMetier == null || selectedPrestataire == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs obligatoires")),
      );
      return;
    }
    
    setState(() {
      addedObservations.add({
        'localite': selectedLocalite,
        'corpsMetier': selectedCorpsMetier,
        'prestataire': selectedPrestataire,
        'observation': observationController.text,
        'files': List.from(attachedFiles),
      });
      
      selectedLocalite = null;
      selectedCorpsMetier = null;
      selectedPrestataire = null;
      observationController.clear();
      attachedFiles.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Observation ajoutée avec succès")),
    );
  }

  void _showImagePreview(File file) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        file.path.split(Platform.pathSeparator).last,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Image.file(file, fit: BoxFit.contain),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E40AF)),
                  child: const Text("Fermer"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Création du ticket", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: _closeDialog, icon: const Icon(Icons.close, size: 22, color: Colors.grey), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  _buildStep(0, "Création", Icons.checklist),
                  _buildStepLine(),
                  _buildStep(1, "Pointer", Icons.map),
                  _buildStepLine(),
                  _buildStep(2, "Observation", Icons.add_comment),
                  _buildStepLine(),
                  _buildStep(3, "Recap", Icons.summarize),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => currentStep = index),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep0(),
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFE2E8F0)))),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _closeDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE74C3C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Annuler", style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _closeDialog,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey,
                        side: BorderSide(color: Colors.grey[400]!),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Fermer", style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onPrimaryFooterPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentStep == 3 ? const Color(0xFF27AE60) : const Color(0xFF1E40AF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(currentStep == 3 ? "Valider" : "Suivant", style: const TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStep(int index, String label, IconData icon) {
    bool isActive = currentStep == index;
    bool isCompleted = currentStep > index;
    return Expanded(
      child: Column(
        children: [
          Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: isActive ? const Color(0xFF1E40AF) : Colors.grey[300], shape: BoxShape.circle), child: Icon(isCompleted ? Icons.check : icon, size: 14, color: Colors.white)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 9, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? const Color(0xFF1E40AF) : Colors.grey), textAlign: TextAlign.center),
          Container(margin: const EdgeInsets.only(top: 2), height: 2, width: 30, color: isActive ? const Color(0xFF1E40AF) : Colors.transparent),
        ],
      ),
    );
  }
  
  Widget _buildStepLine() => Expanded(child: Container(height: 1, color: Colors.grey[300], margin: const EdgeInsets.only(bottom: 24)));

  Widget _buildStep0() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildRequiredField("Nature visite", DropdownButtonFormField<String>(
            value: selectedNatureVisite,
            hint: const Text("Sélectionner une nature visite"),
            items: natureVisiteOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
            onChanged: (value) {
              setState(() {
                selectedNatureVisite = value;
                selectedNatureStructure = null;
                selectedTranche = null;
                selectedGroupement = null;
                selectedImmeuble = null;
                selectedEtage = null;
                selectedBien = null;
                selectedPiloteTechnique = null;
                selectedPiloteLivraison = null;
              });
            },
            decoration: _inputDecoration(),
            isExpanded: true,
          )),
          const SizedBox(height: 16),
          
          if (selectedNatureVisite == "Partie Commune") ...[
            _buildRequiredField("Nature structure", DropdownButtonFormField<String>(
              value: selectedNatureStructure,
              hint: const Text("Sélectionner une nature structure"),
              items: natureStructureOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => selectedNatureStructure = v),
              decoration: _inputDecoration(),
              isExpanded: true,
            )),
            const SizedBox(height: 16),
            _buildRequiredField("Tranche", DropdownButtonFormField<String>(
              value: selectedTranche,
              hint: const Text("Sélectionner une tranche"),
              items: trancheOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => selectedTranche = v),
              decoration: _inputDecoration(),
              isExpanded: true,
            )),
            const SizedBox(height: 16),
            _buildRequiredField("Groupement", DropdownButtonFormField<String>(
              value: selectedGroupement,
              hint: const Text("Sélectionner un groupement"),
              items: groupementOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => selectedGroupement = v),
              decoration: _inputDecoration(),
              isExpanded: true,
            )),
            const SizedBox(height: 16),
            _buildRequiredField("Pilote technique", DropdownButtonFormField<String>(
              value: selectedPiloteTechnique,
              hint: const Text("Sélectionner un pilote technique"),
              items: piloteTechniqueOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => selectedPiloteTechnique = v),
              decoration: _inputDecoration(),
              isExpanded: true,
            )),
          ],
          
          if (selectedNatureVisite == "Bien") ...[
            _buildRequiredField("Tranche", DropdownButtonFormField<String>(
              value: selectedTranche,
              hint: const Text("Sélectionner une tranche"),
              items: trancheOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => selectedTranche = v),
              decoration: _inputDecoration(),
              isExpanded: true,
            )),
            const SizedBox(height: 16),
            _buildRequiredField("Groupement", DropdownButtonFormField<String>(
              value: selectedGroupement,
              hint: const Text("Sélectionner un groupement"),
              items: groupementOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => selectedGroupement = v),
              decoration: _inputDecoration(),
              isExpanded: true,
            )),
            const SizedBox(height: 16),
            _buildRequiredField("Immeuble", DropdownButtonFormField<String>(
              value: selectedImmeuble,
              hint: const Text("Sélectionner un immeuble"),
              items: immeubleOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => selectedImmeuble = v),
              decoration: _inputDecoration(),
              isExpanded: true,
            )),
            const SizedBox(height: 16),
            _buildRequiredField("Etage", DropdownButtonFormField<String>(
              value: selectedEtage,
              hint: const Text("Sélectionner un étage"),
              items: etageOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => selectedEtage = v),
              decoration: _inputDecoration(),
              isExpanded: true,
            )),
            const SizedBox(height: 16),
            _buildRequiredField("Bien", DropdownButtonFormField<String>(
              value: selectedBien,
              hint: const Text("Sélectionner un bien"),
              items: bienOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => selectedBien = v),
              decoration: _inputDecoration(),
              isExpanded: true,
            )),
            const SizedBox(height: 16),
            _buildRequiredField("Pilote technique", DropdownButtonFormField<String>(
              value: selectedPiloteTechnique,
              hint: const Text("Sélectionner un pilote technique"),
              items: piloteTechniqueOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => selectedPiloteTechnique = v),
              decoration: _inputDecoration(),
              isExpanded: true,
            )),
            const SizedBox(height: 16),
            _buildRequiredField("Pilote de livraison", DropdownButtonFormField<String>(
              value: selectedPiloteLivraison,
              hint: const Text("Sélectionner un pilote livraison"),
              items: piloteLivraisonOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: (v) => setState(() => selectedPiloteLivraison = v),
              decoration: _inputDecoration(),
              isExpanded: true,
            )),
          ],
          
          if (selectedNatureVisite == null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
              child: const Center(child: Text("Veuillez sélectionner une nature visite", style: TextStyle(color: Color(0xFF64748B)))),
            ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          final isSelected = selectedPlan == plan;
          return GestureDetector(
            onTap: () => setState(() => selectedPlan = plan),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? const Color(0xFF1E40AF) : Colors.grey[300]!, width: isSelected ? 2 : 1),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.map, size: 40, color: isSelected ? const Color(0xFF1E40AF) : Colors.grey[400]),
                const SizedBox(height: 8),
                Text(plan, style: TextStyle(fontSize: 11, color: isSelected ? const Color(0xFF1E40AF) : Colors.grey[600]), textAlign: TextAlign.center),
                if (isSelected) Padding(padding: const EdgeInsets.only(top: 8), child: Icon(Icons.check_circle, size: 18, color: const Color(0xFF1E40AF))),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRequiredField("Localité", DropdownButtonFormField<String>(
            value: selectedLocalite,
            hint: const Text("Sélectionner une localité"),
            items: localiteOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
            onChanged: (v) => setState(() => selectedLocalite = v),
            decoration: _inputDecoration(),
            isExpanded: true,
          )),
          const SizedBox(height: 16),
          _buildRequiredField("Corps de métier", DropdownButtonFormField<String>(
            value: selectedCorpsMetier,
            hint: const Text("Sélectionner un corps de métier"),
            items: corpsMetierOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
            onChanged: (v) => setState(() => selectedCorpsMetier = v),
            decoration: _inputDecoration(),
            isExpanded: true,
          )),
          const SizedBox(height: 16),
          _buildRequiredField("Prestataire", DropdownButtonFormField<String>(
            value: selectedPrestataire,
            hint: const Text("Sélectionner un prestataire"),
            items: prestataireOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
            onChanged: (v) => setState(() => selectedPrestataire = v),
            decoration: _inputDecoration(),
            isExpanded: true,
          )),
          const SizedBox(height: 16),
          const Text("Observation", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
          const SizedBox(height: 8),
          TextField(
            controller: observationController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Entrez votre observation...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1E40AF))),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 16),
          const Text("Attachments", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!, width: 1.5), borderRadius: BorderRadius.circular(10), color: Colors.grey[50]),
            child: Column(
              children: [
                InkWell(
                  onTap: _addAttachment,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(children: [Icon(Icons.cloud_upload, size: 32, color: Colors.grey[400]), const SizedBox(height: 6), Text("Cliquez pour sélectionner", style: TextStyle(fontSize: 11, color: Colors.grey[500]))]),
                  ),
                ),
                if (attachedFiles.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[200]!))),
                    child: Column(children: attachedFiles.map((file) => ListTile(leading: const Icon(Icons.image, size: 18, color: Color(0xFF1E40AF)), title: Text(file.path.split(Platform.pathSeparator).last, style: const TextStyle(fontSize: 12)), trailing: IconButton(icon: const Icon(Icons.close, size: 16, color: Colors.grey), onPressed: () => setState(() => attachedFiles.remove(file))), dense: true)).toList()),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addObservation,
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Ajouter une observation"),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E40AF), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ============ STEP 3: RECAP ET VALIDATION ============
  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Informations du ticket",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 16),
                if (selectedNatureVisite == "Bien")
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRecapInfoField("Nature visite", selectedNatureVisite ?? "—"),
                            const SizedBox(height: 12),
                            _buildRecapInfoField("Tranche", selectedTranche ?? "—"),
                            const SizedBox(height: 12),
                            _buildRecapInfoField("Groupement", selectedGroupement ?? "—"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRecapInfoField("Immeuble", selectedImmeuble ?? "—"),
                            const SizedBox(height: 12),
                            _buildRecapInfoField("Etage", selectedEtage ?? "—"),
                            const SizedBox(height: 12),
                            _buildRecapInfoField("Bien", selectedBien ?? "—"),
                            const SizedBox(height: 12),
                            _buildRecapInfoField("Pilote Livraison", selectedPiloteLivraison ?? "—"),
                          ],
                        ),
                      ),
                    ],
                  )
                else if (selectedNatureVisite == "Partie Commune")
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRecapInfoField("Nature visite", selectedNatureVisite ?? "—"),
                            const SizedBox(height: 12),
                            _buildRecapInfoField("Nature structure", selectedNatureStructure ?? "—"),
                            const SizedBox(height: 12),
                            _buildRecapInfoField("Tranche", selectedTranche ?? "—"),
                            const SizedBox(height: 12),
                            _buildRecapInfoField("Groupement", selectedGroupement ?? "—"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildRecapInfoField("Pilote technique", selectedPiloteTechnique ?? "—"),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  _buildRecapInfoField("Nature visite", selectedNatureVisite ?? "Non sélectionné"),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 12),
                _buildRecapInfoField("Plan sélectionné", selectedPlan ?? "Non sélectionné"),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Observations ajoutées",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2196F3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${addedObservations.length} observation(s)",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                ...addedObservations.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final obs = entry.value;
                  final files = (obs['files'] as List?) ?? [];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(
                                  "Observation #$idx",
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _goToStep(1),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2196F3),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text("Voir sur plan", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildDetailGrid("Localité", obs['localite']?.toString() ?? "—")),
                              Expanded(child: _buildDetailGrid("Corps de métier", obs['corpsMetier']?.toString() ?? "—")),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildDetailGrid("Préstataire", obs['prestataire']?.toString() ?? "—"),
                          if (obs['observation'] != null && obs['observation'].toString().isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text("Observation", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8))),
                            const SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                obs['observation'].toString(),
                                style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                              ),
                            ),
                          ],
                          if (files.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              "Fichiers attachés (${files.length})",
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8)),
                            ),
                            const SizedBox(height: 8),
                            ...files.map((file) {
                              final File f = file as File;
                              final name = f.path.split(Platform.pathSeparator).last;
                              final kb = (f.lengthSync() / 1024).toStringAsFixed(2);
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "$kb KB • image",
                                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                          ),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => _showImagePreview(f),
                                      child: const Text(
                                        "Voir l'image",
                                        style: TextStyle(fontSize: 12, color: Color(0xFF2196F3), fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                  child: OutlinedButton(
                    onPressed: () => _goToStep(2),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2196F3),
                      backgroundColor: const Color(0xFFEFF6FF),
                      side: const BorderSide(color: Color(0xFF2196F3)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "Ajouter une autre observation",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRecapInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailGrid(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
        ),
      ],
    );
  }

  Widget _buildRequiredField(String label, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(text: TextSpan(children: [TextSpan(text: label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))), const TextSpan(text: " *", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red))])),
      const SizedBox(height: 6),
      child,
    ],
  );

  InputDecoration _inputDecoration() => InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF1E40AF))),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    isDense: true,
  );

}
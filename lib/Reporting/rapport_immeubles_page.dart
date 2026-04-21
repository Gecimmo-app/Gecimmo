// rapport_immeubles_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/fintech_filter_components.dart';

class RapportImmeublesPage extends StatefulWidget {
  const RapportImmeublesPage({super.key});

  @override
  State<RapportImmeublesPage> createState() => _RapportImmeublesPageState();
}

class _RapportImmeublesPageState extends State<RapportImmeublesPage> {
  // Brand Base colors
  static const Color primaryColor = Color(0xFF1E40AF);
  static const Color bgColor = Color(0xFFF8FAFC);

  // Current active smart filters state map
  Map<String, String?> currentFilters = {
    'projet': null,
    'tranche': null,
    'groupement': null,
    'statut': null,
    'corps_metier': null,
    'localite': null,
  };

  // Selected quick filter states (Horizontal bar)
  final Set<String> _quickFilters = {"En cours"}; 

  int _getActiveFilterCount() {
    int count = 0;
    for (var value in currentFilters.values) {
      if (value != null) count++;
    }
    return count;
  }

  void _openAdvancedSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AdvancedFilterModal(
        currentFilters: currentFilters,
        onApply: (updatedFilters) {
          setState(() {
            currentFilters = updatedFilters;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSmartFilterBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildGlassmorphicEmptyState(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add, size: 28),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Rapports",
            style: TextStyle(
              fontSize: 28, 
              fontWeight: FontWeight.w900, 
              color: Color(0xFF0F172A),
              letterSpacing: -0.5
            ),
          ),
          FintechGradientButton(
            label: "Générer PDF",
            icon: Icons.picture_as_pdf_outlined,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSmartFilterBar() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ActionChip(
              onPressed: _openAdvancedSheet,
              backgroundColor: const Color(0xFFEFF6FF),
              elevation: 0,
              pressElevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: primaryColor.withOpacity(0.2)),
              ),
              avatar: const Icon(Icons.tune_rounded, size: 16, color: primaryColor),
              label: Text(
                "Filtres Avancés${_getActiveFilterCount() > 0 ? ' (${_getActiveFilterCount()})' : ''}",
                style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 13),
              ),
            ),
          ),
          FastFilterChip(
            label: "En cours",
            isSelected: _quickFilters.contains("En cours"),
            icon: Icons.autorenew_outlined,
            onTap: () {
              setState(() {
                _quickFilters.contains("En cours") ? _quickFilters.remove("En cours") : _quickFilters.add("En cours");
              });
            },
          ),
          FastFilterChip(
            label: "Terminé",
            isSelected: _quickFilters.contains("Terminé"),
            icon: Icons.check_circle_outline,
            onTap: () {
              setState(() {
                _quickFilters.contains("Terminé") ? _quickFilters.remove("Terminé") : _quickFilters.add("Terminé");
              });
            },
          ),
          FastFilterChip(
            label: "Litige",
            isSelected: _quickFilters.contains("Litige"),
            icon: Icons.warning_amber_rounded,
            onTap: () {
              setState(() {
                _quickFilters.contains("Litige") ? _quickFilters.remove("Litige") : _quickFilters.add("Litige");
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Colors.white.withOpacity(0.8), 
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 30, spreadRadius: -5)
                ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        )
                      ]
                    ),
                    child: const Icon(
                      Icons.query_stats_rounded,
                      size: 64,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "En attente de critères",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Veuillez appliquer des filtres depuis la barre rapide ou le menu avancé pour générer et prévisualiser les rapports structurés.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blueGrey.shade500,
                      height: 1.6,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== MODAL FILTRES AVANCÉS AVEC RECHERCHE (CORRIGÉ) ====================
class _AdvancedFilterModal extends StatefulWidget {
  final Map<String, String?> currentFilters;
  final Function(Map<String, String?>) onApply;

  const _AdvancedFilterModal({
    required this.currentFilters,
    required this.onApply,
  });

  @override
  State<_AdvancedFilterModal> createState() => _AdvancedFilterModalState();
}

class _AdvancedFilterModalState extends State<_AdvancedFilterModal> {
  late Map<String, String?> _tempFilters;
  
  // Search controllers for each dropdown
  String _searchProjet = '';
  String _searchTranche = '';
  String _searchGroupement = '';
  String _searchStatut = '';
  String _searchCorpsMetier = '';
  String _searchLocalite = '';

  // Sample data for dropdowns
  final List<String> _projets = ['Projet1', 'Projet2', 'Projet3', 'Projet4', 'Projet5', 'Projet6', 'Projet7', 'Projet8', 'Projet9', 'Projet10', 'Projet11', 'Projet12', 'Projet13', 'Projet14', 'Projet15'];
  final List<String> _tranches = ['Tranche1', 'Tranche2', 'Tranche3', 'Tranche4', 'Tranche5', 'Tranche6', 'Tranche7', 'Tranche8'];
  final List<String> _groupements = ['GH1', 'GH2', 'GH3', 'GH4', 'GH5', 'GH6'];
  final List<String> _statuts = ['En cours', 'Terminé', 'Litige', 'Annulé', 'En attente'];
  final List<String> _corpsMetiers = ['Plomberie', 'Électricité', 'Maçonnerie', 'Peinture', 'Menuiserie', 'Carrelage', 'Charpenterie'];
  final List<String> _localites = ['Casablanca', 'Rabat', 'Marrakech', 'Tanger', 'Fès', 'Agadir', 'Meknès', 'Oujda', 'Tétouan'];

  List<String> get _filteredProjets {
    if (_searchProjet.isEmpty) return _projets;
    return _projets.where((item) => item.toLowerCase().contains(_searchProjet.toLowerCase())).toList();
  }

  List<String> get _filteredTranches {
    if (_searchTranche.isEmpty) return _tranches;
    return _tranches.where((item) => item.toLowerCase().contains(_searchTranche.toLowerCase())).toList();
  }

  List<String> get _filteredGroupements {
    if (_searchGroupement.isEmpty) return _groupements;
    return _groupements.where((item) => item.toLowerCase().contains(_searchGroupement.toLowerCase())).toList();
  }

  List<String> get _filteredStatuts {
    if (_searchStatut.isEmpty) return _statuts;
    return _statuts.where((item) => item.toLowerCase().contains(_searchStatut.toLowerCase())).toList();
  }

  List<String> get _filteredCorpsMetiers {
    if (_searchCorpsMetier.isEmpty) return _corpsMetiers;
    return _corpsMetiers.where((item) => item.toLowerCase().contains(_searchCorpsMetier.toLowerCase())).toList();
  }

  List<String> get _filteredLocalites {
    if (_searchLocalite.isEmpty) return _localites;
    return _localites.where((item) => item.toLowerCase().contains(_searchLocalite.toLowerCase())).toList();
  }

  @override
  void initState() {
    super.initState();
    _tempFilters = Map.from(widget.currentFilters);
  }

  void _applyFilters() {
    widget.onApply(_tempFilters);
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _tempFilters = {
        'projet': null,
        'tranche': null,
        'groupement': null,
        'statut': null,
        'corps_metier': null,
        'localite': null,
      };
      _searchProjet = '';
      _searchTranche = '';
      _searchGroupement = '';
      _searchStatut = '';
      _searchCorpsMetier = '';
      _searchLocalite = '';
    });
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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filtres Avancés',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: const Text(
                    'Réinitialiser',
                    style: TextStyle(color: Color(0xFF1E40AF)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Projet - avec recherche
            _buildSearchableFilterField(
              label: 'Projet',
              value: _tempFilters['projet'],
              items: _filteredProjets,
              searchValue: _searchProjet,
              onSearchChanged: (v) => setState(() => _searchProjet = v),
              onChanged: (v) => setState(() => _tempFilters['projet'] = v),
            ),
            const SizedBox(height: 16),
            
            // Tranche - avec recherche
            _buildSearchableFilterField(
              label: 'Tranche',
              value: _tempFilters['tranche'],
              items: _filteredTranches,
              searchValue: _searchTranche,
              onSearchChanged: (v) => setState(() => _searchTranche = v),
              onChanged: (v) => setState(() => _tempFilters['tranche'] = v),
            ),
            const SizedBox(height: 16),
            
            // Groupement - avec recherche
            _buildSearchableFilterField(
              label: 'Groupement',
              value: _tempFilters['groupement'],
              items: _filteredGroupements,
              searchValue: _searchGroupement,
              onSearchChanged: (v) => setState(() => _searchGroupement = v),
              onChanged: (v) => setState(() => _tempFilters['groupement'] = v),
            ),
            const SizedBox(height: 16),
            
            // Statut - avec recherche
            _buildSearchableFilterField(
              label: 'Statut',
              value: _tempFilters['statut'],
              items: _filteredStatuts,
              searchValue: _searchStatut,
              onSearchChanged: (v) => setState(() => _searchStatut = v),
              onChanged: (v) => setState(() => _tempFilters['statut'] = v),
            ),
            const SizedBox(height: 16),
            
            // Corps métier - avec recherche
            _buildSearchableFilterField(
              label: 'Corps métier',
              value: _tempFilters['corps_metier'],
              items: _filteredCorpsMetiers,
              searchValue: _searchCorpsMetier,
              onSearchChanged: (v) => setState(() => _searchCorpsMetier = v),
              onChanged: (v) => setState(() => _tempFilters['corps_metier'] = v),
            ),
            const SizedBox(height: 16),
            
            // Localité - avec recherche
            _buildSearchableFilterField(
              label: 'Localité',
              value: _tempFilters['localite'],
              items: _filteredLocalites,
              searchValue: _searchLocalite,
              onSearchChanged: (v) => setState(() => _searchLocalite = v),
              onChanged: (v) => setState(() => _tempFilters['localite'] = v),
            ),
            
            const SizedBox(height: 32),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Appliquer'),
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

  Widget _buildSearchableFilterField({
    required String label,
    required String? value,
    required List<String> items,
    required String searchValue,
    required Function(String) onSearchChanged,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        // Custom dropdown button without using DropdownButton (to avoid the error)
        GestureDetector(
          onTap: () {
            _showCustomDropdown(
              context: context,
              label: label,
              value: value,
              items: items,
              searchValue: searchValue,
              onSearchChanged: onSearchChanged,
              onChanged: onChanged,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? 'Sélectionner $label',
                  style: TextStyle(
                    color: value != null ? const Color(0xFF1E293B) : Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Color(0xFF1E40AF)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCustomDropdown({
    required BuildContext context,
    required String label,
    required String? value,
    required List<String> items,
    required String searchValue,
    required Function(String) onSearchChanged,
    required Function(String?) onChanged,
  }) {
    String tempSearch = searchValue;
    String? tempValue = value;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            List<String> filteredItems = items.where((item) {
              return tempSearch.isEmpty || item.toLowerCase().contains(tempSearch.toLowerCase());
            }).toList();
            
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sélectionner $label',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Rechercher...',
                      prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      isDense: true,
                    ),
                    onChanged: (v) {
                      tempSearch = v;
                      onSearchChanged(v);
                      setStateModal(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.clear, color: Colors.grey),
                          title: const Text('Effacer'),
                          onTap: () {
                            tempValue = null;
                            onChanged(null);
                            Navigator.pop(context);
                          },
                        ),
                        const Divider(),
                        ...filteredItems.map((item) {
                          return ListTile(
                            leading: tempValue == item
                                ? const Icon(Icons.check, color: Color(0xFF1E40AF))
                                : null,
                            title: Text(
                              item,
                              style: TextStyle(
                                fontWeight: tempValue == item ? FontWeight.w600 : FontWeight.normal,
                                color: tempValue == item ? const Color(0xFF1E40AF) : const Color(0xFF1E293B),
                              ),
                            ),
                            onTap: () {
                              tempValue = item;
                              onChanged(item);
                              Navigator.pop(context);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
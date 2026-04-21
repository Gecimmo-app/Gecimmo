import 'package:flutter/material.dart';
import 'details_visite_page.dart';

class VisitesPage extends StatefulWidget {
  const VisitesPage({super.key});

  @override
  State<VisitesPage> createState() => _VisitesPageState();
}

class _VisitesPageState extends State<VisitesPage> {
  /// `true` = grille, `false` = liste (cartes horizontales type maquette).
  bool _isGridView = true;

  // ============ ÉTAT DES FILTRES ============
  String? selectedTypeVisite;
  String? selectedProjet;
  String? selectedUtilisateur;
  DateTimeRange? selectedDateRange;
  String? selectedPeriodePreset;
  String selectedBien = "";
  
  // ============ DONNÉES DES VISITES ============
  List<Map<String, dynamic>> toutesLesVisites = [
    {
      "projet": "Projet1",
      "bien": "Bien4",
      "status": "Traité",
      "color": Colors.orange,
      "tags": ["Réclamation", "F2"],
      "createur": "admin user",
      "type": "Réclamation",
      "dateVisite": "07 Apr 2026",
      "datePlanification": "09 Apr 2026",
      "statut": "Traité",
      "nbBien": "1",
      "nbTicket": "1",
      "nbTicketEnAttente": "0",
    },
    {
      "projet": "Projet2",
      "bien": "Bien1092 | Bien1056",
      "status": "En cours",
      "color": Colors.blue,
      "tags": ["Livraison Syndic", "F2"],
      "createur": "admin user",
      "type": "Livraison Syndic",
      "dateVisite": "07 Apr 2026",
      "datePlanification": "Non définie",
      "statut": "En cours",
      "nbBien": "2",
      "nbTicket": "0",
      "nbTicketEnAttente": "1",
    },
    {
      "projet": "Projet7",
      "bien": "Bien1784",
      "status": "Traité",
      "color": Colors.orange,
      "tags": ["Livraison Technique", "F4"],
      "createur": "admin user",
      "type": "Livraison Technique",
      "dateVisite": "07 Apr 2026",
      "datePlanification": "09 Apr 2026",
      "statut": "Traité",
      "nbBien": "1",
      "nbTicket": "1",
      "nbTicketEnAttente": "0",
    },
  ];
  
  // ============ LISTES DES OPTIONS ============
  final List<String> typeVisiteOptions = [
    'Tous les types de visite',
    'Réception Technique',
    'Livraison Technique',
    'Livraison Client',
    'Livraison Syndic',
    'Réclamation',
  ];

  final List<String> projetOptions = [
    'Tous les projets',
    'Projet1', 'Projet2', 'Projet3', 'Projet4',
    'Projet5', 'Projet6', 'Projet7', 'Projet8',
    'Projet9', 'Projet10', 'Projet11', 'Projet12',
    'Projet13', 'Projet14', 'Projet15', 'Projet16',
    'Projet17', 'Projet18', 'Projet19', 'Projet20',
  ];

  final List<String> utilisateurOptions = [
    'Tous les utilisateurs',
    'admin user',
    'utilisateur10013',
    'SAV - Agent technique',
  ];

  final List<String> periodePresetOptions = [
    'Aujourd\'hui',
    'Cette semaine',
    'Ce mois',
    'Cette année',
    '7 derniers jours',
    '30 derniers jours',
    '90 derniers jours',
    '365 derniers jours',
  ];
  
  List<String> biensDisponibles = [
    "Bien4", "Bien1092", "Bien1056", 
    "Bien1784", "Bien20881", "Bien1", "Bien10"
  ];
  
  // ============ FILTRAGE DES VISITES ============
  List<Map<String, dynamic>> get filteredVisites {
    return toutesLesVisites.where((visite) {
      if (selectedProjet != null && selectedProjet != 'Tous les projets' && selectedProjet != visite["projet"]) {
        return false;
      }
      if (selectedUtilisateur != null && selectedUtilisateur != 'Tous les utilisateurs' && selectedUtilisateur != visite["createur"]) {
        return false;
      }
      if (selectedTypeVisite != null && selectedTypeVisite != 'Tous les types de visite' && selectedTypeVisite != visite["type"]) {
        return false;
      }
      if (selectedBien.isNotEmpty && !visite["bien"].toString().toLowerCase().contains(selectedBien.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();
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
  
  // ============ DIALOG PÉRIODE ============
  void _showPeriodeDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Période',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: periodePresetOptions.map((preset) {
                      return FilterChip(
                        label: Text(preset),
                        selected: selectedPeriodePreset == preset,
                        onSelected: (selected) {
                          setStateModal(() {
                            selectedPeriodePreset = preset;
                            selectedDateRange = _getDateRangeFromPreset(preset);
                          });
                          Navigator.pop(context);
                          setState(() {});
                        },
                        selectedColor: const Color(0xFF3B82F6).withOpacity(0.2),
                        checkmarkColor: const Color(0xFF1E40AF),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Sélection personnalisée',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        initialDateRange: selectedDateRange,
                      );
                      if (picked != null) {
                        setStateModal(() {
                          selectedDateRange = picked;
                          selectedPeriodePreset = null;
                        });
                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Choisir une plage de dates'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (selectedDateRange != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_formatDate(selectedDateRange!.start)} - ${_formatDate(selectedDateRange!.end)}',
                        style: const TextStyle(color: Color(0xFF1E40AF)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  DateTimeRange? _getDateRangeFromPreset(String preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    switch (preset) {
      case 'Aujourd\'hui':
        return DateTimeRange(start: today, end: today);
      case 'Cette semaine':
        final start = today.subtract(Duration(days: today.weekday - 1));
        return DateTimeRange(start: start, end: start.add(const Duration(days: 6)));
      case 'Ce mois':
        return DateTimeRange(
          start: DateTime(today.year, today.month, 1),
          end: DateTime(today.year, today.month + 1, 0),
        );
      case 'Cette année':
        return DateTimeRange(
          start: DateTime(today.year, 1, 1),
          end: DateTime(today.year, 12, 31),
        );
      case '7 derniers jours':
        return DateTimeRange(start: today.subtract(const Duration(days: 7)), end: today);
      case '30 derniers jours':
        return DateTimeRange(start: today.subtract(const Duration(days: 30)), end: today);
      case '90 derniers jours':
        return DateTimeRange(start: today.subtract(const Duration(days: 90)), end: today);
      case '365 derniers jours':
        return DateTimeRange(start: today.subtract(const Duration(days: 365)), end: today);
      default:
        return null;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getPeriodeLabel() {
    if (selectedPeriodePreset != null) return selectedPeriodePreset!;
    if (selectedDateRange != null) {
      return '${_formatDate(selectedDateRange!.start)} - ${_formatDate(selectedDateRange!.end)}';
    }
    return "Sélectionner des dates";
  }
  
  // ============ DIALOG FILTER SHEET ============
  void _showFilterSheet({
    required String title,
    required List<String> options,
    required String? currentValue,
    required Function(String) onSelected,
    required bool showSearch,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        String searchQuery = "";
        String? tempSelected = currentValue;
        return StatefulBuilder(
          builder: (context, setStateModal) {
            List<String> filteredOptions = options.where((opt) => 
              opt.toLowerCase().contains(searchQuery.toLowerCase())
            ).toList();
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  if (showSearch) ...[
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Rechercher...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) => setStateModal(() => searchQuery = value),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredOptions.length,
                      itemBuilder: (context, index) {
                        final option = filteredOptions[index];
                        return RadioListTile<String>(
                          title: Text(option),
                          value: option,
                          groupValue: tempSelected,
                          activeColor: const Color(0xFF1E40AF),
                          onChanged: (value) {
                            onSelected(value!);
                            Navigator.pop(context);
                          },
                        );
                      },
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
  
  // ============ DIALOG BIEN ============
  void _showBienSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = "";
        String tempSelected = selectedBien;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            List<String> filteredBiens = biensDisponibles.where((item) => 
              item.toLowerCase().contains(searchQuery.toLowerCase())
            ).toList();
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.maxFinite,
                height: 450,
                child: Column(
                  children: [
                    const Text(
                      "Rechercher un bien",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Rechercher un bien...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      onChanged: (value) => setStateDialog(() => searchQuery = value),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView(
                        children: filteredBiens.map((bien) => RadioListTile<String>(
                          title: Text(bien),
                          value: bien,
                          groupValue: tempSelected,
                          activeColor: const Color(0xFF1E40AF),
                          onChanged: (value) {
                            setState(() => selectedBien = value!);
                            Navigator.pop(context);
                          },
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  // ============ BUILD ============
  @override
  Widget build(BuildContext context) {
    final double viewportW = MediaQuery.of(context).size.width;
    final double contentW = viewportW - 48.0;
    int crossAxisCount = 1;
    if (contentW >= 1000) {
      crossAxisCount = 3;
    } else if (contentW >= 600) {
      crossAxisCount = 2;
    }

    final filtered = filteredVisites;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Visites',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.black87,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _ajouterVisite,
                           icon: const Icon(Icons.add, size: 20, color: Color.fromARGB(255, 255, 255, 255)),
                          label: const Text(
                            'Ajouter une visite',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E40AF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildViewToggles(),
                    const SizedBox(height: 16),
                    _buildFiltersSection(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
                    child: Text(
                      'Aucune visite trouvée',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                    ),
                  ),
                ),
              )
            else if (!_isGridView) ...[
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final visite = filtered[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: index < filtered.length - 1 ? 12 : 0),
                        child: _buildVisiteListCard(context, visite),
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                sliver: SliverToBoxAdapter(
                  child: _buildVisitesListPaginationBar(filtered.length),
                ),
              ),
            ] else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 375,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final visite = filtered[index];
                      return _buildVisiteCard(
                        context,
                        visite["projet"] as String,
                        visite["bien"] as String,
                        visite["status"] as String,
                        visite["color"] as Color,
                        (visite["tags"] as List).cast<String>(),
                        visite["createur"] as String,
                        visite["nbBien"] as String,
                        visite["nbTicket"] as String,
                        visite["datePlanification"] as String,
                        visite["dateVisite"] as String,
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggles() {
    const Color primaryBlue = Color(0xFF1E40AF);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _isGridView = true),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isGridView ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: _isGridView
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  Icons.grid_view_rounded,
                  size: 20,
                  color: _isGridView ? primaryBlue : Colors.grey.shade400,
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => setState(() => _isGridView = false),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: !_isGridView ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: !_isGridView
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  Icons.view_agenda_outlined,
                  size: 20,
                  color: !_isGridView ? primaryBlue : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDesktopFilterItem(
              "Période:",
              _getPeriodeLabel(),
              Icons.calendar_today_outlined,
              onTap: _showPeriodeDialog,
            ),
            const SizedBox(width: 16),
            _buildDesktopFilterItem(
               "Bien:",
               selectedBien.isEmpty ? "Rechercher un bien..." : selectedBien,
               Icons.search,
               onTap: _showBienSearchDialog,
            ),
            const SizedBox(width: 16),
            _buildDesktopFilterItem(
              "Créé par:",
              selectedUtilisateur != null && selectedUtilisateur != 'Tous les utilisateurs' ? selectedUtilisateur! : '3 utilisateur(s)',
              Icons.person_outline,
              onTap: () => _showFilterSheet(
                  title: 'Utilisateurs',
                  options: utilisateurOptions,
                  currentValue: selectedUtilisateur,
                  onSelected: (v) => setState(() => selectedUtilisateur = v),
                  showSearch: true,
              ),
            ),
            const SizedBox(width: 16),
            _buildDesktopFilterItem(
              "Projet:",
              selectedProjet != null && selectedProjet != 'Tous les projets' ? selectedProjet! : 'Sélectionner des projets',
              Icons.folder_outlined,
              onTap: () => _showFilterSheet(
                  title: 'Projets',
                  options: projetOptions,
                  currentValue: selectedProjet,
                  onSelected: (v) => setState(() => selectedProjet = v),
                  showSearch: true,
              ),
            ),
            const SizedBox(width: 16),
            _buildDesktopFilterItem(
              "Statut visite:",
               "Sélectionner des statuts", 
               Icons.grid_view,
               onTap: () {},
            ),
            const SizedBox(width: 16),
            _buildDesktopFilterItem(
              "Type visite:",
              selectedTypeVisite != null && selectedTypeVisite != 'Tous les types de visite' ? selectedTypeVisite! : 'Sélectionner des types',
              Icons.grid_view,
              onTap: () => _showFilterSheet(
                  title: 'Type de visite',
                  options: typeVisiteOptions,
                  currentValue: selectedTypeVisite,
                  onSelected: (v) => setState(() => selectedTypeVisite = v),
                  showSearch: false,
              ),
            ),
            const SizedBox(width: 24),
            _buildAppliquerBtn(),
            const SizedBox(width: 8),
            _buildReinitialiserBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopFilterItem(String label, String hint, IconData icon, {VoidCallback? onTap}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey.shade800)),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onTap,
          child: _buildInputField(hint, icon, 180),
        ),
      ],
    );
  }

  Widget _buildInputField(String hint, IconData icon, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade400),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
                    hint,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppliquerBtn({bool fullWidth = false}) {
    Widget btn = ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      child: const Text("Appliquer", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }

  Widget _buildReinitialiserBtn({bool fullWidth = false}) {
    Widget btn = TextButton.icon(
      onPressed: () {
         setState(() {
            selectedTypeVisite = null;
            selectedProjet = null;
            selectedUtilisateur = null;
            selectedDateRange = null;
            selectedPeriodePreset = null;
            selectedBien = "";
         });
      },
      icon: Icon(Icons.close, size: 16, color: Colors.grey.shade700),
      label: Text("Réinitialiser", style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w600)),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
    return fullWidth ? SizedBox(width: double.infinity, child: btn) : btn;
  }

  static const Color _kPrimaryBlue = Color(0xFF1E40AF);
  static const double _kListMetricBoxHeight = 118;

  Widget _buildVisitesListPaginationBar(int totalCount) {
    final String rangeText = totalCount == 0
        ? '0'
        : '1 à $totalCount';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Affichage de $rangeText sur $totalCount visites',
              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.chevron_left, size: 18, color: Colors.grey.shade400),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _kPrimaryBlue,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildVisiteListCard(BuildContext context, Map<String, dynamic> visite) {
    final String projet = visite["projet"] as String;
    final String typeVisite = visite["type"] as String;
    final String nbTicket = visite["nbTicket"] as String;
    final String nbEnAttente = (visite["nbTicketEnAttente"] as String?) ?? '0';

    void openDetails() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsVisitePage(projetName: projet),
        ),
      );
    }

    /// Chip type : largeur = contenu seulement (ma tkbrch 3la l-khat / ma tb9ach m9ti3a).
    final Widget typePill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _kPrimaryBlue,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        typeVisite,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    final Widget voirDetailsBtn = ElevatedButton(
      onPressed: openDetails,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _kPrimaryBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text(
        'Voir détails',
        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
      ),
    );

    /// Ligne type + bouton : chip à largeur du texte, Spacer, puis « Voir détails ».
    Widget buildTypeAndActionRow() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Align(
              alignment: Alignment.centerLeft,
              child: typePill,
            ),
          ),
          const SizedBox(width: 10),
          const Spacer(),
          voirDetailsBtn,
        ],
      );
    }

    /// Deux métriques : même largeur (Expanded) + même hauteur fixe (9ad 9ad).
    Widget buildMetricsRow() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              height: _kListMetricBoxHeight,
              child: _buildListMetricCell(
                value: nbTicket,
                label: 'Tickets',
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: _kListMetricBoxHeight,
              child: _buildListMetricCell(
                value: nbEnAttente,
                label: 'Tickets en attente de validation',
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  projet,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Text(
                  projet,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF166534),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          buildTypeAndActionRow(),
          const SizedBox(height: 14),
          buildMetricsRow(),
        ],
      ),
    );
  }

  Widget _buildListMetricCell({
    required String value,
    required String label,
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
                height: 1.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.5,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisiteCard(
    BuildContext context,
    String projet,
    String bien,
    String status,
    Color color,
    List<String> tags,
    String createur,
    String nbBien,
    String nbTicket,
    String datePlanification,
    String dateVisite,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Status Badge & Action Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Color(0xFFFFB300),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsVisitePage(projetName: projet),
                      ),
                    );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.blue.shade500, shape: BoxShape.circle),
                  child: const Icon(Icons.chevron_right, size: 16, color: Colors.white),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),

          // Row 2: Content (Project & Bien)
          Text(
            projet,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            bien,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),

          // Row 3: Tags
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade500,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                t,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
              ),
            )).toList(),
          ),
          const Spacer(),

          // Row 4: Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoIcon(Icons.feed_outlined, nbBien),
              _buildInfoIcon(Icons.fact_check_outlined, nbTicket),
              _buildUserInfo(createur),
            ],
          ),
          const SizedBox(height: 20),

          // Row 5: Date Boxes
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text("Date de planification de la réalisation:", style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  datePlanification,
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 12, 
                    color: datePlanification == "Non définie" ? Colors.black87 : Colors.grey.shade800
                   ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Text("Date Visite:", style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                const SizedBox(width: 4),
                Text(dateVisite, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey.shade800)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoIcon(IconData icon, String count) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
        const SizedBox(height: 4),
        Icon(icon, size: 18, color: Colors.grey.shade400),
      ],
    );
  }

  Widget _buildUserInfo(String name) {
    return Column(
      children: [
        Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.black87)),
        const SizedBox(height: 4),
        Icon(Icons.person_outline, size: 18, color: Colors.grey.shade400),
      ],
    );
  }
}
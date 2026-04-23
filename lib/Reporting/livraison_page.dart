import 'package:flutter/material.dart';
import 'dart:ui';
import '../widgets/Ajouter_visite.dart';

class LivraisonPage extends StatefulWidget {
  const LivraisonPage({super.key});

  @override
  State<LivraisonPage> createState() => _LivraisonPageState();
}

class _LivraisonPageState extends State<LivraisonPage> {
  final List<String> _projets = [
    'Projet1',
    'Projet2',
    'Projet3',
    'Projet4',
    'Projet5',
    'Projet6',
    'Projet7',
    'Projet9',
    'Projet10',
    'Projet12',
    'Projet13',
    'Projet14',
    'Projet15',
    'Projet18',
    'Projet19',
    'Projet20',
  ];
  final List<String> _selectedProjets = [];
  bool _selectAllProjets = true;

  // State for accordion behavior
  int? expandedIndex;

  // Période state
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _periodText = "Période";

  @override
  void initState() {
    super.initState();
    _selectedProjets.addAll(_projets);
  }

  void _showProjetsDropdown(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: 80,
              right: 24,
              child: Material(
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 280,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Rechercher des projets...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                            prefixIcon: const Icon(Icons.search, size: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 12,
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF1F5F9),
                      ),
                      Expanded(
                        child: StatefulBuilder(
                          builder: (context, setStateDialog) {
                            return ListView(
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              children: [
                                _buildCheckboxItem(
                                  "Tous les projets",
                                  _selectAllProjets,
                                  (val) {
                                    setStateDialog(() {
                                      _selectAllProjets = val ?? false;
                                      if (_selectAllProjets) {
                                        _selectedProjets.clear();
                                        _selectedProjets.addAll(_projets);
                                      } else {
                                        _selectedProjets.clear();
                                      }
                                    });
                                    setState(() {});
                                  },
                                ),
                                ..._projets.map(
                                  (p) => _buildCheckboxItem(
                                    p,
                                    _selectedProjets.contains(p),
                                    (val) {
                                      setStateDialog(() {
                                        if (val == true) {
                                          _selectedProjets.add(p);
                                        } else {
                                          _selectedProjets.remove(p);
                                          _selectAllProjets = false;
                                        }
                                        if (_selectedProjets.length ==
                                            _projets.length) {
                                          _selectAllProjets = true;
                                        }
                                      });
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPeriodDialog() {
    showDialog(
      context: context,
      builder: (context) {
        DateTime tempStartDate = _startDate;
        DateTime tempEndDate = _endDate;
        String selectedPeriod = "90 derniers jours";

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Période"),
              content: SizedBox(
                width: 320,
                height: 450,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sélection rapide",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildQuickSelectButton(
                          "Aujourd'hui",
                          selectedPeriod == "Aujourd'hui",
                          () {
                            setStateDialog(() {
                              selectedPeriod = "Aujourd'hui";
                              tempStartDate = DateTime.now();
                              tempEndDate = DateTime.now();
                            });
                          },
                        ),
                        _buildQuickSelectButton(
                          "Cette semaine",
                          selectedPeriod == "Cette semaine",
                          () {
                            setStateDialog(() {
                              selectedPeriod = "Cette semaine";
                              final now = DateTime.now();
                              final startOfWeek = now.subtract(
                                Duration(days: now.weekday - 1),
                              );
                              tempStartDate = startOfWeek;
                              tempEndDate = startOfWeek.add(
                                const Duration(days: 6),
                              );
                            });
                          },
                        ),
                        _buildQuickSelectButton(
                          "Ce mois",
                          selectedPeriod == "Ce mois",
                          () {
                            setStateDialog(() {
                              selectedPeriod = "Ce mois";
                              final now = DateTime.now();
                              tempStartDate = DateTime(now.year, now.month, 1);
                              tempEndDate = DateTime(
                                now.year,
                                now.month + 1,
                                0,
                              );
                            });
                          },
                        ),
                        _buildQuickSelectButton(
                          "Cette année",
                          selectedPeriod == "Cette année",
                          () {
                            setStateDialog(() {
                              selectedPeriod = "Cette année";
                              final now = DateTime.now();
                              tempStartDate = DateTime(now.year, 1, 1);
                              tempEndDate = DateTime(now.year, 12, 31);
                            });
                          },
                        ),
                        _buildQuickSelectButton(
                          "7 derniers jours",
                          selectedPeriod == "7 derniers jours",
                          () {
                            setStateDialog(() {
                              selectedPeriod = "7 derniers jours";
                              tempEndDate = DateTime.now();
                              tempStartDate = DateTime.now().subtract(
                                const Duration(days: 7),
                              );
                            });
                          },
                        ),
                        _buildQuickSelectButton(
                          "30 derniers jours",
                          selectedPeriod == "30 derniers jours",
                          () {
                            setStateDialog(() {
                              selectedPeriod = "30 derniers jours";
                              tempEndDate = DateTime.now();
                              tempStartDate = DateTime.now().subtract(
                                const Duration(days: 30),
                              );
                            });
                          },
                        ),
                        _buildQuickSelectButton(
                          "90 derniers jours",
                          selectedPeriod == "90 derniers jours",
                          () {
                            setStateDialog(() {
                              selectedPeriod = "90 derniers jours";
                              tempEndDate = DateTime.now();
                              tempStartDate = DateTime.now().subtract(
                                const Duration(days: 90),
                              );
                            });
                          },
                        ),
                        _buildQuickSelectButton(
                          "365 derniers jours",
                          selectedPeriod == "365 derniers jours",
                          () {
                            setStateDialog(() {
                              selectedPeriod = "365 derniers jours";
                              tempEndDate = DateTime.now();
                              tempStartDate = DateTime.now().subtract(
                                const Duration(days: 365),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 12),
                    const Text(
                      "Sélection personnalisée",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: tempStartDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setStateDialog(() {
                            selectedPeriod = "personnalisée";
                            tempStartDate = picked;
                            tempEndDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Color(0xFF1E40AF),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Choisir une plage de dates",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${tempStartDate.day}/${tempStartDate.month}/${tempStartDate.year} - ${tempEndDate.day}/${tempEndDate.month}/${tempEndDate.year}",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startDate = tempStartDate;
                      _endDate = tempEndDate;
                      _periodText =
                          "${_startDate.day}/${_startDate.month}/${_startDate.year} - ${_endDate.day}/${_endDate.month}/${_endDate.year}";
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                  ),
                  child: const Text("Appliquer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildQuickSelectButton(
    String text,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E40AF) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF1E40AF) : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(Icons.check, size: 14, color: Colors.white),
            if (isSelected) const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxItem(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: const Color(0xFF1E40AF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: BorderSide(color: Colors.grey.shade400, width: 1.5),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade800),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              const Text(
                "Reporting Dashboard",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 24),
              Center(child: _buildHeaderButtons()),

              const SizedBox(height: 32),

              // STATS CARDS
              if (isDesktop)
                Row(
                  children: [
                    Expanded(child: _buildDossierStatCard()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildClesStatCard()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildReclamationStatCard()),
                  ],
                )
              else
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: _buildDossierStatCard(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: _buildClesStatCard(),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: _buildReclamationStatCard(),
                    ),
                  ],
                ),

              const SizedBox(height: 48),

              // EXPANDABLE SECTIONS (Accordion Behavior)
              ExpandableSection(
                title: "Dossiers PV signé (1)",
                isExpanded: expandedIndex == 0,
                onTap: () {
                  setState(() {
                    expandedIndex = expandedIndex == 0 ? null : 0;
                  });
                },
                content: _buildDossierItem(
                  projet: "Projet7",
                  bien: "Bien1788",
                  dateVisite: "10 févr. 2026",
                  tickets: "1",
                  datePv: "03 avr. 2026",
                  isDesktop: isDesktop,
                ),
              ),
              const SizedBox(height: 16),

              ExpandableSection(
                title: "Clés reçues (0)",
                isExpanded: expandedIndex == 1,
                onTap: () {
                  setState(() {
                    expandedIndex = expandedIndex == 1 ? null : 1;
                  });
                },
                content: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(
                    child: Text(
                      "Aucun dossier.",
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              ExpandableSection(
                title: "Réclamations en garantie (4)",
                isExpanded: expandedIndex == 2,
                onTap: () {
                  setState(() {
                    expandedIndex = expandedIndex == 2 ? null : 2;
                  });
                },
                content: Column(
                  children: [
                    _buildReclamationItem(
                      projet: "Projet7",
                      bien: "Bien1788",
                      dateVisite: "10 févr. 2026",
                      tranche: "Tranche5",
                      groupement: "GH1",
                      creePar: "admin user",
                      isDesktop: isDesktop,
                    ),
                    const Divider(
                      height: 32,
                      thickness: 1,
                      color: Color(0xFFF1F5F9),
                    ),
                    _buildReclamationItem(
                      projet: "Projet7",
                      bien: "Bien1789",
                      dateVisite: "11 févr. 2026",
                      tranche: "Tranche5",
                      groupement: "GH1",
                      creePar: "admin user",
                      isDesktop: isDesktop,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddVisitFlow()),
            );
          },
          backgroundColor: const Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          elevation: 6,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeaderButtons() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildFilterChip(
          icon: Icons.folder_outlined,
          label: _selectedProjets.length == _projets.length
              ? "Tous les projets"
              : "Projets (${_selectedProjets.length})",
          onTap: () => _showProjetsDropdown(context),
        ),
        _buildFilterChip(
          icon: Icons.calendar_today_outlined,
          label: _periodText,
          onTap: _showPeriodDialog,
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDossierStatCard() {
    return _buildStatCard(
      iconWidget: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.home_outlined, size: 40, color: Colors.blue.shade600),
          Positioned(
            bottom: 0,
            right: -2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 16,
                color: Colors.blue.shade600,
              ),
            ),
          ),
        ],
      ),
      value: "1",
      label: "Dossiers avec PV signé",
    );
  }

  Widget _buildClesStatCard() {
    return _buildStatCard(
      iconWidget: const Icon(Icons.key, size: 40, color: Color(0xFFD97706)),
      value: "0",
      label: "Clés reçues - Traitement réserves fini",
    );
  }

  Widget _buildReclamationStatCard() {
    return _buildStatCard(
      iconWidget: const Icon(Icons.build, size: 40, color: Color(0xFFDC2626)),
      value: "4",
      label: "Réclamations en cours de garantie",
    );
  }

  Widget _buildStatCard({
    required Widget iconWidget,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDossierItem({
    required String projet,
    required String bien,
    required String dateVisite,
    required String tickets,
    required String datePv,
    required bool isDesktop,
  }) {
    final List<Widget> fields = [
      _buildDashedInfoBox("Projet", projet, null),
      _buildDashedInfoBox("Bien", bien, Icons.home_outlined),
      _buildDashedInfoBox(
        "Date Visite",
        dateVisite,
        Icons.calendar_today_outlined,
      ),
      _buildDashedInfoBox("Tickets", tickets, null),
      _buildDashedInfoBox("Date PV", datePv, Icons.edit_document),
    ];

    return _buildStructuredItemWrapper(
      iconWidget: Icon(
        Icons.home_outlined,
        size: 20,
        color: Colors.blue.shade600,
      ),
      iconColor: Colors.blue.shade200,
      fields: fields,
      isDesktop: isDesktop,
    );
  }

  Widget _buildReclamationItem({
    required String projet,
    required String bien,
    required String dateVisite,
    required String tranche,
    required String groupement,
    required String creePar,
    required bool isDesktop,
  }) {
    final List<Widget> fields = [
      _buildDashedInfoBox("Projet", projet, null),
      _buildDashedInfoBox("Bien", bien, Icons.home_outlined),
      _buildDashedInfoBox(
        "Date Visite",
        dateVisite,
        Icons.calendar_today_outlined,
      ),
      _buildDashedInfoBox("Tranche", tranche, Icons.layers_outlined),
      _buildDashedInfoBox("Groupement", groupement, null),
      _buildDashedInfoBox("Créé par", creePar, Icons.person_outline),
    ];

    return _buildStructuredItemWrapper(
      iconWidget: Icon(
        Icons.build_outlined,
        size: 20,
        color: Colors.red.shade500,
      ),
      iconColor: Colors.red.shade200,
      fields: fields,
      isDesktop: isDesktop,
    );
  }

  Widget _buildStructuredItemWrapper({
    required Widget iconWidget,
    required Color iconColor,
    required List<Widget> fields,
    required bool isDesktop,
  }) {
    Widget iconBox = _DashedBox(
      color: iconColor,
      shape: BoxShape.circle,
      child: Padding(padding: const EdgeInsets.all(14), child: iconWidget),
    );

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          iconBox,
          const SizedBox(width: 16),
          ...fields.map(
            (f) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: f,
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: iconBox),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: fields
                .map((f) => FractionallySizedBox(widthFactor: 0.48, child: f))
                .toList(),
          ),
        ],
      );
    }
  }

  Widget _buildDashedInfoBox(String label, String value, IconData? icon) {
    return _DashedBox(
      color: Colors.grey.shade300,
      radius: 6,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 12, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandableSection extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget content;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onTap,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        bottom: 16.0,
                      ),
                      child: content,
                    )
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBox extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;
  final BoxShape shape;

  const _DashedBox({
    required this.child,
    required this.color,
    this.radius = 8.0,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRectPainter(
        color: color,
        gap: 5.0,
        strokeWidth: 1.2,
        radius: radius,
        shape: shape,
      ),
      child: child,
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;
  final BoxShape shape;

  _DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.radius,
    required this.shape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path = Path();
    if (shape == BoxShape.circle) {
      path.addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    } else {
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );
    }

    Path dashPath = Path();
    double distance = 0.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += 2 * gap;
      }
      distance = 0.0;
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import '../Ajouter_visite.dart';
import 'detailsobservation.dart';
import '../../Visites/details_visite_page.dart';

enum ObservationStatus { accepte, aFaire, refuse }

class BienObservation {
  final String id;
  final String name;
  final ObservationStatus status;
  final DateTime dateObservation;
  final DateTime prevision;
  final DateTime? realisation;
  final String locality;
  final String type;
  final String createdBy;

  const BienObservation({
    required this.id,
    required this.name,
    required this.status,
    required this.dateObservation,
    required this.prevision,
    required this.realisation,
    required this.locality,
    required this.type,
    required this.createdBy,
  });
}

class AppTheme {
  static const Color primaryBlue = Color(0xFF1E40AF);
  static const Color bluePale = Color(0xFFEFF6FF);
  static const Color background = Color(0xFFEFF6FF);
  static const Color cardShadow = Color(0x11000000);
  static const Color acceptedGreen = Color(0xFF10B981);
  static const Color refusedRed = Color(0xFFEF4444);
  static const Color todoOrange = Color(0xFFF59E0B);
  static const Color chipGrey = Color(0xFF94A3B8);
}

class ObservationsScreen extends StatefulWidget {
  const ObservationsScreen({super.key});

  @override
  State<ObservationsScreen> createState() => _ObservationsScreenState();
}

class _ObservationsScreenState extends State<ObservationsScreen> {
  // Pagination (globale) : max 5 éléments par page
  final int itemsPerPage = 5;
  int currentPage = 1;

  // Filtres
  DateTimeRange? selectedPeriod;
  String selectedTypeDate = 'Date d’observation';
  String bienQuery = '';
  ObservationStatus? selectedStatus; // null => tous
  final List<String> typeDateOptions = const [
    'Date d’observation',
    'Prévision',
    'Réalisation',
  ];
  late final List<String> bienOptions =
      List.generate(18, (index) => 'Bien ${1056 + index}');

  // Mock data
  final List<BienObservation> mockObservations = List.generate(18, (index) {
    final status = index % 3 == 0
        ? ObservationStatus.accepte
        : (index % 3 == 1 ? ObservationStatus.aFaire : ObservationStatus.refuse);

    // Dates simulées autour d’avril 2026
    final obsDate = DateTime(2026, 4, 1 + (index % 18));
    final prevDate = DateTime(2026, 4, 6 + (index % 15));
    final realised = status == ObservationStatus.accepte
        ? DateTime(2026, 4, 8 + (index % 10))
        : (status == ObservationStatus.refuse ? null : DateTime(2026, 4, 12 + (index % 8)));

    const localities = ['Bureau', 'Chambre d’enfant', 'Plomberie', 'Bâtiment A', 'Bureau 2', 'Cuisine'];
    const types = ['Plomberie', 'Peinture', 'Electricite', 'Panneaux', 'Cuisine', 'Platerie'];

    return BienObservation(
      id: 'OBS-${1000 + index}',
      name: 'Bien ${1056 + index}',
      status: status,
      dateObservation: obsDate,
      prevision: prevDate,
      realisation: realised,
      locality: localities[index % localities.length],
      type: types[index % types.length],
      createdBy: 'Admin',
    );
  });

  List<BienObservation> get filteredObservations {
    return mockObservations.where((item) {
      final statusOk = selectedStatus == null ? true : item.status == selectedStatus;
      final bienOk = bienQuery.trim().isEmpty
          ? true
          : item.name.toLowerCase().contains(bienQuery.trim().toLowerCase());

      final periodOk = selectedPeriod == null
          ? true
          : _isItemInSelectedPeriod(item);

      return statusOk && bienOk && periodOk;
    }).toList();
  }

  bool _isItemInSelectedPeriod(BienObservation item) {
    final start = selectedPeriod!.start;
    final end = selectedPeriod!.end;

    final DateTime targetDate;
    switch (selectedTypeDate) {
      case 'Prévision':
        targetDate = item.prevision;
        break;
      case 'Réalisation':
        // Si pas de réalisation, on considère que ça ne passe pas.
        if (item.realisation == null) return false;
        targetDate = item.realisation!;
        break;
      case 'Date d’observation':
      default:
        targetDate = item.dateObservation;
    }

    final dateOnly = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final startOnly = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day);

    return (dateOnly.isAtSameMomentAs(startOnly) || dateOnly.isAfter(startOnly)) &&
        (dateOnly.isAtSameMomentAs(endOnly) || dateOnly.isBefore(endOnly));
  }

  int get totalPages => (filteredObservations.length / itemsPerPage).ceil().clamp(1, 9999);

  List<BienObservation> get currentItems {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    final list = filteredObservations;

    if (startIndex >= list.length) return [];
    return list.sublist(startIndex, endIndex > list.length ? list.length : endIndex);
  }

  // FAB
  void _openAddVisitFlow() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddVisitFlow()),
    );
  }

  void _applyFilters() {
    setState(() {
      currentPage = 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filtres appliqués')),
    );
  }

  void _resetFilters() {
    setState(() {
      selectedPeriod = null;
      selectedTypeDate = 'Date d’observation';
      bienQuery = '';
      selectedStatus = null;
      currentPage = 1;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filtres réinitialisés')),
    );
  }

  void _exportMock() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export simulé (mock data).')),
    );
  }

  void _planifiedMock() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Planifié simulé.')),
    );
  }

  void _goPrevPage() {
    if (currentPage <= 1) return;
    setState(() => currentPage -= 1);
  }

  void _goNextPage() {
    if (currentPage >= totalPages) return;
    setState(() => currentPage += 1);
  }

  String _statusLabel(ObservationStatus status) {
    switch (status) {
      case ObservationStatus.accepte:
        return 'Accepté';
      case ObservationStatus.aFaire:
        return 'À faire';
      case ObservationStatus.refuse:
        return 'Refusé';
    }
  }

  String _formatShortDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  void _openObservationDetails(BienObservation observation, {String focusSection = 'Observation'}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsObservationPage(
          bienName: observation.name,
          status: _statusLabel(observation.status),
          dateObservation: _formatShortDate(observation.dateObservation),
          prevision: _formatShortDate(observation.prevision),
          realisation: observation.realisation == null
              ? '-'
              : _formatShortDate(observation.realisation!),
          localite: observation.locality,
          type: observation.type,
          createdBy: observation.createdBy,
          focusSection: focusSection,
        ),
      ),
    );
  }

  // Entrées "header + cards" pour une ListView.builder groupée
  // (Plus de headers Accepté/À faire/Refusé) : liste simple

  @override
  Widget build(BuildContext context) {
    final items = currentItems;

    return Scaffold(
      backgroundColor: AppTheme.bluePale,
      appBar: AppBar(
        title: const Text(
          'Observations',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.bluePale,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _SmallAppBarChip(
              label: 'Planifier',
              color: const Color(0xFF16A34A),
              onTap: _planifiedMock,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _SmallAppBarChip(
              label: 'À planifier',
              color: const Color(0xFF64748B),
              onTap: () {},
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton(
          onPressed: _openAddVisitFlow,
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
          itemCount: items.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FilterBar(
                  period: selectedPeriod,
                  typeDate: selectedTypeDate,
                  bienQuery: bienQuery,
                  status: selectedStatus,
                  onPickPeriod: (range) {
                    setState(() => selectedPeriod = range);
                  },
                  onTypeDateChanged: (value) {
                    setState(() => selectedTypeDate = value);
                  },
                  onBienChanged: (value) {
                    setState(() => bienQuery = value);
                  },
                  onStatusChanged: (value) {
                    setState(() => selectedStatus = value);
                  },
                  onApply: _applyFilters,
                  onReset: _resetFilters,
                  onExport: _exportMock,
                  onPlanified: _planifiedMock,
                ),
              );
            }

            if (index == items.length + 1) {
              return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 8),
                child: PaginationWidget(
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onPrev: _goPrevPage,
                  onNext: _goNextPage,
                ),
              );
            }

            final obs = items[index - 1];
            return BienCard(
              observation: obs,
              onOpenDetails: (focusSection) {
                _openObservationDetails(obs, focusSection: focusSection);
              },
            );
          },
        ),
      ),
    );
  }
}

enum _DisplayEntryKind { header, card, empty }

class _DisplayEntry {
  final _DisplayEntryKind kind;
  final String? title;
  final Color? color;
  final BienObservation? observation;

  const _DisplayEntry._({
    required this.kind,
    this.title,
    this.color,
    this.observation,
  });

  factory _DisplayEntry.header({
    required String title,
    required Color color,
  }) =>
      _DisplayEntry._(kind: _DisplayEntryKind.header, title: title, color: color);

  factory _DisplayEntry.card(BienObservation observation) =>
      _DisplayEntry._(kind: _DisplayEntryKind.card, observation: observation);

  factory _DisplayEntry.emptyPlaceholder() => _DisplayEntry._(kind: _DisplayEntryKind.empty);
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterBar extends StatefulWidget {
  final DateTimeRange? period;
  final String typeDate;
  final String bienQuery;
  final ObservationStatus? status;

  final void Function(DateTimeRange range) onPickPeriod;
  final void Function(String value) onTypeDateChanged;
  final void Function(String value) onBienChanged;
  final void Function(ObservationStatus? value) onStatusChanged;

  final VoidCallback onApply;
  final VoidCallback onReset;
  final VoidCallback onExport;
  final VoidCallback onPlanified;

  const FilterBar({
    super.key,
    required this.period,
    required this.typeDate,
    required this.bienQuery,
    required this.status,
    required this.onPickPeriod,
    required this.onTypeDateChanged,
    required this.onBienChanged,
    required this.onStatusChanged,
    required this.onApply,
    required this.onReset,
    required this.onExport,
    required this.onPlanified,
  });

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  bool _showAdvancedFilters = false;
  final TextEditingController _bienController = TextEditingController();
  String? advancedTypeVisite;
  String? advancedCorpsMetier;
  String? advancedCreatedBy;
  String? advancedPiloteTechnique;
  String? advancedAgentLivraison;
  String? advancedLocalite;
  String? advancedProjet;
  String? advancedTranche;
  String? advancedGroupement;
  String? advancedImmeuble;
  String? advancedEtage;
  final List<String> _periodePresetOptions = const [
    'Aujourd\'hui',
    'Cette semaine',
    'Ce mois',
    'Cette année',
    '7 derniers jours',
    '30 derniers jours',
    '90 derniers jours',
    '365 derniers jours',
  ];
  final List<String> _typeVisiteOptions = const [
    'Réception Technique',
    'Livraison Technique',
    'Livraison Client',
    'Livraison Syndic',
    'Réclamation',
  ];
  final List<String> _corpsMetierOptions = const [
    'Plomberie',
    'Peinture',
    'Electricite',
    'Cuisine',
    'Platerie',
  ];
  final List<String> _userOptions = const [
    'Admin',
    'Admin user',
    'SAV - Agent technique',
    'Utilisateur 1',
  ];
  final List<String> _pilotOptions = const [
    'Pilote A',
    'Pilote B',
    'Pilote C',
  ];
  final List<String> _localiteOptions = const [
    'Bureau',
    'Chambre d’enfant',
    'Cuisine',
    'Bâtiment A',
  ];
  final List<String> _projetOptions = const [
    'Projet1',
    'Projet2',
    'Projet3',
    'Projet4',
  ];
  final List<String> _trancheOptions = const [
    'Tranche A',
    'Tranche B',
    'Tranche C',
  ];
  final List<String> _groupementOptions = const [
    'Groupement 1',
    'Groupement 2',
  ];
  final List<String> _immeubleOptions = const [
    'Immeuble A',
    'Immeuble B',
    'Immeuble C',
  ];
  final List<String> _etageOptions = const [
    'RDC',
    '1er',
    '2eme',
    '3eme',
  ];

  String _periodLabel() {
    if (widget.period == null) return 'Période';
    final s = '${widget.period!.start.day}/${widget.period!.start.month}/${widget.period!.start.year}';
    final e = '${widget.period!.end.day}/${widget.period!.end.month}/${widget.period!.end.year}';
    return '$s - $e';
  }

  DateTimeRange _getDateRangeFromPreset(String preset) {
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
      default:
        return DateTimeRange(start: today.subtract(const Duration(days: 365)), end: today);
    }
  }

  Future<void> _showPeriodeSheet() async {
    await showModalBottomSheet(
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
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.72,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Période',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _periodePresetOptions.map((preset) {
                      return FilterChip(
                        label: Text(preset),
                        selected: false,
                        onSelected: (_) {
                          widget.onPickPeriod(_getDateRangeFromPreset(preset));
                          Navigator.pop(context);
                        },
                        selectedColor: const Color(0xFF3B82F6).withOpacity(0.18),
                        checkmarkColor: const Color(0xFF3B82F6),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Sélection personnalisée',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                        initialDateRange: widget.period,
                      );
                      if (picked != null) {
                        widget.onPickPeriod(picked);
                        if (mounted) Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Choisir une plage de dates'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
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

  Future<void> _showOptionsSheet({
    required String title,
    required List<String> options,
    required String? currentValue,
    required ValueChanged<String> onSelected,
    required bool showSearch,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SearchableOptionSheet(
          title: title,
          options: options,
          currentValue: currentValue,
          onSelected: onSelected,
          showSearch: showSearch,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // keep controller in sync when parent updates
    if (_bienController.text != widget.bienQuery) {
      _bienController.text = widget.bienQuery;
      _bienController.selection = TextSelection.collapsed(offset: _bienController.text.length);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne 1: 2 filtres + ^
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _LabeledField(
                  title: 'Période',
                  child: _CompactFilterField(
                    icon: Icons.calendar_today_outlined,
                    label: _periodLabel(),
                    onTap: _showPeriodeSheet,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  title: 'Type de date',
                  child: _CompactFilterField(
                    icon: Icons.schedule_outlined,
                    label: widget.typeDate,
                    onTap: () => _showOptionsSheet(
                      title: 'Type de date',
                      options: const [
                        'Date d’observation',
                        'Prévision',
                        'Réalisation',
                      ],
                      currentValue: widget.typeDate,
                      onSelected: widget.onTypeDateChanged,
                      showSearch: false,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: _ExpandFiltersButton(
                  isExpanded: _showAdvancedFilters,
                  onTap: () {
                    setState(() => _showAdvancedFilters = !_showAdvancedFilters);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Ligne 2: Bien (text input) + Statut
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: _LabeledField(
                  title: 'Bien',
                  child: Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD6DCE8)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.home_outlined, color: Color(0xFF94A3B8), size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _bienController,
                            onChanged: widget.onBienChanged,
                            decoration: const InputDecoration(
                              hintText: 'Référence du bien',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LabeledField(
                  title: 'Statut',
                  child: _CompactFilterField(
                    icon: Icons.flag_outlined,
                    label: widget.status == null ? 'Sélectionner' : _statusToLabel(widget.status!),
                    onTap: () => _showOptionsSheet(
                      title: 'Statut',
                      options: const ['Accepté', 'À faire', 'Refusé'],
                      currentValue: widget.status == null ? null : _statusToLabel(widget.status!),
                      onSelected: (value) => widget.onStatusChanged(_labelToStatus(value)),
                      showSearch: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_showAdvancedFilters) ...[
            const SizedBox(height: 22),
            Container(height: 1, color: const Color(0xFFE5E7EB)),
            const SizedBox(height: 10),
            const Text(
              'Filtres avancés',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final fieldWidth = (constraints.maxWidth - 12) / 2;
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _AdvancedFilterField(
                      title: 'Type de visite',
                      icon: Icons.adjust_outlined,
                      width: fieldWidth,
                      value: advancedTypeVisite,
                      onTap: () => _showOptionsSheet(
                        title: 'Type de visite',
                        options: _typeVisiteOptions,
                        currentValue: advancedTypeVisite,
                        onSelected: (value) => setState(() => advancedTypeVisite = value),
                        showSearch: false,
                      ),
                    ),
                    _AdvancedFilterField(
                      title: 'Corps de métier',
                      icon: Icons.grid_view_outlined,
                      width: fieldWidth,
                      value: advancedCorpsMetier,
                      onTap: () => _showOptionsSheet(
                        title: 'Corps de métier',
                        options: _corpsMetierOptions,
                        currentValue: advancedCorpsMetier,
                        onSelected: (value) => setState(() => advancedCorpsMetier = value),
                        showSearch: true,
                      ),
                    ),
                    _AdvancedFilterField(
                      title: 'Créé par',
                      icon: Icons.person_outline,
                      width: fieldWidth,
                      value: advancedCreatedBy,
                      onTap: () => _showOptionsSheet(
                        title: 'Créé par',
                        options: _userOptions,
                        currentValue: advancedCreatedBy,
                        onSelected: (value) => setState(() => advancedCreatedBy = value),
                        showSearch: true,
                      ),
                    ),
                    _AdvancedFilterField(
                      title: 'Pilote Technique',
                      icon: Icons.engineering_outlined,
                      width: fieldWidth,
                      value: advancedPiloteTechnique,
                      onTap: () => _showOptionsSheet(
                        title: 'Pilote Technique',
                        options: _pilotOptions,
                        currentValue: advancedPiloteTechnique,
                        onSelected: (value) => setState(() => advancedPiloteTechnique = value),
                        showSearch: true,
                      ),
                    ),
                    _AdvancedFilterField(
                      title: 'Agent de Livraison',
                      icon: Icons.badge_outlined,
                      width: fieldWidth,
                      value: advancedAgentLivraison,
                      onTap: () => _showOptionsSheet(
                        title: 'Agent de Livraison',
                        options: _userOptions,
                        currentValue: advancedAgentLivraison,
                        onSelected: (value) => setState(() => advancedAgentLivraison = value),
                        showSearch: true,
                      ),
                    ),
                    _AdvancedFilterField(
                      title: 'Localité',
                      icon: Icons.location_on_outlined,
                      width: fieldWidth,
                      value: advancedLocalite,
                      onTap: () => _showOptionsSheet(
                        title: 'Localité',
                        options: _localiteOptions,
                        currentValue: advancedLocalite,
                        onSelected: (value) => setState(() => advancedLocalite = value),
                        showSearch: true,
                      ),
                    ),
                    _AdvancedFilterField(
                      title: 'Projet',
                      icon: Icons.folder_open_outlined,
                      width: fieldWidth,
                      value: advancedProjet,
                      onTap: () => _showOptionsSheet(
                        title: 'Projet',
                        options: _projetOptions,
                        currentValue: advancedProjet,
                        onSelected: (value) => setState(() => advancedProjet = value),
                        showSearch: true,
                      ),
                    ),
                    _AdvancedFilterField(
                      title: 'Tranche',
                      icon: Icons.view_stream_outlined,
                      width: fieldWidth,
                      value: advancedTranche,
                      hint: advancedProjet == null ? 'Sélectionnez d’abord un projet' : 'Sélectionner',
                      onTap: advancedProjet == null
                          ? null
                          : () => _showOptionsSheet(
                                title: 'Tranche',
                                options: _trancheOptions,
                                currentValue: advancedTranche,
                                onSelected: (value) => setState(() => advancedTranche = value),
                                showSearch: true,
                              ),
                    ),
                    _AdvancedFilterField(
                      title: 'Groupement',
                      icon: Icons.group_work_outlined,
                      width: fieldWidth,
                      value: advancedGroupement,
                      hint: advancedProjet == null && advancedTranche == null
                          ? 'Sélectionnez un projet ou une tranche'
                          : 'Sélectionner',
                      onTap: advancedProjet == null && advancedTranche == null
                          ? null
                          : () => _showOptionsSheet(
                                title: 'Groupement',
                                options: _groupementOptions,
                                currentValue: advancedGroupement,
                                onSelected: (value) => setState(() => advancedGroupement = value),
                                showSearch: true,
                              ),
                    ),
                    _AdvancedFilterField(
                      title: 'Immeuble',
                      icon: Icons.apartment_outlined,
                      width: fieldWidth,
                      value: advancedImmeuble,
                      hint: advancedProjet == null && advancedGroupement == null
                          ? 'Sélectionnez un projet ou groupement'
                          : 'Sélectionner',
                      onTap: advancedProjet == null && advancedGroupement == null
                          ? null
                          : () => _showOptionsSheet(
                                title: 'Immeuble',
                                options: _immeubleOptions,
                                currentValue: advancedImmeuble,
                                onSelected: (value) => setState(() => advancedImmeuble = value),
                                showSearch: true,
                              ),
                    ),
                    _AdvancedFilterField(
                      title: 'Étage',
                      icon: Icons.layers_outlined,
                      width: fieldWidth,
                      value: advancedEtage,
                      onTap: () => _showOptionsSheet(
                        title: 'Étage',
                        options: _etageOptions,
                        currentValue: advancedEtage,
                        onSelected: (value) => setState(() => advancedEtage = value),
                        showSearch: false,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
          const SizedBox(height: 14),
          // Ligne 3: Exporter / Réinitialiser / Appliquer
          Row(
            children: [
              _ActionButton(
                icon: Icons.file_download_outlined,
                label: 'Exporter',
                onTap: widget.onExport,
                style: _ActionButtonStyle.outlineBlue,
              ),
              const SizedBox(width: 10),
              _ActionButton(
                icon: Icons.refresh,
                label: 'Réinitialiser',
                onTap: widget.onReset,
                style: _ActionButtonStyle.outlineGrey,
              ),
              const SizedBox(width: 10),
              _ActionButton(
                icon: Icons.check,
                label: 'Appliquer',
                onTap: widget.onApply,
                style: _ActionButtonStyle.filledBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusToLabel(ObservationStatus status) {
    switch (status) {
      case ObservationStatus.accepte:
        return 'Accepté';
      case ObservationStatus.aFaire:
        return 'À faire';
      case ObservationStatus.refuse:
        return 'Refusé';
    }
  }

  ObservationStatus? _labelToStatus(String? label) {
    switch (label) {
      case 'Accepté':
        return ObservationStatus.accepte;
      case 'À faire':
        return ObservationStatus.aFaire;
      case 'Refusé':
        return ObservationStatus.refuse;
      default:
        return null;
    }
  }
}

class _LabeledField extends StatelessWidget {
  final String title;
  final Widget child;

  const _LabeledField({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _ExpandFiltersButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const _ExpandFiltersButton({
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD6DCE8)),
        ),
        child: Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: const Color(0xFF64748B),
          size: 20,
        ),
      ),
    );
  }
}

class _AdvancedFilterField extends StatelessWidget {
  final String title;
  final IconData icon;
  final String hint;
  final double width;
  final String? value;
  final VoidCallback? onTap;

  const _AdvancedFilterField({
    required this.title,
    required this.icon,
    this.hint = 'Sélectionner',
    required this.width,
    this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: _LabeledField(
        title: title,
        child: _CompactFilterField(
          icon: icon,
          label: value ?? hint,
          onTap: onTap,
          enabled: onTap != null,
        ),
      ),
    );
  }
}

class _CompactFilterField extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool enabled;

  const _CompactFilterField({
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enabled ? onTap : null,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: enabled
                  ? AppTheme.primaryBlue.withOpacity(0.18)
                  : const Color(0xFFD6DCE8),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: enabled ? AppTheme.primaryBlue : const Color(0xFF94A3B8),
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: enabled ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                  ),
                ),
              ),
              Icon(
                Icons.expand_more_outlined,
                size: 18,
                color: enabled ? Colors.black54 : const Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchableOptionSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final String? currentValue;
  final ValueChanged<String> onSelected;
  final bool showSearch;

  const SearchableOptionSheet({
    super.key,
    required this.title,
    required this.options,
    required this.currentValue,
    required this.onSelected,
    required this.showSearch,
  });

  @override
  State<SearchableOptionSheet> createState() => _SearchableOptionSheetState();
}

class _SearchableOptionSheetState extends State<SearchableOptionSheet> {
  String query = '';

  List<String> get filteredOptions {
    if (query.isEmpty) return widget.options;
    return widget.options
        .where((option) => option.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          if (widget.showSearch) ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                onChanged: (value) => setState(() => query = value),
                decoration: InputDecoration(
                  hintText: 'Rechercher ${widget.title.toLowerCase()}...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B), size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Expanded(
            child: filteredOptions.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun résultat trouvé',
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredOptions.length,
                    itemBuilder: (context, index) {
                      final option = filteredOptions[index];
                      final isSelected = option == widget.currentValue;
                      return CheckboxListTile(
                        value: isSelected,
                        activeColor: AppTheme.primaryBlue,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          option,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                        onChanged: (_) {
                          widget.onSelected(option);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final IconData icon;
  final String value;
  final List<String> items;
  final String hint;
  final void Function(String?) onChanged;

  const _DropdownField({
    required this.icon,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                hint: Text(hint),
                items: items
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextFieldWithIcon extends StatelessWidget {
  final IconData icon;
  final String hint;
  final String value;
  final void Function(String) onChanged;

  const _TextFieldWithIcon({
    required this.icon,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: value),
              onChanged: onChanged,
              decoration: InputDecoration(
                isDense: true,
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ActionButtonStyle { filledBlue, outlineGrey, outlineBlue, outlineGreen }

class _SmallAppBarChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SmallAppBarChip({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final _ActionButtonStyle style;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final Color? borderColor;
    final Color? textColor;
    final Color background;

    switch (style) {
      case _ActionButtonStyle.filledBlue:
        borderColor = null;
        textColor = Colors.white;
        background = AppTheme.primaryBlue;
        break;
      case _ActionButtonStyle.outlineGrey:
        borderColor = Colors.grey.shade400;
        textColor = Colors.grey.shade700;
        background = Colors.white;
        break;
      case _ActionButtonStyle.outlineBlue:
        borderColor = AppTheme.primaryBlue.withOpacity(0.5);
        textColor = AppTheme.primaryBlue;
        background = Colors.white;
        break;
      case _ActionButtonStyle.outlineGreen:
        borderColor = const Color(0xFF0F766E).withOpacity(0.6);
        textColor = const Color(0xFF0F766E);
        background = Colors.white;
        break;
    }

    return SizedBox(
      height: 36,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: textColor),
        label: Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: textColor)),
        style: OutlinedButton.styleFrom(
          backgroundColor: background,
          side: borderColor == null ? BorderSide.none : BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
      ),
    );
  }
}

class BienCard extends StatelessWidget {
  final BienObservation observation;
  final ValueChanged<String> onOpenDetails;

  const BienCard({
    super.key,
    required this.observation,
    required this.onOpenDetails,
  });

  Color _statusColor() {
    switch (observation.status) {
      case ObservationStatus.accepte:
        return AppTheme.acceptedGreen;
      case ObservationStatus.aFaire:
        return AppTheme.todoOrange;
      case ObservationStatus.refuse:
        return AppTheme.refusedRed;
    }
  }

  String _statusLabel() {
    switch (observation.status) {
      case ObservationStatus.accepte:
        return 'Accepté';
      case ObservationStatus.aFaire:
        return 'À faire';
      case ObservationStatus.refuse:
        return 'Refusé';
    }
  }

  String _fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();
    final statusLabel = _statusLabel();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onOpenDetails('Observation'),
            hoverColor: const Color(0xFF1E40AF).withOpacity(0.04),
            highlightColor: const Color(0xFF1E40AF).withOpacity(0.06),
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: AppTheme.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
                ],
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: color.withOpacity(0.12),
                          radius: 18,
                          child: Icon(
                            observation.status == ObservationStatus.accepte
                                ? Icons.check_circle_outline
                                : (observation.status == ObservationStatus.aFaire
                                    ? Icons.timelapse_outlined
                                    : Icons.cancel_outlined),
                            color: color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsVisitePage(
                                      projetName: observation.name,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                observation.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.primaryBlue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppTheme.primaryBlue,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 22,
                          color: Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 20,
                      runSpacing: 14,
                      children: [
                        _MetaText(
                          icon: Icons.event_outlined,
                          label: 'Observation',
                          value: _fmt(observation.dateObservation),
                          onTap: () => onOpenDetails('Observation'),
                        ),
                        _MetaText(
                          icon: Icons.schedule_outlined,
                          label: 'Prévision',
                          value: _fmt(observation.prevision),
                          onTap: () => onOpenDetails('Prévision'),
                        ),
                        _MetaText(
                          icon: Icons.assignment_turned_in_outlined,
                          label: 'Réalisation',
                          value: observation.realisation == null ? '-' : _fmt(observation.realisation!),
                          onTap: () => onOpenDetails('Réalisation'),
                        ),
                        _MetaText(
                          icon: Icons.location_on_outlined,
                          label: 'Localité',
                          value: observation.locality,
                          onTap: () => onOpenDetails('Localité'),
                        ),
                        _MetaText(
                          icon: Icons.category_outlined,
                          label: 'Type',
                          value: observation.type,
                          onTap: () => onOpenDetails('Type'),
                        ),
                        _MetaText(
                          icon: Icons.person_outline,
                          label: 'Créé par',
                          value: observation.createdBy,
                          onTap: () => onOpenDetails('Créé par'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _MetaText({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final canPrev = currentPage > 1;
    final canNext = currentPage < totalPages;

    List<Widget> buildPageButtons() {
      final buttons = <Widget>[];
      for (int i = 1; i <= totalPages; i++) {
        final bool isActive = i == currentPage;
        buttons.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                if (i == currentPage) return;
                if (i < currentPage) {
                  // simple logique: bouger vers l’arrière
                  for (int step = currentPage; step > i; step--) {
                    onPrev();
                  }
                } else {
                  for (int step = currentPage; step < i; step++) {
                    onNext();
                  }
                }
              },
              child: Container(
                width: 32,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive ? AppTheme.primaryBlue : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isActive
                        ? AppTheme.primaryBlue
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  '$i',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      return buttons;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 28, height: 28),
          onPressed: canPrev ? onPrev : null,
          icon: Icon(
            Icons.chevron_left_rounded,
            size: 18,
            color: canPrev ? const Color(0xFF64748B) : const Color(0xFFCBD5F5),
          ),
        ),
        const SizedBox(width: 4),
        ...buildPageButtons(),
        const SizedBox(width: 4),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 28, height: 28),
          onPressed: canNext ? onNext : null,
          icon: Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: canNext ? const Color(0xFF64748B) : const Color(0xFFCBD5F5),
          ),
        ),
      ],
    );
  }
}


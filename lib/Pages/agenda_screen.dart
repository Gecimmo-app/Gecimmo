import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/sample_data.dart';
import '../theme/app_theme.dart';
import '../widgets/toggle_chip.dart';
import '../widgets/app_drawer.dart';
import 'add_task_screen.dart';
import 'contacts_screen.dart';
import 'notifications_screen.dart';
import 'projects_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import 'task_detail_screen.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});
  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabCtrl;

  // calendar state
  DateTime _month     = DateTime(2026, 4);
  DateTime _weekStart = DateTime(2026, 4, 13);
  DateTime _dayFocus  = DateTime(2026, 4, 16);
  DateTime? _selectedDay;

  // filter state
  DateTime? _dateDebut, _dateFin;
  String? _projet, _commercial, _tc, _motif;
  String _typeDate = 'planification';
  final Set<TaskType>   _types    = Set.from(TaskType.values);
  final Set<TaskStatus> _statuses = Set.from(TaskStatus.values);

  List<Task> _displayed = [];
  final _scrollCtrl  = ScrollController();
  final _taskListKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabCtrl  = TabController(length: 3, vsync: this);
    _displayed = List.from(appTasks);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Apply filters and close sheet ──────────────
  void _applyFilters() {
    Navigator.pop(context);
    setState(() {
      _displayed = appTasks.where((t) {
        if (_dateDebut != null && t.date.isBefore(_dateDebut!)) return false;
        if (_dateFin   != null && t.date.isAfter(_dateFin!))   return false;
        if (_projet     != null && t.project  != _projet)       return false;
        if (_commercial != null && t.assignee != _commercial)   return false;
        if (!_types.contains(t.type))      return false;
        if (!_statuses.contains(t.status)) return false;
        return true;
      }).toList();
    });
  }

  // ── Reset all filters ──────────────────────────
  void _resetFilters() {
    setState(() {
      _dateDebut = _dateFin = _projet = _commercial = _tc = _motif = null;
      _typeDate  = 'planification';
      _types   ..clear()..addAll(TaskType.values);
      _statuses..clear()..addAll(TaskStatus.values);
      _displayed = List.from(appTasks);
    });
  }

  // ── Scroll to task list ────────────────────────
  void _scrollToTasks() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _taskListKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(ctx,
            duration: const Duration(milliseconds: 450), curve: Curves.easeInOut);
      }
    });
  }

  void _onDaySelected(DateTime day) {
    setState(() => _selectedDay = day);
    _scrollToTasks();
  }

  // ── Filtered visible tasks ─────────────────────
  List<Task> get _visibleTasks {
    if (_selectedDay == null) return _displayed;
    return _displayed.where((t) =>
        t.date.year  == _selectedDay!.year  &&
        t.date.month == _selectedDay!.month &&
        t.date.day   == _selectedDay!.day).toList();
  }

  // ── Add task ───────────────────────────────────
  Future<void> _addTask() async {
    final task = await Navigator.push<Task>(
        context, MaterialPageRoute(builder: (_) => const AddTaskScreen()));
    if (task != null && mounted) {
      setState(() { _displayed = List.from(appTasks); _selectedDay = task.date; });
      _scrollToTasks();
    }
  }

  // ── Count active filters ───────────────────────
  int get _activeFilterCount {
    int n = 0;
    if (_dateDebut != null) n++;
    if (_dateFin   != null) n++;
    if (_projet     != null) n++;
    if (_commercial != null) n++;
    if (_tc         != null) n++;
    if (_motif      != null) n++;
    if (_types.length    < TaskType.values.length)   n++;
    if (_statuses.length < TaskStatus.values.length) n++;
    return n;
  }

  // ── Apply filters without closing sheet ────────
  void _applyFiltersNoClose() {
    setState(() {
      _displayed = appTasks.where((t) {
        if (_dateDebut != null && t.date.isBefore(_dateDebut!)) return false;
        if (_dateFin   != null && t.date.isAfter(_dateFin!))   return false;
        if (_projet     != null && t.project  != _projet)       return false;
        if (_commercial != null && t.assignee != _commercial)   return false;
        if (!_types.contains(t.type))      return false;
        if (!_statuses.contains(t.status)) return false;
        return true;
      }).toList();
    });
  }

  // ════════════════════════════════════════════════
  // OPEN FILTER BOTTOM SHEET
  // ════════════════════════════════════════════════
  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(
        dateDebut:   _dateDebut,
        dateFin:     _dateFin,
        projet:      _projet,
        commercial:  _commercial,
        tc:          _tc,
        motif:       _motif,
        typeDate:    _typeDate,
        activeTypes:    Set.from(_types),
        activeStatuses: Set.from(_statuses),
        onChanged: (f) => setState(() {
          _dateDebut  = f.dateDebut;
          _dateFin    = f.dateFin;
          _projet     = f.projet;
          _commercial = f.commercial;
          _tc         = f.tc;
          _motif      = f.motif;
          _typeDate   = f.typeDate;
          _types   ..clear()..addAll(f.types);
          _statuses..clear()..addAll(f.statuses);
        }),
        onApply: _applyFilters,
        onReset: () { _resetFilters(); Navigator.pop(context); },
      ),
    );
  }

  // ════════════════════════════════════════════════
  // BUILD
  // ════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _appBar(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        controller: _scrollCtrl,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildTopBar(),
          _buildCalendarCard(),
          const SizedBox(height: 8),
          _buildTaskList(),
          const SizedBox(height: 90),
        ]),
      ),
    );
  }

  // ════════════════════════════════════════════════
  // TOP BAR  (filter btn + type/status chips)
  // ════════════════════════════════════════════════
  Widget _buildTopBar() {
    final count = _activeFilterCount;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // Row: Filtres button + active chips + reset
        Row(children: [
          GestureDetector(
            onTap: _openFilters,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: count > 0 ? AppTheme.primary : Colors.white,
                border: Border.all(
                    color: count > 0 ? AppTheme.primary : AppTheme.cardBorder,
                    width: count > 0 ? 1.5 : 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.filter_alt_outlined,
                    size: 18,
                    color: count > 0 ? Colors.white : AppTheme.primary),
                const SizedBox(width: 7),
                Text('Filtres',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600,
                        color: count > 0 ? Colors.white : AppTheme.primary)),
                if (count > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle),
                    child: Center(
                      child: Text('$count',
                          style: const TextStyle(fontSize: 11,
                              color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ]),
            ),
          ),
          const SizedBox(width: 10),

          if (_dateDebut != null)
            _ActiveChip(
              label: DateFormat('dd/MM', 'fr_FR').format(_dateDebut!),
              icon: Icons.calendar_today_outlined,
              onRemove: () => setState(() { _dateDebut = null; _applyFiltersNoClose(); }),
            ),
          if (_dateFin != null) ...[
            const SizedBox(width: 6),
            _ActiveChip(
              label: '→ ${DateFormat('dd/MM', 'fr_FR').format(_dateFin!)}',
              icon: Icons.calendar_today_outlined,
              onRemove: () => setState(() { _dateFin = null; _applyFiltersNoClose(); }),
            ),
          ],
          if (_projet != null) ...[
            const SizedBox(width: 6),
            _ActiveChip(
              label: _projet!,
              icon: Icons.folder_outlined,
              onRemove: () => setState(() { _projet = null; _applyFiltersNoClose(); }),
            ),
          ],
          const Spacer(),
          if (count > 0)
            GestureDetector(
              onTap: _resetFilters,
              child: const Text('Tout effacer',
                  style: TextStyle(fontSize: 12, color: AppTheme.primary,
                      fontWeight: FontWeight.w500)),
            ),
        ]),

        const SizedBox(height: 14),

        // Types de tâches chips
        const Text('Types de tâches',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 6,
          children: TaskType.values.map((t) => ToggleChip(
            label: t.label, icon: t.icon, color: t.color,
            active: _types.contains(t),
            onTap: () {
              setState(() => _types.contains(t) ? _types.remove(t) : _types.add(t));
              _applyFiltersNoClose();
            },
          )).toList()),

        const SizedBox(height: 10),

        // Statuts chips
        const Text('Statuts',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 6,
          children: TaskStatus.values.map((s) => ToggleChip(
            label: s.label, icon: s.icon, color: s.color,
            active: _statuses.contains(s),
            onTap: () {
              setState(() => _statuses.contains(s) ? _statuses.remove(s) : _statuses.add(s));
              _applyFiltersNoClose();
            },
          )).toList()),
      ]),
    );
  }

  // ════════════════════════════════════════════════
  // CALENDAR CARD
  // ════════════════════════════════════════════════
  Widget _buildCalendarCard() {
    return Container(
      color: Colors.white,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Container(
            decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(10)),
            child: TabBar(
              controller: _tabCtrl,
              indicator: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(8)),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: AppTheme.primary,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              dividerColor: Colors.transparent,
              tabs: const [Tab(text: 'Mois'), Tab(text: 'Semaine'), Tab(text: 'Jour')],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _tabCtrl,
          builder: (_, __) {
            switch (_tabCtrl.index) {
              case 0: return _MonthCalendar(
                  month: _month, selected: _selectedDay, tasks: appTasks,
                  onMonthChanged: (m) => setState(() => _month = m),
                  onDayTapped: _onDaySelected);
              case 1: return _WeekCalendar(
                  weekStart: _weekStart, selected: _selectedDay, tasks: appTasks,
                  onWeekChanged: (w) => setState(() => _weekStart = w),
                  onDayTapped: _onDaySelected);
              case 2: return _DayCalendar(
                  day: _dayFocus, tasks: appTasks,
                  onDayChanged: (d) => setState(() { _dayFocus = d; _onDaySelected(d); }));
              default: return const SizedBox();
            }
          },
        ),
      ]),
    );
  }

  // ════════════════════════════════════════════════
  // TASK LIST
  // ════════════════════════════════════════════════
  Widget _buildTaskList() {
    final tasks = _visibleTasks;
    return Container(
      key: _taskListKey,
      color: AppTheme.background,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Tâches récentes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary)),
              if (_selectedDay != null)
                GestureDetector(
                  onTap: () => setState(() => _selectedDay = null),
                  child: Row(children: [
                    Text(DateFormat('dd MMMM yyyy', 'fr_FR').format(_selectedDay!),
                        style: const TextStyle(fontSize: 12, color: AppTheme.primary,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(width: 4),
                    const Icon(Icons.close, size: 13, color: AppTheme.primary),
                  ]),
                ),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.3))),
              child: Text('${tasks.length} tâche${tasks.length > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 12, color: AppTheme.primary,
                      fontWeight: FontWeight.w600)),
            ),
          ]),
        ),

        if (tasks.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.cardBorder)),
              child: Center(child: Column(children: [
                Icon(Icons.search_off, size: 48,
                    color: AppTheme.primary.withOpacity(0.3)),
                const SizedBox(height: 12),
                const Text('Aucune tâche trouvée',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 15)),
                const SizedBox(height: 4),
                const Text('Modifiez vos filtres ou sélectionnez un autre jour',
                    style: TextStyle(color: AppTheme.textHint, fontSize: 12),
                    textAlign: TextAlign.center),
              ])),
            ),
          )
        else
          ...tasks.map((t) => _TaskRow(
            task: t,
            onTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (_) => TaskDetailScreen(task: t)));
              setState(() => _displayed = List.from(appTasks));
            },
          )),

        // Ajouter une tâche
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: GestureDetector(
            onTap: _addTask,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.4))),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add_circle_outline, color: AppTheme.primary, size: 20),
                SizedBox(width: 8),
                Text('Ajouter une tâche',
                    style: TextStyle(color: AppTheme.primary,
                        fontWeight: FontWeight.w600, fontSize: 14)),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  // ════════════════════════════════════════════════
  // APP BAR
  // ════════════════════════════════════════════════
  AppBar _appBar() => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: Builder(builder: (ctx) => IconButton(
        icon: const Icon(Icons.menu, color: AppTheme.textPrimary),
        onPressed: () => Scaffold.of(ctx).openDrawer())),
    title: Row(children: [
      Container(width: 8, height: 8,
          decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      const Text('Agenda', style: TextStyle(color: AppTheme.textPrimary,
          fontWeight: FontWeight.w700, fontSize: 20)),
    ]),
    actions: [
      IconButton(
        icon: const Icon(Icons.search, color: AppTheme.textSecondary),
        onPressed: () async {
          final task = await Navigator.push<Task>(
              context, MaterialPageRoute(builder: (_) => const SearchScreen()));
          if (task != null && mounted) {
            setState(() { _displayed = List.from(appTasks); _selectedDay = task.date; });
            _scrollToTasks();
          }
        },
      ),
      Stack(children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: AppTheme.textSecondary),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen())),
        ),
        Positioned(right: 8, top: 8, child: Container(
            width: 8, height: 8,
            decoration: const BoxDecoration(
                color: AppTheme.red, shape: BoxShape.circle))),
      ]),
      Padding(padding: const EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SettingsScreen())),
          child: const CircleAvatar(radius: 18, backgroundColor: AppTheme.primary,
              child: Text('A', style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold))),
        )),
    ],
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// FILTER DATA MODEL
// ═════════════════════════════════════════════════════════════════════════════
class _FilterData {
  final DateTime? dateDebut, dateFin;
  final String? projet, commercial, tc, motif;
  final String typeDate;
  final Set<TaskType> types;
  final Set<TaskStatus> statuses;
  const _FilterData({
    this.dateDebut, this.dateFin, this.projet, this.commercial,
    this.tc, this.motif, required this.typeDate,
    required this.types, required this.statuses,
  });
}

// ═════════════════════════════════════════════════════════════════════════════
// FILTER BOTTOM SHEET
// ═════════════════════════════════════════════════════════════════════════════
class _FilterSheet extends StatefulWidget {
  final DateTime? dateDebut, dateFin;
  final String? projet, commercial, tc, motif, typeDate;
  final Set<TaskType> activeTypes;
  final Set<TaskStatus> activeStatuses;
  final ValueChanged<_FilterData> onChanged;
  final VoidCallback onApply, onReset;

  const _FilterSheet({
    required this.dateDebut, required this.dateFin,
    required this.projet, required this.commercial,
    required this.tc, required this.motif,
    required this.typeDate, required this.activeTypes,
    required this.activeStatuses, required this.onChanged,
    required this.onApply, required this.onReset,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late DateTime? _dateDebut;
  late DateTime? _dateFin;
  late String? _projet, _commercial, _tc, _motif;
  late String _typeDate;
  late Set<TaskType> _types;
  late Set<TaskStatus> _statuses;

  @override
  void initState() {
    super.initState();
    _dateDebut  = widget.dateDebut;
    _dateFin    = widget.dateFin;
    _projet     = widget.projet;
    _commercial = widget.commercial;
    _tc         = widget.tc;
    _motif      = widget.motif;
    _typeDate   = widget.typeDate ?? 'planification';
    _types      = Set.from(widget.activeTypes);
    _statuses   = Set.from(widget.activeStatuses);
  }

  void _notify() => widget.onChanged(_FilterData(
    dateDebut: _dateDebut, dateFin: _dateFin, projet: _projet,
    commercial: _commercial, tc: _tc, motif: _motif, typeDate: _typeDate,
    types: Set.from(_types), statuses: Set.from(_statuses),
  ));

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _dateDebut : _dateFin) ?? DateTime(2026, 4),
      firstDate: DateTime(2020), lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary)),
        child: child!),
    );
    if (picked != null) {
      setState(() { if (isStart) _dateDebut = picked; else _dateFin = picked; });
      _notify();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollCtrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(children: [
          // Drag handle
          Container(margin: const EdgeInsets.only(top: 12),
              width: 40, height: 4,
              decoration: BoxDecoration(color: AppTheme.cardBorder,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.filter_alt_outlined,
                    color: AppTheme.primary, size: 20)),
              const SizedBox(width: 12),
              const Text('Filtres', style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _dateDebut = _dateFin = _projet = _commercial = _tc = _motif = null;
                    _typeDate = 'planification';
                    _types..clear()..addAll(TaskType.values);
                    _statuses..clear()..addAll(TaskStatus.values);
                  });
                  _notify();
                  widget.onReset();
                },
                child: const Text('Réinitialiser',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              ),
              IconButton(icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context)),
            ]),
          ),

          const Divider(),

          Expanded(child: ListView(controller: scrollCtrl,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: [

              // ── Période ─────────────────────────
              const _SheetLabel('Période'),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(child: _DateTile(
                  label: 'Date début', value: _dateDebut,
                  onTap: () => _pickDate(true),
                  onClear: _dateDebut != null
                      ? () { setState(() => _dateDebut = null); _notify(); }
                      : null,
                )),
                const SizedBox(width: 12),
                Expanded(child: _DateTile(
                  label: 'Date fin', value: _dateFin,
                  onTap: () => _pickDate(false),
                  onClear: _dateFin != null
                      ? () { setState(() => _dateFin = null); _notify(); }
                      : null,
                )),
              ]),
              const SizedBox(height: 20),

              // ── Projet ──────────────────────────
              const _SheetLabel('Projet'),
              const SizedBox(height: 8),
              _SheetDrop(hint: 'Sélectionner un projet', value: _projet,
                items: projets,
                onChanged: (v) { setState(() => _projet = v); _notify(); }),
              const SizedBox(height: 16),

              // ── Commercial ──────────────────────
              const _SheetLabel('Commercial'),
              const SizedBox(height: 8),
              _SheetDrop(hint: 'Sélectionner un commercial', value: _commercial,
                items: commerciaux,
                onChanged: (v) { setState(() => _commercial = v); _notify(); }),
              const SizedBox(height: 16),

              // ── TC ──────────────────────────────
              const _SheetLabel('TC'),
              const SizedBox(height: 8),
              _SheetDrop(hint: 'Sélectionner un TC', value: _tc, items: tcs,
                onChanged: (v) { setState(() => _tc = v); _notify(); }),
              const SizedBox(height: 16),

              // ── Motifs ──────────────────────────
              const _SheetLabel('Motifs'),
              const SizedBox(height: 8),
              _SheetDrop(hint: 'Sélectionner un motif', value: _motif, items: motifs,
                onChanged: (v) { setState(() => _motif = v); _notify(); }),
              const SizedBox(height: 20),

              // ── Type de date ────────────────────
              const _SheetLabel('Type de date'),
              const SizedBox(height: 6),
              _SheetRadio('Date planification', 'planification', _typeDate,
                  (v) { setState(() => _typeDate = v); _notify(); }),
              _SheetRadio('Date réalisation', 'realisation', _typeDate,
                  (v) { setState(() => _typeDate = v); _notify(); }),
              const SizedBox(height: 20),

              // ── Types de tâches ─────────────────
              const _SheetLabel('Types de tâches'),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8,
                children: TaskType.values.map((t) {
                  final active = _types.contains(t);
                  return GestureDetector(
                    onTap: () {
                      setState(() => active ? _types.remove(t) : _types.add(t));
                      _notify();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: active ? t.color.withOpacity(0.10) : Colors.white,
                        border: Border.all(
                            color: active ? t.color : AppTheme.cardBorder,
                            width: active ? 1.5 : 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(t.icon, size: 14,
                            color: active ? t.color : AppTheme.textHint),
                        const SizedBox(width: 5),
                        Text(t.label, style: TextStyle(fontSize: 13,
                            color: active ? t.color : AppTheme.textHint,
                            fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  );
                }).toList()),
              const SizedBox(height: 20),

              // ── Statuts ─────────────────────────
              const _SheetLabel('Statuts'),
              const SizedBox(height: 10),
              Wrap(spacing: 8, runSpacing: 8,
                children: TaskStatus.values.map((s) {
                  final active = _statuses.contains(s);
                  return GestureDetector(
                    onTap: () {
                      setState(() => active ? _statuses.remove(s) : _statuses.add(s));
                      _notify();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: active ? s.color.withOpacity(0.10) : Colors.white,
                        border: Border.all(
                            color: active ? s.color : AppTheme.cardBorder,
                            width: active ? 1.5 : 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(s.icon, size: 14,
                            color: active ? s.color : AppTheme.textHint),
                        const SizedBox(width: 5),
                        Text(s.label, style: TextStyle(fontSize: 13,
                            color: active ? s.color : AppTheme.textHint,
                            fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  );
                }).toList()),
              const SizedBox(height: 30),
            ],
          )),

          // ── Rechercher button ────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20,
                MediaQuery.of(context).padding.bottom + 16),
            child: SizedBox(width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onApply,
                icon: const Icon(Icons.search, size: 18),
                label: const Text('Rechercher'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
              )),
          ),
        ]),
      ),
    );
  }
}

// ─── Sheet sub-widgets ─────────────────────────────────────────────────────

class _SheetLabel extends StatelessWidget {
  final String text;
  const _SheetLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
          color: AppTheme.textPrimary));
}

class _SheetDrop extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  const _SheetDrop({required this.hint, required this.value,
    required this.items, required this.onChanged});
  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(
      filled: true, fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.cardBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.cardBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5)),
    ),
    hint: Text(hint, style: const TextStyle(color: AppTheme.textHint, fontSize: 13)),
    icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.primary),
    items: items.map((i) => DropdownMenuItem(value: i,
        child: Text(i, style: const TextStyle(fontSize: 13)))).toList(),
    onChanged: onChanged,
  );
}

class _SheetRadio extends StatelessWidget {
  final String label, value, groupValue;
  final ValueChanged<String> onChange;
  const _SheetRadio(this.label, this.value, this.groupValue, this.onChange);
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => onChange(value),
    child: Row(children: [
      Radio<String>(value: value, groupValue: groupValue,
          onChanged: (v) => onChange(v!), activeColor: AppTheme.primary,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
      Text(label, style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary)),
    ]),
  );
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  const _DateTile({required this.label, required this.value,
    required this.onTap, this.onClear});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
    const SizedBox(height: 5),
    GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
              color: value != null ? AppTheme.primary : AppTheme.cardBorder,
              width: value != null ? 1.5 : 1),
          borderRadius: BorderRadius.circular(10),
          color: value != null ? AppTheme.primaryLight : Colors.white,
        ),
        child: Row(children: [
          Icon(Icons.calendar_today_outlined, size: 15,
              color: value != null ? AppTheme.primary : AppTheme.textHint),
          const SizedBox(width: 8),
          Expanded(child: Text(
            value != null ? DateFormat('dd/MM/yyyy').format(value!) : 'jj/mm/aaaa',
            style: TextStyle(fontSize: 13,
                color: value != null ? AppTheme.primary : AppTheme.textHint,
                fontWeight: value != null ? FontWeight.w500 : FontWeight.w400),
          )),
          if (onClear != null)
            GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.close, size: 14, color: AppTheme.primary)),
        ]),
      ),
    ),
  ]);
}

// ─── Active filter chip (top bar) ─────────────────────────────────────────

class _ActiveChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onRemove;
  const _ActiveChip({required this.label, required this.icon, required this.onRemove});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        color: AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withOpacity(0.4))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 12, color: AppTheme.primary),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.primary,
          fontWeight: FontWeight.w500)),
      const SizedBox(width: 4),
      GestureDetector(onTap: onRemove,
          child: const Icon(Icons.close, size: 12, color: AppTheme.primary)),
    ]),
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// TASK ROW
// ═════════════════════════════════════════════════════════════════════════════
class _TaskRow extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  const _TaskRow({required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top:    BorderSide(color: Color(0xFFD1FAE5), width: 0.5),
          bottom: BorderSide(color: Color(0xFFD1FAE5), width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 36, height: 36,
              decoration: BoxDecoration(
                  color: task.type.color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(task.type.icon, size: 18, color: task.type.color)),
            const SizedBox(width: 10),
            Expanded(child: Text(task.title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary))),
            const Icon(Icons.chevron_right, color: AppTheme.textHint, size: 20),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            _Badge(task.type.label, task.type.color),
            const SizedBox(width: 8),
            _Badge(task.status.label, task.status.color),
          ]),
          const SizedBox(height: 10),
          _Det(Icons.calendar_today_outlined,
              DateFormat('dd MMM. yyyy', 'fr_FR').format(task.date)),
          const SizedBox(height: 4),
          _Det(Icons.access_time_outlined, task.time),
          const SizedBox(height: 4),
          _Det(Icons.location_on_outlined, task.location),
          const SizedBox(height: 4),
          _Det(Icons.person_outline, task.assignee),
        ]),
      ),
    ),
  );
}

class _Badge extends StatelessWidget {
  final String label; final Color color;
  const _Badge(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(14),
        color: color.withOpacity(0.07)),
    child: Text(label, style: TextStyle(fontSize: 12, color: color,
        fontWeight: FontWeight.w500)));
}

class _Det extends StatelessWidget {
  final IconData icon; final String text;
  const _Det(this.icon, this.text);
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, size: 13, color: AppTheme.textSecondary),
    const SizedBox(width: 6),
    Text(text, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
  ]);
}

// ═════════════════════════════════════════════════════════════════════════════
// MONTH CALENDAR
// ═════════════════════════════════════════════════════════════════════════════
class _MonthCalendar extends StatelessWidget {
  final DateTime month;
  final DateTime? selected;
  final List<Task> tasks;
  final ValueChanged<DateTime> onMonthChanged, onDayTapped;

  static const _wd = ['Lun','Mar','Mer','Jeu','Ven','Sam','Dim'];
  static const _mn = ['Janvier','Février','Mars','Avril','Mai','Juin',
    'Juillet','Août','Septembre','Octobre','Novembre','Décembre'];

  const _MonthCalendar({required this.month, required this.selected,
    required this.tasks, required this.onMonthChanged, required this.onDayTapped});

  Map<int, int> get _dots {
    final m = <int, int>{};
    for (final t in tasks) {
      if (t.date.year == month.year && t.date.month == month.month) {
        m[t.date.day] = (m[t.date.day] ?? 0) + 1;
      }
    }
    return m;
  }

  @override
  Widget build(BuildContext context) {
    final today  = DateTime.now();
    final first  = DateTime(month.year, month.month, 1);
    final last   = DateTime(month.year, month.month + 1, 0);
    final offset = first.weekday - 1;
    final dots   = _dots;

    List<Widget> cells = [];
    for (int i = 0; i < offset; i++) {
      cells.add(_MCell(
          day: first.subtract(Duration(days: offset - i)).day, dimmed: true));
    }
    for (int d = 1; d <= last.day; d++) {
      final date    = DateTime(month.year, month.month, d);
      final isToday = date.year == today.year && date.month == today.month &&
          date.day == today.day;
      final isSel   = selected != null && date.year == selected!.year &&
          date.month == selected!.month && date.day == selected!.day;
      cells.add(GestureDetector(
        onTap: () => onDayTapped(date),
        child: _MCell(day: d, isToday: isToday, isSelected: isSel,
            dots: (dots[d] ?? 0).clamp(0, 3)),
      ));
    }
    final trail = (7 - cells.length % 7) % 7;
    for (int i = 1; i <= trail; i++) cells.add(_MCell(day: i, dimmed: true));

    final rows = <Widget>[];
    for (int i = 0; i < cells.length; i += 7) {
      rows.add(Row(
          children: cells.sublist(i, i + 7)
              .map((c) => Expanded(child: c)).toList()));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
              icon: const Icon(Icons.chevron_left, color: AppTheme.primary),
              onPressed: () =>
                  onMonthChanged(DateTime(month.year, month.month - 1))),
          Text('${_mn[month.month - 1]} ${month.year}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16,
                  color: AppTheme.textPrimary)),
          IconButton(
              icon: const Icon(Icons.chevron_right, color: AppTheme.primary),
              onPressed: () =>
                  onMonthChanged(DateTime(month.year, month.month + 1))),
        ]),
        Row(children: _wd.map((d) => Expanded(child: Center(child: Text(d,
            style: const TextStyle(fontSize: 12, color: AppTheme.primary,
                fontWeight: FontWeight.w600))))).toList()),
        const SizedBox(height: 4),
        Column(children: rows),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 13, height: 13,
              decoration: const BoxDecoration(
                  color: AppTheme.primary, shape: BoxShape.circle)),
          const SizedBox(width: 5),
          const Text("Aujourd'hui",
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          const SizedBox(width: 18),
          Container(width: 14, height: 3, decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.45),
              borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 5),
          const Text('Tâches',
              style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        ]),
      ]),
    );
  }
}

class _MCell extends StatelessWidget {
  final int day, dots;
  final bool isToday, isSelected, dimmed;
  const _MCell({required this.day, this.dots = 0, this.isToday = false,
    this.isSelected = false, this.dimmed = false});

  @override
  Widget build(BuildContext context) {
    final bg = isSelected
        ? AppTheme.primary
        : isToday
        ? AppTheme.primary.withOpacity(0.12)
        : Colors.transparent;
    final tc = isSelected
        ? Colors.white
        : dimmed
        ? AppTheme.cardBorder
        : AppTheme.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(children: [
        Container(width: 34, height: 34,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text('$day', style: TextStyle(fontSize: 13,
                fontWeight: (isToday || isSelected) ? FontWeight.w700 : FontWeight.w400,
                color: tc))),
        const SizedBox(height: 3),
        if (dots > 0)
          Row(mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(dots, (_) => Container(
                  width: 4, height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                      color: isSelected ? Colors.white : AppTheme.primary,
                      shape: BoxShape.circle))))
        else
          const SizedBox(height: 4),
      ]),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// WEEK CALENDAR
// ═════════════════════════════════════════════════════════════════════════════
class _WeekCalendar extends StatelessWidget {
  final DateTime weekStart;
  final DateTime? selected;
  final List<Task> tasks;
  final ValueChanged<DateTime> onWeekChanged, onDayTapped;

  static const _wd = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  const _WeekCalendar({required this.weekStart, required this.selected,
    required this.tasks, required this.onWeekChanged, required this.onDayTapped});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days  = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    final sf = DateFormat('dd MMM', 'fr_FR').format(weekStart);
    final ef = DateFormat('dd MMM yyyy', 'fr_FR')
        .format(weekStart.add(const Duration(days: 6)));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
              icon: const Icon(Icons.chevron_left, color: AppTheme.primary),
              onPressed: () =>
                  onWeekChanged(weekStart.subtract(const Duration(days: 7)))),
          Text('$sf – $ef',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          IconButton(
              icon: const Icon(Icons.chevron_right, color: AppTheme.primary),
              onPressed: () =>
                  onWeekChanged(weekStart.add(const Duration(days: 7)))),
        ]),
        Row(children: List.generate(7, (i) {
          final day     = days[i];
          final isToday = day.year == today.year && day.month == today.month &&
              day.day == today.day;
          final isSel   = selected != null && day.year == selected!.year &&
              day.month == selected!.month && day.day == selected!.day;
          final hasTasks = tasks.any((t) =>
              t.date.year == day.year && t.date.month == day.month &&
              t.date.day == day.day);
          return Expanded(child: GestureDetector(
            onTap: () => onDayTapped(day),
            child: Column(children: [
              Text(_wd[i], style: const TextStyle(fontSize: 11,
                  color: AppTheme.primary, fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 36, height: 36,
                decoration: BoxDecoration(
                    color: isSel ? AppTheme.primary : isToday
                        ? AppTheme.primary.withOpacity(0.1)
                        : Colors.transparent,
                    shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text('${day.day}', style: TextStyle(fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isSel ? Colors.white
                        : isToday ? AppTheme.primary : AppTheme.textPrimary)),
              ),
              const SizedBox(height: 4),
              Container(width: 5, height: 5, decoration: BoxDecoration(
                  color: hasTasks
                      ? AppTheme.primary.withOpacity(isSel ? 1 : 0.4)
                      : Colors.transparent,
                  shape: BoxShape.circle)),
            ]),
          ));
        })),
        const SizedBox(height: 12),
        const Divider(height: 1, color: AppTheme.cardBorder),
        const SizedBox(height: 10),
        ...days.expand((day) {
          final dt = tasks.where((t) =>
              t.date.year == day.year && t.date.month == day.month &&
              t.date.day == day.day).toList();
          if (dt.isEmpty) return <Widget>[];
          return [
            Padding(padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(DateFormat('EEEE dd MMMM', 'fr_FR').format(day),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                      color: AppTheme.primary))),
            ...dt.map((t) => _WeekTile(task: t)),
          ];
        }),
      ]),
    );
  }
}

class _WeekTile extends StatelessWidget {
  final Task task;
  const _WeekTile({required this.task});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: task.type.color.withOpacity(0.05),
      border: Border(left: BorderSide(color: task.type.color, width: 3)),
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
    ),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title, style: const TextStyle(fontSize: 13,
              fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
          const SizedBox(height: 2),
          Text('${task.time} · ${task.location}',
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        ])),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: task.status.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: task.status.color.withOpacity(0.3))),
        child: Text(task.status.label, style: TextStyle(fontSize: 10,
            color: task.status.color, fontWeight: FontWeight.w600))),
    ]),
  );
}

// ═════════════════════════════════════════════════════════════════════════════
// DAY CALENDAR
// ═════════════════════════════════════════════════════════════════════════════
class _DayCalendar extends StatelessWidget {
  final DateTime day;
  final List<Task> tasks;
  final ValueChanged<DateTime> onDayChanged;

  static const _mos = ['Janvier','Février','Mars','Avril','Mai','Juin',
    'Juillet','Août','Septembre','Octobre','Novembre','Décembre'];
  static const _dys = ['Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi','Dimanche'];

  const _DayCalendar({required this.day, required this.tasks,
    required this.onDayChanged});

  @override
  Widget build(BuildContext context) {
    final dayTasks = tasks.where((t) =>
        t.date.year == day.year && t.date.month == day.month &&
        t.date.day == day.day).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
              icon: const Icon(Icons.chevron_left, color: AppTheme.primary),
              onPressed: () =>
                  onDayChanged(day.subtract(const Duration(days: 1)))),
          Column(children: [
            Text(_dys[day.weekday - 1],
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            Text('${day.day} ${_mos[day.month - 1]} ${day.year}',
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ]),
          IconButton(
              icon: const Icon(Icons.chevron_right, color: AppTheme.primary),
              onPressed: () => onDayChanged(day.add(const Duration(days: 1)))),
        ]),
        const SizedBox(height: 10),
        if (dayTasks.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.cardBorder)),
            child: const Column(children: [
              Icon(Icons.event_available, size: 40, color: AppTheme.primary),
              SizedBox(height: 8),
              Text('Aucune tâche ce jour',
                  style: TextStyle(color: AppTheme.primary,
                      fontWeight: FontWeight.w500)),
            ]))
        else
          ...dayTasks.map((t) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: t.type.color.withOpacity(0.05),
              border: Border.all(color: t.type.color.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              Column(children: [
                Text(t.time.split(':')[0], style: TextStyle(fontSize: 22,
                    fontWeight: FontWeight.w800, color: t.type.color)),
                Text(':${t.time.split(':')[1]}',
                    style: TextStyle(fontSize: 12, color: t.type.color)),
              ]),
              const SizedBox(width: 14),
              Container(width: 2, height: 50, decoration: BoxDecoration(
                  color: t.type.color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(1))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.title, style: const TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.location_on_outlined, size: 12, color: t.type.color),
                    const SizedBox(width: 4),
                    Text(t.location,
                        style: TextStyle(fontSize: 11, color: t.type.color)),
                  ]),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: t.status.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(t.status.label, style: TextStyle(fontSize: 10,
                        color: t.status.color, fontWeight: FontWeight.w600))),
                ])),
            ]),
          )),
      ]),
    );
  }
}
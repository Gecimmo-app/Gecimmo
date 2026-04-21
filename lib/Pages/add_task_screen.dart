import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/sample_data.dart';
import '../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task; // null = create, non-null = edit
  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _notesCtrl;

  TaskType   _type   = TaskType.rendezvous;
  TaskStatus _status = TaskStatus.aVenir;
  DateTime   _date   = DateTime.now().add(const Duration(days: 1));
  TimeOfDay  _time   = const TimeOfDay(hour: 10, minute: 0);
  String?    _assignee;
  String?    _project;

  bool get _isEdit => widget.task != null;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _titleCtrl    = TextEditingController(text: t?.title ?? '');
    _locationCtrl = TextEditingController(text: t?.location ?? '');
    _notesCtrl    = TextEditingController(text: t?.notes ?? '');
    if (t != null) {
      _type     = t.type;
      _status   = t.status;
      _date     = t.date;
      _assignee = t.assignee;
      _project  = t.project;
      final parts = t.time.split(':');
      _time = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose(); _locationCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final timeStr = '${_time.hour.toString().padLeft(2,'0')}:${_time.minute.toString().padLeft(2,'0')}';

    if (_isEdit) {
      final updated = widget.task!.copyWith(
        title: _titleCtrl.text.trim(), type: _type, status: _status,
        date: _date, time: timeStr, location: _locationCtrl.text.trim(),
        assignee: _assignee ?? commerciaux.first, project: _project, notes: _notesCtrl.text.trim(),
      );
      final idx = appTasks.indexWhere((t) => t.id == updated.id);
      if (idx != -1) appTasks[idx] = updated;
      Navigator.pop(context, updated);
    } else {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleCtrl.text.trim(), type: _type, status: _status,
        date: _date, time: timeStr, location: _locationCtrl.text.trim(),
        assignee: _assignee ?? commerciaux.first, project: _project, notes: _notesCtrl.text.trim(),
      );
      appTasks.insert(0, task);
      Navigator.pop(context, task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: Text(_isEdit ? 'Modifier la tâche' : 'Nouvelle tâche')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            // ── Type selector ──────────────────────
            Card(child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Type de tâche', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                const SizedBox(height: 12),
                Row(children: TaskType.values.map((t) {
                  final sel = _type == t;
                  return Expanded(child: GestureDetector(
                    onTap: () => setState(() => _type = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: sel ? t.color : Colors.white,
                        border: Border.all(color: sel ? t.color : AppTheme.cardBorder),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(children: [
                        Icon(t.icon, size: 20, color: sel ? Colors.white : t.color),
                        const SizedBox(height: 4),
                        Text(t.label, textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: sel ? Colors.white : t.color, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  ));
                }).toList()),
              ]),
            )),
            const SizedBox(height: 12),

            // ── Title ─────────────────────────────
            Card(child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const _FieldLabel('Titre *'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(hintText: 'Ex: Rendez-vous client - Entreprise X'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Le titre est requis' : null,
                ),
              ]),
            )),
            const SizedBox(height: 12),

            // ── Date & Time ────────────────────────
            Card(child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const _FieldLabel('Date & Heure *'),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _Tappable(
                    icon: Icons.calendar_today_outlined,
                    text: DateFormat('dd/MM/yyyy').format(_date),
                    onTap: () async {
                      final picked = await showDatePicker(context: context,
                        initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime(2030));
                      if (picked != null) setState(() => _date = picked);
                    },
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _Tappable(
                    icon: Icons.access_time_outlined,
                    text: _time.format(context),
                    onTap: () async {
                      final picked = await showTimePicker(context: context, initialTime: _time);
                      if (picked != null) setState(() => _time = picked);
                    },
                  )),
                ]),
              ]),
            )),
            const SizedBox(height: 12),

            // ── Location & Assignee ────────────────
            Card(child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const _FieldLabel('Lieu'),
                const SizedBox(height: 8),
                TextFormField(controller: _locationCtrl, decoration: const InputDecoration(hintText: 'Ex: Paris, France')),
                const SizedBox(height: 16),
                const _FieldLabel('Assigné à'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _assignee,
                  decoration: const InputDecoration(),
                  hint: const Text('Sélectionner un commercial', style: TextStyle(color: AppTheme.textHint, fontSize: 13)),
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
                  items: commerciaux.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
                  onChanged: (v) => setState(() => _assignee = v),
                ),
                const SizedBox(height: 16),
                const _FieldLabel('Projet'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _project,
                  decoration: const InputDecoration(),
                  hint: const Text('Sélectionner un projet', style: TextStyle(color: AppTheme.textHint, fontSize: 13)),
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
                  items: projets.map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 13)))).toList(),
                  onChanged: (v) => setState(() => _project = v),
                ),
              ]),
            )),
            const SizedBox(height: 12),

            // ── Status ─────────────────────────────
            Card(child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const _FieldLabel('Statut'),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8,
                  children: TaskStatus.values.map((s) {
                    final sel = _status == s;
                    return GestureDetector(
                      onTap: () => setState(() => _status = s),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel ? s.color : Colors.white,
                          border: Border.all(color: sel ? s.color : AppTheme.cardBorder),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(s.icon, size: 14, color: sel ? Colors.white : s.color),
                          const SizedBox(width: 5),
                          Text(s.label, style: TextStyle(fontSize: 13,
                            color: sel ? Colors.white : s.color, fontWeight: FontWeight.w500)),
                        ]),
                      ),
                    );
                  }).toList()),
              ]),
            )),
            const SizedBox(height: 12),

            // ── Notes ─────────────────────────────
            Card(child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const _FieldLabel('Notes'),
                const SizedBox(height: 8),
                TextFormField(controller: _notesCtrl, maxLines: 4,
                  decoration: const InputDecoration(hintText: 'Ajouter des notes ou instructions...')),
              ]),
            )),
            const SizedBox(height: 24),

            SizedBox(width: double.infinity, child: ElevatedButton.icon(
              onPressed: _save,
              icon: Icon(_isEdit ? Icons.check : Icons.add),
              label: Text(_isEdit ? 'Enregistrer les modifications' : 'Créer la tâche'),
            )),
            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textSecondary));
}

class _Tappable extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _Tappable({required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.cardBorder),
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF9FAFB),
      ),
      child: Row(children: [
        Icon(icon, size: 16, color: AppTheme.textHint),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary)),
      ]),
    ),
  );
}
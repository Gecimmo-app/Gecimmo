import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import 'toggle_chip.dart';

class FiltersPanel extends StatefulWidget {
  final List<String> projets;
  final List<String> commerciaux;
  final List<String> tcs;
  final List<String> motifs;
  final VoidCallback? onSearch;

  const FiltersPanel({
    super.key,
    required this.projets,
    required this.commerciaux,
    required this.tcs,
    required this.motifs,
    this.onSearch,
  });

  @override
  State<FiltersPanel> createState() => _FiltersPanelState();
}

class _FiltersPanelState extends State<FiltersPanel> {
  DateTime? _dateDebut;
  DateTime? _dateFin;
  String? _projet;
  String? _commercial;
  String? _tc;
  String? _motif;
  String _typeDateSelection = 'planification';

  final Set<TaskType> _activeTypes = {
    TaskType.rendezvous,
    TaskType.rappel,
    TaskType.opportunite,
    TaskType.report,
  };

  final Set<TaskStatus> _activeStatuses = {
    TaskStatus.realisees,
    TaskStatus.depassees,
    TaskStatus.aVenir,
    TaskStatus.annulees,
  };

  void _reset() => setState(() {
        _dateDebut = null;
        _dateFin = null;
        _projet = null;
        _commercial = null;
        _tc = null;
        _motif = null;
        _typeDateSelection = 'planification';
        _activeTypes
          ..clear()
          ..addAll(TaskType.values);
        _activeStatuses
          ..clear()
          ..addAll(TaskStatus.values);
      });

  void _toggleType(TaskType t) => setState(() =>
      _activeTypes.contains(t) ? _activeTypes.remove(t) : _activeTypes.add(t));

  void _toggleStatus(TaskStatus s) => setState(() =>
      _activeStatuses.contains(s) ? _activeStatuses.remove(s) : _activeStatuses.add(s));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────
            _SectionHeader(
              icon: Icons.filter_alt_outlined,
              label: 'Filtres',
              color: AppTheme.primary,
            ),
            const Divider(height: 24),

            // ── Date range ─────────────────────────
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: 'Date début',
                    value: _dateDebut,
                    onPicked: (d) => setState(() => _dateDebut = d),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateField(
                    label: 'Date fin',
                    value: _dateFin,
                    onPicked: (d) => setState(() => _dateFin = d),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Dropdowns ──────────────────────────
            _AppDropdown(
              label: 'Projet',
              hint: 'Sélectionner un projet',
              value: _projet,
              items: widget.projets,
              onChanged: (v) => setState(() => _projet = v),
            ),
            const SizedBox(height: 12),
            _AppDropdown(
              label: 'Commercial',
              hint: 'Sélectionner un commercial',
              value: _commercial,
              items: widget.commerciaux,
              onChanged: (v) => setState(() => _commercial = v),
            ),
            const SizedBox(height: 12),
            _AppDropdown(
              label: 'TC',
              hint: 'Sélectionner un TC',
              value: _tc,
              items: widget.tcs,
              onChanged: (v) => setState(() => _tc = v),
            ),
            const SizedBox(height: 12),
            _AppDropdown(
              label: 'Motifs',
              hint: 'Sélectionner un motif',
              value: _motif,
              items: widget.motifs,
              onChanged: (v) => setState(() => _motif = v),
            ),
            const SizedBox(height: 16),

            // ── Type de date ───────────────────────
            const Text(
              'Type de date',
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 4),
            _RadioRow(
              label: 'Date planification',
              value: 'planification',
              groupValue: _typeDateSelection,
              onChanged: (v) => setState(() => _typeDateSelection = v),
            ),
            _RadioRow(
              label: 'Date réalisation',
              value: 'realisation',
              groupValue: _typeDateSelection,
              onChanged: (v) => setState(() => _typeDateSelection = v),
            ),
            const SizedBox(height: 16),

            // ── Action buttons ─────────────────────
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onSearch,
                    child: const Text('Rechercher'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    child: const Text('Réinitialiser'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Types de tâches ────────────────────
            const Text(
              'Types de tâches',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TaskType.values
                  .map((t) => ToggleChip(
                        label: t.label,
                        icon: t.icon,
                        color: t.color,
                        active: _activeTypes.contains(t),
                        onTap: () => _toggleType(t),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 16),

            // ── Statuts ────────────────────────────
            const Text(
              'Statuts',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TaskStatus.values
                  .map((s) => ToggleChip(
                        label: s.label,
                        icon: s.icon,
                        color: s.color,
                        active: _activeStatuses.contains(s),
                        onTap: () => _toggleStatus(s),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private sub-widgets ───────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      );
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onPicked;

  const _DateField({
    required this.label,
    required this.value,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) onPicked(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.cardBorder),
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF9FAFB),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null
                        ? DateFormat('dd/MM/yyyy').format(value!)
                        : 'jj/mm/aaaa',
                    style: TextStyle(
                      fontSize: 13,
                      color: value != null
                          ? AppTheme.textPrimary
                          : AppTheme.textHint,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: AppTheme.textHint),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AppDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _AppDropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          decoration: const InputDecoration(),
          hint: Text(hint,
              style: const TextStyle(color: AppTheme.textHint, fontSize: 13)),
          icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
          items: items
              .map((i) => DropdownMenuItem(
                    value: i,
                    child: Text(i, style: const TextStyle(fontSize: 13)),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _RadioRow extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _RadioRow({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onChanged(value),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
              activeColor: AppTheme.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Text(label,
                style: const TextStyle(
                    fontSize: 14, color: AppTheme.textPrimary)),
          ],
        ),
      );
}
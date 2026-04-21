import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AgendaCalendar extends StatefulWidget {
  final DateTime initialMonth;
  final DateTime? selectedDay;
  final Map<int, int> taskDots; // day → dot count
  final ValueChanged<DateTime>? onDaySelected;

  const AgendaCalendar({
    super.key,
    required this.initialMonth,
    this.selectedDay,
    this.taskDots = const {},
    this.onDaySelected,
  });

  @override
  State<AgendaCalendar> createState() => _AgendaCalendarState();
}

class _AgendaCalendarState extends State<AgendaCalendar> {
  late DateTime _month;
  DateTime? _selected;

  static const _weekdays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  static const _months = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];

  @override
  void initState() {
    super.initState();
    _month = widget.initialMonth;
    _selected = widget.selectedDay;
  }

  void _prevMonth() => setState(() =>
      _month = DateTime(_month.year, _month.month - 1));

  void _nextMonth() => setState(() =>
      _month = DateTime(_month.year, _month.month + 1));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildWeekdayRow(),
            const SizedBox(height: 8),
            _buildGrid(),
            const SizedBox(height: 12),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _NavButton(icon: Icons.chevron_left, onTap: _prevMonth),
        Text(
          '${_months[_month.month - 1]} ${_month.year}',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        _NavButton(icon: Icons.chevron_right, onTap: _nextMonth),
      ],
    );
  }

  Widget _buildWeekdayRow() {
    return Row(
      children: _weekdays
          .map((d) => Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildGrid() {
    final firstDay = DateTime(_month.year, _month.month, 1);
    final lastDay = DateTime(_month.year, _month.month + 1, 0);
    final today = DateTime.now();
    final startOffset = firstDay.weekday - 1; // Mon = 0

    List<Widget> cells = [];

    // Leading empty / prev-month days
    for (int i = 0; i < startOffset; i++) {
      final day = firstDay.subtract(Duration(days: startOffset - i));
      cells.add(_DayCell(day: day.day, dimmed: true));
    }

    // Current month days
    for (int d = 1; d <= lastDay.day; d++) {
      final date = DateTime(_month.year, _month.month, d);
      final isToday = date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
      final isSelected = _selected != null &&
          date.year == _selected!.year &&
          date.month == _selected!.month &&
          date.day == _selected!.day;

      cells.add(GestureDetector(
        onTap: () {
          setState(() => _selected = date);
          widget.onDaySelected?.call(date);
        },
        child: _DayCell(
          day: d,
          isToday: isToday,
          isSelected: isSelected,
          dots: widget.taskDots[d] ?? 0,
        ),
      ));
    }

    // Trailing next-month days
    final trailing = (7 - cells.length % 7) % 7;
    for (int i = 1; i <= trailing; i++) {
      cells.add(_DayCell(day: i, dimmed: true));
    }

    // Build weeks
    final rows = <Widget>[];
    for (int i = 0; i < cells.length; i += 7) {
      rows.add(Row(
        children: cells.sublist(i, i + 7).map((c) => Expanded(child: c)).toList(),
      ));
      if (i + 7 < cells.length) rows.add(const SizedBox(height: 2));
    }
    return Column(children: rows);
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 14, height: 14,
          decoration: const BoxDecoration(
              color: AppTheme.primary, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        const Text("Aujourd'hui",
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        const SizedBox(width: 20),
        Container(
          width: 14, height: 3,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        const Text('Tâches',
            style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ],
    );
  }
}

// ── Sub-widgets ───────────────────────────────────
class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(icon, color: AppTheme.textSecondary),
        onPressed: onTap,
        splashRadius: 20,
      );
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSelected;
  final int dots;
  final bool dimmed;

  const _DayCell({
    required this.day,
    this.isToday = false,
    this.isSelected = false,
    this.dots = 0,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isSelected
        ? AppTheme.primary
        : isToday
            ? AppTheme.primary.withOpacity(0.1)
            : Colors.transparent;

    final Color textColor = isSelected
        ? Colors.white
        : dimmed
            ? AppTheme.cardBorder
            : AppTheme.textPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 13,
                fontWeight: (isSelected || isToday) ? FontWeight.w700 : FontWeight.w400,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 2),
          if (dots > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                dots.clamp(0, 3),
                (_) => Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )
          else
            const SizedBox(height: 6),
        ],
      ),
    );
  }
}
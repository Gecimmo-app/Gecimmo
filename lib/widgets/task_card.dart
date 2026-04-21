import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import 'app_badge.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: AppTheme.textHint, size: 20),
                ],
              ),
              const SizedBox(height: 8),

              // Badges
              Row(
                children: [
                  AppBadge(
                    label: task.type.label,
                    color: task.type.color,
                    small: true,
                  ),
                  const SizedBox(width: 6),
                  AppBadge(
                    label: task.status.label,
                    color: task.status.color,
                    small: true,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Details
              _Detail(
                icon: Icons.calendar_today_outlined,
                text: DateFormat('dd MMM yyyy', 'fr_FR').format(task.date),
              ),
              const SizedBox(height: 4),
              _Detail(icon: Icons.access_time_outlined, text: task.time),
              const SizedBox(height: 4),
              _Detail(icon: Icons.location_on_outlined, text: task.location),
              const SizedBox(height: 4),
              _Detail(icon: Icons.person_outline, text: task.assignee),
            ],
          ),
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Detail({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppTheme.textSecondary),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
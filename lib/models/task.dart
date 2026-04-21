import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum TaskType   { rendezvous, rappel, opportunite, report }
enum TaskStatus { realisees, depassees, aVenir, annulees }

extension TaskTypeExt on TaskType {
  String get label {
    switch (this) {
      case TaskType.rendezvous:  return 'Rendez-vous';
      case TaskType.rappel:      return 'Rappel';
      case TaskType.opportunite: return 'Opportunité';
      case TaskType.report:      return 'Report';
    }
  }
  IconData get icon {
    switch (this) {
      case TaskType.rendezvous:  return Icons.calendar_today_outlined;
      case TaskType.rappel:      return Icons.phone_outlined;
      case TaskType.opportunite: return Icons.trending_up;
      case TaskType.report:      return Icons.refresh;
    }
  }
  Color get color {
    switch (this) {
      case TaskType.rendezvous:  return AppTheme.primary;
      case TaskType.rappel:      return AppTheme.teal;
      case TaskType.opportunite: return AppTheme.purple;
      case TaskType.report:      return AppTheme.slate;
    }
  }
}

extension TaskStatusExt on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.realisees: return 'Réalisées';
      case TaskStatus.depassees: return 'Dépassées';
      case TaskStatus.aVenir:    return 'À venir';
      case TaskStatus.annulees:  return 'Annulées';
    }
  }
  IconData get icon {
    switch (this) {
      case TaskStatus.realisees: return Icons.check_circle_outline;
      case TaskStatus.depassees: return Icons.error_outline;
      case TaskStatus.aVenir:    return Icons.access_time;
      case TaskStatus.annulees:  return Icons.cancel_outlined;
    }
  }
  Color get color {
    switch (this) {
      case TaskStatus.realisees: return AppTheme.primary;
      case TaskStatus.depassees: return AppTheme.red;
      case TaskStatus.aVenir:    return AppTheme.teal;
      case TaskStatus.annulees:  return AppTheme.orange;
    }
  }
}

class Task {
  final String id;
  final String title;
  final TaskType type;
  final TaskStatus status;
  final DateTime date;
  final String time;
  final String location;
  final String assignee;
  final String? project;
  final String? notes;

  const Task({
    required this.id, required this.title, required this.type,
    required this.status, required this.date, required this.time,
    required this.location, required this.assignee, this.project, this.notes,
  });

  Task copyWith({String? title, TaskType? type, TaskStatus? status,
    DateTime? date, String? time, String? location, String? assignee,
    String? project, String? notes}) => Task(
    id: id, title: title ?? this.title, type: type ?? this.type,
    status: status ?? this.status, date: date ?? this.date,
    time: time ?? this.time, location: location ?? this.location,
    assignee: assignee ?? this.assignee, project: project ?? this.project,
    notes: notes ?? this.notes,
  );
}

class Contact {
  final String id, name, email, phone, company, role;
  final Color avatarColor;
  const Contact({required this.id, required this.name, required this.email,
    required this.phone, required this.company, required this.role, required this.avatarColor});
}

class Project {
  final String id, name, client, status;
  final double progress;
  final Color color;
  final int taskCount;
  const Project({required this.id, required this.name, required this.client,
    required this.progress, required this.color, required this.taskCount, required this.status});
}

class AppNotification {
  final String id, title, body;
  final DateTime time;
  final bool read;
  final IconData icon;
  final Color color;
  const AppNotification({required this.id, required this.title, required this.body,
    required this.time, required this.read, required this.icon, required this.color});
}
import 'package:flutter/material.dart';
import '../models/task.dart';
class TaskDetailScreen extends StatelessWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Détail Tâche')));
  }
}

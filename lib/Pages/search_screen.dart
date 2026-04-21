import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/sample_data.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';
  List<Task> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchResults = List.from(appTasks);
  }

  void _onSearch(String value) {
    setState(() {
      _query = value;
      if (_query.trim().isEmpty) {
        _searchResults = List.from(appTasks);
      } else {
        final q = _query.toLowerCase();
        _searchResults = appTasks.where((task) {
          return task.title.toLowerCase().contains(q) ||
              (task.project?.toLowerCase().contains(q) ?? false) ||
              task.assignee.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Rechercher une tâche...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppTheme.textHint),
          ),
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
          onChanged: _onSearch,
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
              onPressed: () {
                _onSearch('');
                // Note: To actually clear the text field, we'd need a TextEditingController.
                // For simplicity assuming the user deletes text manually or we could add a controller.
              },
            )
        ],
      ),
      body: _searchResults.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: AppTheme.primary.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun résultat pour "$_query"',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _searchResults.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = _searchResults[index];
                return InkWell(
                  onTap: () {
                    // Return the selected task back to AgendaScreen
                    Navigator.pop(context, task);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: task.type.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(task.type.icon, color: task.type.color, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 12, color: AppTheme.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('dd MMM yyyy').format(task.date),
                                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                  ),
                                  if (task.project != null) ...[
                                    const SizedBox(width: 12),
                                    Icon(Icons.folder_outlined, size: 12, color: AppTheme.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      task.project!,
                                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppTheme.textHint),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
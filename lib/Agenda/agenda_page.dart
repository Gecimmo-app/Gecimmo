import 'package:flutter/material.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  String selectedView = "Semaine";
  DateTime selectedDate = DateTime.now();
  String selectedUser = "Utilisateurs (3)";
  bool showCompleted = false;
  
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 6));
  
  final List<String> hours = [
    "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00",
    "14:00", "15:00", "16:00", "17:00", "18:00", "19:00"
  ];
  
  List<DateTime> get weekDays {
    final start = _startDate;
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }
  
  void _ajouterVisite() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ajouter une visite (fonctionnalité à venir)'),
        backgroundColor: Color(0xFF1E40AF),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  void _showDatePickerDialog() {
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
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                              final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
                              tempStartDate = startOfWeek;
                              tempEndDate = startOfWeek.add(const Duration(days: 6));
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
                              tempEndDate = DateTime(now.year, now.month + 1, 0);
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
                              tempStartDate = DateTime.now().subtract(const Duration(days: 7));
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
                              tempStartDate = DateTime.now().subtract(const Duration(days: 30));
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
                              tempStartDate = DateTime.now().subtract(const Duration(days: 90));
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
                              tempStartDate = DateTime.now().subtract(const Duration(days: 365));
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
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Color(0xFF1E40AF)),
                            const SizedBox(width: 8),
                            Text(
                              "Choisir une plage de dates",
                              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${tempStartDate.day}/${tempStartDate.month}/${tempStartDate.year} - ${tempEndDate.day}/${tempEndDate.month}/${tempEndDate.year}",
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
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

  Widget _buildQuickSelectButton(String text, bool isSelected, VoidCallback onTap) {
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
  
  void _previousPeriod() {
    setState(() {
      if (selectedView == "Jour") {
        selectedDate = selectedDate.subtract(const Duration(days: 1));
      } else if (selectedView == "Semaine") {
        final newStart = _startDate.subtract(const Duration(days: 7));
        _startDate = newStart;
        _endDate = newStart.add(const Duration(days: 6));
      } else {
        selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
      }
    });
  }
  
  void _nextPeriod() {
    setState(() {
      if (selectedView == "Jour") {
        selectedDate = selectedDate.add(const Duration(days: 1));
      } else if (selectedView == "Semaine") {
        final newStart = _startDate.add(const Duration(days: 7));
        _startDate = newStart;
        _endDate = newStart.add(const Duration(days: 6));
      } else {
        selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
      }
    });
  }
  
  void _goToToday() {
    setState(() {
      selectedDate = DateTime.now();
      _startDate = selectedDate;
      _endDate = selectedDate.add(const Duration(days: 6));
    });
  }
  
  void _showNewTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime? startDate = DateTime.now();
    DateTime? endDate = DateTime.now().add(const Duration(hours: 1));
    String? assignedTo = "admin user";
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: Color(0xFF1E40AF),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Nouvelle tâche",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, size: 24, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Titre",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                              ),
                              TextSpan(
                                text: " *",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            hintText: "Ex: Réunion de lancement...",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Description", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Ajoutez des détails, liens ou objectifs...",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(text: "Début", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                    TextSpan(text: " *", style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: startDate!,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    setStateDialog(() {
                                      startDate = picked;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 18, color: Color(0xFF64748B)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "${startDate!.day}/${startDate!.month}/${startDate!.year} ${startDate!.hour}:${startDate!.minute.toString().padLeft(2, '0')}",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(text: "Fin", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                    TextSpan(text: " *", style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: endDate!,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    setStateDialog(() {
                                      endDate = picked;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 18, color: Color(0xFF64748B)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "${endDate!.day}/${endDate!.month}/${endDate!.year} ${endDate!.hour}:${endDate!.minute.toString().padLeft(2, '0')}",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Assigner à", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: assignedTo,
                              items: const [
                                DropdownMenuItem(value: "admin user", child: Text("admin user")),
                                DropdownMenuItem(value: "utilisateur10013", child: Text("utilisateur10013")),
                                DropdownMenuItem(value: "SAV - Agent technique", child: Text("SAV - Agent technique")),
                              ],
                              onChanged: (value) {
                                setStateDialog(() {
                                  assignedTo = value;
                                });
                              },
                              isExpanded: true,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey[400]!),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (titleController.text.isNotEmpty) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Tâche créée avec succès"), backgroundColor: Colors.green),
                                );
                              }
                            },
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text("Créer la tâche"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E40AF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec le titre "Agenda des Tâches"
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Agenda des Tâches",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Gérez et organisez vos tâches",
                      style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 16),
                    
                    // ✅ BUTTON "AJOUTER UNE VISITE" - 9dam l'3nwan, t7t l header (hna hiya lblasa lidart bi lkhdar)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _ajouterVisite,
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: const Text(
                          'Ajouter une visite',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E40AF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Filters Row (horizontal scroll)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          OutlinedButton(
                            onPressed: _showDatePickerDialog,
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  "${_startDate.day}/${_startDate.month}/${_startDate.year} - ${_endDate.day}/${_endDate.month}/${_endDate.year}",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF1E40AF),
                              side: const BorderSide(color: Color(0xFF1E40AF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedUser,
                                items: const [
                                  DropdownMenuItem(value: "Utilisateurs (3)", child: Text("Utilisateurs (3)")),
                                  DropdownMenuItem(value: "admin user", child: Text("admin user")),
                                  DropdownMenuItem(value: "utilisateur10013", child: Text("utilisateur10013")),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedUser = value!;
                                  });
                                },
                                icon: const Icon(Icons.arrow_drop_down),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              Checkbox(
                                value: showCompleted,
                                onChanged: (value) {
                                  setState(() {
                                    showCompleted = value ?? false;
                                  });
                                },
                                activeColor: const Color(0xFF1E40AF),
                              ),
                              const Text("Terminées"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // View Selector (Jour, Semaine, Mois)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6FB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildViewButton("Jour", 0),
                      _buildViewButton("Semaine", 1),
                      _buildViewButton("Mois", 2),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Calendar Header with Navigation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _previousPeriod,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    GestureDetector(
                      onTap: _goToToday,
                      child: Text(
                        "${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      onPressed: _nextPeriod,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Calendar Content based on selected view
              if (selectedView == "Semaine")
                _buildWeekView(),
              if (selectedView == "Jour")
                _buildDayView(),
              if (selectedView == "Mois")
                _buildMonthView(),
              
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewTaskDialog,
        backgroundColor: const Color(0xFF1E40AF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  
  Widget _buildViewButton(String label, int index) {
    final isSelected = (selectedView == label);
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedView = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E40AF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  
  Widget _buildWeekView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: weekDays.map((day) {
                  final isSelected = _isSameDay(day, selectedDate);
                  return SizedBox(
                    width: 80,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = day;
                          selectedView = "Jour";
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            _getDayShortName(day.weekday),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${day.day}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? const Color(0xFF1E40AF) : const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            ...hours.map((hour) => _buildTimeRow(hour)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDayView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: SizedBox(
                width: 80,
                child: Column(
                  children: [
                    Text(
                      _getDayShortName(selectedDate.weekday),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${selectedDate.day}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E40AF),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ...hours.map((hour) => _buildDayTimeRow(hour)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMonthView() {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final firstDayWeekday = firstDayOfMonth.weekday;
    final daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    final int startingOffset = firstDayWeekday == 7 ? 0 : firstDayWeekday;
    
    List<DateTime> calendarDays = [];
    final prevMonth = DateTime(selectedDate.year, selectedDate.month, 0);
    final daysInPrevMonth = prevMonth.day;
    for (int i = startingOffset - 1; i >= 0; i--) {
      calendarDays.add(DateTime(selectedDate.year, selectedDate.month - 1, daysInPrevMonth - i));
    }
    for (int i = 1; i <= daysInMonth; i++) {
      calendarDays.add(DateTime(selectedDate.year, selectedDate.month, i));
    }
    final remainingDays = 42 - calendarDays.length;
    for (int i = 1; i <= remainingDays; i++) {
      calendarDays.add(DateTime(selectedDate.year, selectedDate.month + 1, i));
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("LUN", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E40AF))),
                Text("MAR", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E40AF))),
                Text("MER", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E40AF))),
                Text("JEU", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E40AF))),
                Text("VEN", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E40AF))),
                Text("SAM", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E40AF))),
                Text("DIM", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E40AF))),
              ],
            ),
          ),
          ...List.generate(6, (row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (col) {
                final index = row * 7 + col;
                if (index >= calendarDays.length) return const SizedBox(width: 45, height: 60);
                final day = calendarDays[index];
                final isCurrentMonth = day.month == selectedDate.month;
                final isToday = _isSameDay(day, DateTime.now());
                final isSelected = _isSameDay(day, selectedDate);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = day;
                      selectedView = "Jour";
                    });
                  },
                  child: Container(
                    width: 45,
                    height: 60,
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF1E40AF) : (isToday ? const Color(0xFFFFF3E0) : Colors.transparent),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "${day.day}",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Colors.white : (isCurrentMonth ? const Color(0xFF1E293B) : Colors.grey[400]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildTimeRow(String hour) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 55,
            child: Text(
              hour,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          ...List.generate(7, (index) {
            return Container(
              width: 80,
              height: 45,
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Colors.grey[200]!)),
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildDayTimeRow(String hour) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 55,
            child: Text(
              hour,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Container(
            width: 80,
            height: 45,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey[200]!)),
            ),
          ),
        ],
      ),
    );
  }
  
  String _getDayShortName(int weekday) {
    const days = ["LUN", "MAR", "MER", "JEU", "VEN", "SAM", "DIM"];
    return days[weekday - 1];
  }
  
  String _getMonthName(int month) {
    const months = ["janv.", "févr.", "mars", "avr.", "mai", "juin", "juil.", "août", "sept.", "oct.", "nov.", "déc."];
    return months[month - 1];
  }
  
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.day == b.day && a.month == b.month;
  }
}
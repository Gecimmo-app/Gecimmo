import 'package:flutter/material.dart';
import 'dart:math';
import 'Dashbordprincpa.dart';
import '../Ajouter_visite.dart';

class ObservationsScreen extends StatefulWidget {
  const ObservationsScreen({super.key});

  @override
  State<ObservationsScreen> createState() => _ObservationsScreenState();
}

class _ObservationsScreenState extends State<ObservationsScreen> {
  // Filters state
  String? selectedProjet;
  String? selectedNature;
  DateTimeRange? selectedDateRange;
  String? selectedPeriodePreset;

  final List<String> projetOptions = [
    'Tous les projets', 'Projet1', 'Projet2', 'Projet3', 'Projet4', 'Projet5', 'Projet6'
  ];
  final List<String> natureOptions = [
    'Toutes les natures',
    'Réception Technique',
    'Livraison Technique',
    'Livraison Client',
    'Livraison Syndic',
    'Réclamation'
  ];
  final List<String> periodePresetOptions = [
    'Aujourd\'hui', 'Cette semaine', 'Ce mois', 'Cette année',
    '7 derniers jours', '30 derniers jours', '90 derniers jours', '365 derniers jours',
  ];

  void _showFilterSheet(
    BuildContext context,
    String title,
    List<String> options,
    String? currentValue,
    Function(String) onSelected, {
    required bool showSearch,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FilterSheetContent(
          title: title,
          options: options,
          currentValue: currentValue,
          onSelected: onSelected,
          showSearch: showSearch,
        );
      },
    );
  }

  void _showPeriodeDialog(BuildContext context) {
    showModalBottomSheet(
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
                    children: periodePresetOptions.map((preset) {
                      return FilterChip(
                        label: Text(preset),
                        selected: selectedPeriodePreset == preset,
                        onSelected: (selected) {
                          setStateModal(() {
                            selectedPeriodePreset = preset;
                            selectedDateRange = _getDateRangeFromPreset(preset);
                          });
                          Navigator.pop(context);
                          setState(() {});
                        },
                        selectedColor: const Color(0xFF3B82F6).withOpacity(0.2),
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
                        lastDate: DateTime(2030),
                        initialDateRange: selectedDateRange,
                      );
                      if (picked != null) {
                        setStateModal(() {
                          selectedDateRange = picked;
                          selectedPeriodePreset = null;
                        });
                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Choisir une plage de dates'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (selectedDateRange != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_formatDate(selectedDateRange!.start)} - ${_formatDate(selectedDateRange!.end)}',
                        style: const TextStyle(color: Color(0xFF3B82F6)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  DateTimeRange? _getDateRangeFromPreset(String preset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (preset) {
      case 'Aujourd\'hui': return DateTimeRange(start: today, end: today);
      case 'Cette semaine':
        final start = today.subtract(Duration(days: today.weekday - 1));
        return DateTimeRange(start: start, end: start.add(const Duration(days: 6)));
      case 'Ce mois':
        return DateTimeRange(start: DateTime(today.year, today.month, 1), end: DateTime(today.year, today.month + 1, 0));
      case 'Cette année':
        return DateTimeRange(start: DateTime(today.year, 1, 1), end: DateTime(today.year, 12, 31));
      case '7 derniers jours': return DateTimeRange(start: today.subtract(const Duration(days: 7)), end: today);
      case '30 derniers jours': return DateTimeRange(start: today.subtract(const Duration(days: 30)), end: today);
      case '90 derniers jours': return DateTimeRange(start: today.subtract(const Duration(days: 90)), end: today);
      case '365 derniers jours': return DateTimeRange(start: today.subtract(const Duration(days: 365)), end: today);
      default: return null;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    void openAddVisitFlow() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddVisitFlow()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF), // Soft modern background
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton(
          onPressed: openAddVisitFlow,
          backgroundColor: const Color(0xFF1E40AF),
          foregroundColor: Colors.white,
          elevation: 6,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildFiltersRow(),
            const SizedBox(height: 20),
            _buildKpiCard(),
            const SizedBox(height: 20),
            _buildStatusDistributionCard(),
            const SizedBox(height: 20),
            _buildUserObservationsCard(),
            const SizedBox(height: 20),
            _buildLocalityCard(),
            const SizedBox(height: 20),
            _buildTradeCard(),
            const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            icon: Icons.folder_outlined,
            label: selectedProjet != null && selectedProjet != 'Tous les projets' ? selectedProjet! : 'Projets (Tous)',
            onTap: () => _showFilterSheet(
              context,
              'Projets',
              projetOptions,
              selectedProjet,
              (value) => setState(() => selectedProjet = value),
              showSearch: true,
            ),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            icon: Icons.layers_outlined, 
            label: selectedNature != null && selectedNature != 'Toutes les natures' ? selectedNature! : 'Natures (Toutes)',
            onTap: () => _showFilterSheet(
              context,
              'Natures',
              natureOptions,
              selectedNature,
              (value) => setState(() => selectedNature = value),
              showSearch: false,
            ),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            icon: Icons.calendar_today_outlined,
            label: selectedPeriodePreset ?? (selectedDateRange != null ? '${_formatDate(selectedDateRange!.start)}...' : 'Période'),
            onTap: () => _showPeriodeDialog(context),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedProjet = null;
                selectedNature = null;
                selectedPeriodePreset = null;
                selectedDateRange = null;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 1)),
                ],
              ),
              child: const Text(
                'Réinitialiser',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            ),
            child: const Icon(Icons.analytics_rounded, color: Color(0xFF6366F1), size: 32),
          ),
          const SizedBox(height: 24),
          const Text(
            '31',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
              height: 1.0,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Observations créées',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'sur la période sélectionnée',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusDistributionCard() {
    final List<PieData> statusData = [
      PieData('Acceptée', 35, const Color(0xFFF97316)), // Orange
      PieData('Refusée', 20, const Color(0xFFEF4444)), // Red
      PieData('À Faire', 30, const Color(0xFF3B82F6)), // Blue
      PieData('Inconnu', 10, const Color(0xFF64748B)), // Grey
      PieData('Réalisée', 5, const Color(0xFF10B981)), // Green
    ];

    return ModernCard(
      title: 'Distribution par Statut',
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              width: 220,
              child: CustomPaint(
                painter: PieChartPainter(
                  statusData.map((e) => e.value).toList(),
                  statusData.map((e) => e.color).toList(),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: statusData.map((data) => _buildLegendItem(data.label, data.color)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF475569),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildUserObservationsCard() {
    List<int> yLabels = [22, 20, 18, 16, 14, 12, 10, 8, 6, 4, 2, 0];
    int maxDataValue = 24; // Visually corresponds to the top height

    // Liste dynamique des utilisateurs (actuellement un seul admin, mais prêt pour plusieurs)
    List<UserObservationData> userData = [
      UserObservationData('admin user', 23),
      // UserObservationData('autre user', 15), // Décommentez pour tester l'ajout d'utilisateurs !
    ];
    
    return ModernCard(
      title: 'Observations par Utilisateur',
      child: SizedBox(
        height: 280,
        child: Row(
          children: [
            // Y-Axis labels
            SizedBox(
              width: 24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: yLabels.map((val) => SizedBox(
                  height: 14, // Fixed height for perfect alignment
                  child: Center(
                    child: Text(
                      val.toString(),
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(width: 12),
            // Chart Area
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // Grid lines spanning horizontally
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: yLabels.map((_) => SizedBox(
                            height: 14, // Must identically match label height
                            child: Center(
                              child: Container(
                                height: 1, 
                                color: const Color(0xFFE2E8F0)
                              ),
                            ),
                          )).toList(),
                        ),
                        // The Bars
                        Positioned(
                          bottom: 7, // Align exactly on the '0' grid line (14/2)
                          top: 0, // Max height
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              for (var data in userData)
                                FractionallySizedBox(
                                  alignment: Alignment.bottomCenter,
                                  heightFactor: data.count / maxDataValue,
                                  child: Container(
                                    // Si 1 utilisateur => Barre très large (240), sinon barre normale (50)
                                    width: userData.length == 1 ? 240 : 50, 
                                    color: const Color(0xFF3B82F6),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // X-Axis labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var data in userData)
                        SizedBox(
                          width: userData.length == 1 ? 240 : 50,
                          child: Center(
                            child: Text(
                              data.name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10), // Padding below text
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalityCard() {
    return ModernCard(
      title: 'Localité',
      child: Column(
        children: [
          _buildHorizontalDataRow('Chambre d\'enfant', 11, 11, const Color(0xFFE83A82)),
          _buildHorizontalDataRow('Bureau', 9, 11, const Color(0xFFE83A82)),
          _buildHorizontalDataRow('Couloir', 3, 11, const Color(0xFFE83A82)),
          _buildHorizontalDataRow('Salle de bain', 3, 11, const Color(0xFFE83A82)),
          _buildHorizontalDataRow('Cuisine', 2, 11, const Color(0xFFE83A82)),
          _buildHorizontalDataRow('Buanderie', 2, 11, const Color(0xFFE83A82)),
          _buildHorizontalDataRow('Chambre des invités', 1, 11, const Color(0xFFE83A82)),
        ],
      ),
    );
  }

  Widget _buildTradeCard() {
    return ModernCard(
      title: 'Corps Métier',
      child: Column(
        children: [
          _buildHorizontalDataRow('Plomberie', 11, 11, const Color(0xFF00B894)),
          _buildHorizontalDataRow('Peinture', 6, 11, const Color(0xFF00B894)),
          _buildHorizontalDataRow('Plâtrerie', 5, 11, const Color(0xFF00B894)),
          _buildHorizontalDataRow('Maçonnerie', 4, 11, const Color(0xFF00B894)),
          _buildHorizontalDataRow('Electricité', 4, 11, const Color(0xFF00B894)),
          _buildHorizontalDataRow('Carrelage', 1, 11, const Color(0xFF00B894)),
        ],
      ),
    );
  }

  Widget _buildHorizontalDataRow(String label, int value, int max, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF334155),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 5,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEFF6FF),
                      ),
                    ),
                    Container(
                      height: 18,
                      width: constraints.maxWidth * (value / max),
                      decoration: BoxDecoration(
                        color: color,
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 30,
            child: Text(
              value.toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// REUSABLE WIDGETS & PAINTERS
// -------------------------------------------------------------

class ModernCard extends StatelessWidget {
  final String title;
  final Widget child;

  const ModernCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
             color: Colors.black.withOpacity(0.02),
             blurRadius: 16,
             offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class PieData {
  final String label;
  final double value;
  final Color color;

  PieData(this.label, this.value, this.color);
}

class UserObservationData {
  final String name;
  final int count;
  UserObservationData(this.name, this.count);
}

class PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  PieChartPainter(this.values, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    double total = values.fold(0, (sum, item) => sum + item);
    double startAngle = -pi / 2;
    
    // Create a bounding box for the pie chart
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * pi;
      
      // Draw slice
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
        
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      
      // Draw border
      final borderPaint = Paint()
         ..color = Colors.white
         ..style = PaintingStyle.stroke
         ..strokeWidth = 4.0;
         
      canvas.drawArc(rect, startAngle, sweepAngle, true, borderPaint);
      
      startAngle += sweepAngle;
    }
    
    // Optional: Add inner circle for a donut chart effect (Modern look)
    // Uncomment for a donut chart instead of a pie chart
    /*
    final innerHolePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(rect.center, size.width * 0.25, innerHolePaint);
    */
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04), 
              blurRadius: 4, 
              offset: const Offset(0, 1)
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: const Color(0xFF64748B)),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bluePale,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Text(
            'Dashboard Observation',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

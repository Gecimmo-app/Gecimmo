// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/app_drawer.dart';
import '../services/home_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isAujourdhuiSelected = true;
  bool _isActionsExpanded = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? _dateDebut;
  DateTime? _dateFin;

  HomeData? _homeData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final now = DateTime.now();
      final data = await HomeService.getHomeData(
        startDate: _dateDebut ?? now,
        endDate: _dateFin ?? now,
      );
      if (mounted) {
        setState(() {
          _homeData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        // Nettoyage du message d'erreur pour l'affichage
        String message = e.toString();
        if (message.startsWith('Exception: ')) {
          message = message.replaceFirst('Exception: ', '');
        }
        setState(() {
          _errorMessage = message;
          _isLoading = false;
          // Afficher des données vides plutôt que rien
          _homeData = HomeData.empty();
        });
      }
    }
  }

  Future<DateTime?> _pickDate(BuildContext ctx, DateTime? initial) async {
    return showDatePicker(
      context: ctx,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E7D32),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2E7D32),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  void _showPeriodeDialog() {
    DateTime? tempDebut = _dateDebut;
    DateTime? tempFin = _dateFin;

    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (builderContext, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sélectionner une période',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(dialogContext),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Date de début',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final picked =
                            await _pickDate(builderContext, tempDebut);
                        if (picked != null) {
                          setDialogState(() => tempDebut = picked);
                        }
                      },
                      child: _buildDateField(tempDebut),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Date de fin',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final picked = await _pickDate(builderContext, tempFin);
                        if (picked != null) {
                          setDialogState(() => tempFin = picked);
                        }
                      },
                      child: _buildDateField(tempFin),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (tempDebut != null &&
                              tempFin != null &&
                              tempFin!.isBefore(tempDebut!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'La date de fin doit être après la date de début.',
                                ),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            _dateDebut = tempDebut;
                            _dateFin = tempFin;
                          });
                          _loadHomeData();
                          Navigator.pop(dialogContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Appliquer',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Widget _buildDateField(DateTime? date) {
    final String text = date != null ? _formatDate(date) : 'dd/mm/yyyy';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: date != null ? Colors.black87 : Colors.black38,
            ),
          ),
          const Icon(
            Icons.calendar_today_outlined,
            size: 18,
            color: Colors.black38,
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    final DateTime now = DateTime.now();
    final List<String> days = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi',
      'Vendredi', 'Samedi', 'Dimanche',
    ];
    final List<String> months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
    ];
    return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87, size: 24),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Image.asset('assets/image/logo.png', height: 28),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.black87,
                  size: 24,
                ),
                onPressed: () {},
              ),
              const Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Color(0xFF10B981),
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.black87,
              size: 24,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Tableau de bord',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getFormattedDate(),
              style: const TextStyle(fontSize: 13, color: Colors.black45),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildToggleButton(
                  label: "Aujourd'hui",
                  icon: Icons.calendar_today,
                  isSelected: _isAujourdhuiSelected,
                  onTap: () {
                    if (!_isAujourdhuiSelected) {
                      setState(() {
                        _isAujourdhuiSelected = true;
                        _dateDebut = null;
                        _dateFin = null;
                      });
                      _loadHomeData();
                    }
                  },
                ),
                const SizedBox(width: 10),
                _buildToggleButton(
                  label: 'Période',
                  icon: Icons.date_range,
                  isSelected: !_isAujourdhuiSelected,
                  onTap: () {
                    setState(() => _isAujourdhuiSelected = false);
                    _showPeriodeDialog();
                  },
                ),
              ],
            ),
            if (!_isAujourdhuiSelected &&
                _dateDebut != null &&
                _dateFin != null) ...[
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFA5D6A7)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.date_range,
                        size: 15, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 6),
                    Text(
                      '${_formatDate(_dateDebut!)}  ->  ${_formatDate(_dateFin!)}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1B5E20),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),

            // ── Bandeau d'avertissement CORS (non bloquant) ──────────────────
            if (_errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFE082)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Color(0xFFF59E0B), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Erreur de chargement',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _loadHomeData,
                            child: const Text(
                              'Réessayer',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child:
                      CircularProgressIndicator(color: Color(0xFF2E7D32)),
                ),
              )
            else ...[
              _buildStatCard(
                title: 'RDV',
                subtitle: _isAujourdhuiSelected
                    ? "RDV aujourd'hui"
                    : "RDV sur la période",
                count: _homeData?.rdvAujourdhui ?? 0,
                countColor: const Color(0xFFF97316),
                bgColor: const Color(0xFFFFF7ED),
                iconWidget: const Icon(Icons.calendar_today,
                    color: Color(0xFFF97316), size: 24),
                borderColor: const Color(0xFFFED7AA),
                buttonColor: const Color(0xFFF97316),
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                title: 'À rappeler',
                subtitle: _isAujourdhuiSelected
                    ? "À rappeler aujourd'hui"
                    : "À rappeler sur la période",
                count: _homeData?.aRappeler ?? 0,
                countColor: const Color(0xFF16A34A),
                bgColor: const Color(0xFFF0FDF4),
                iconWidget: const Icon(Icons.phone,
                    color: Color(0xFF16A34A), size: 24),
                borderColor: const Color(0xFFBBF7D0),
                buttonColor: const Color(0xFF16A34A),
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                title: 'Nouveaux leads',
                subtitle: _isAujourdhuiSelected
                    ? "Nouveaux leads aujourd'hui"
                    : "Nouveaux leads sur la période",
                count: _homeData?.nouveauxLeads ?? 0,
                countColor: const Color(0xFF2563EB),
                bgColor: const Color(0xFFEFF6FF),
                iconWidget: const Icon(Icons.person,
                    color: Color(0xFF2563EB), size: 24),
                borderColor: const Color(0xFFBFDBFE),
                buttonColor: const Color(0xFF2563EB),
              ),
              const SizedBox(height: 20),
              _buildActionsDepassees(),
            ],
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2E7D32)
                : const Color(0xFFD1D5DB),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 16,
                color: isSelected ? Colors.white : const Color(0xFF6B7280)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:
                    isSelected ? Colors.white : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String subtitle,
    required int count,
    required Color countColor,
    required Color bgColor,
    required Widget iconWidget,
    required Color borderColor,
    required Color buttonColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: iconWidget,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: countColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                          fontSize: 11, color: Colors.black45),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: countColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: buttonColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Accéder',
                style: TextStyle(
                  color: buttonColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsDepassees() {
    return Column(
      children: [
        GestureDetector(
          onTap: () =>
              setState(() => _isActionsExpanded = !_isActionsExpanded),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.triangleExclamation,
                    color: Color(0xFFF59E0B), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Actions dépassées (${_homeData?.actionsDepassees.length ?? 0})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF92400E),
                  ),
                ),
                const Spacer(),
                Icon(
                  _isActionsExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFFF59E0B),
                ),
              ],
            ),
          ),
        ),
        if (_isActionsExpanded)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: (_homeData?.actionsDepassees.isEmpty ?? true)
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'Aucune action dépassée',
                        style: TextStyle(
                            fontSize: 13, color: Colors.black45),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _homeData!.actionsDepassees.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFE5E7EB)),
                    itemBuilder: (context, index) {
                      final item = _homeData!.actionsDepassees[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.circle,
                                color: Color(0xFFF59E0B), size: 8),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.black87),
                              ),
                            ),
                            Row(
                              children: [
                                const FaIcon(FontAwesomeIcons.clock,
                                    size: 13, color: Colors.black38),
                                const SizedBox(width: 4),
                                Text(
                                  item.date,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black38),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
      ],
    );
  }
}
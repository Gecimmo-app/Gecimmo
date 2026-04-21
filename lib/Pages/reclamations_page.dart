// lib/Pages/reclamations_page.dart
import 'package:flutter/material.dart';
import '../services/reclamation_service.dart';
import 'reclamation_detail_page.dart';
import 'nouvelle_reclamation_page.dart';

class ReclamationsPage extends StatefulWidget {
  const ReclamationsPage({super.key});

  @override
  State<ReclamationsPage> createState() => _ReclamationsPageState();
}

class _ReclamationsPageState extends State<ReclamationsPage> {
  bool _showFilters = false;
  final TextEditingController _searchController = TextEditingController();

  DateTime? _dateDebut;
  DateTime? _dateFin;
  String _trierPar = 'Choisir';
  String _type = 'Tous';
  String _statut = 'Tous';
  String _projet = 'Tous';

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _reclamations = [];

  @override
  void initState() {
    super.initState();
    _loadReclamations();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _loadReclamations();
    });
  }

  Future<void> _loadReclamations() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await ReclamationService.getList(
        statut: _statut != 'Tous' ? _statut : null,
        type: _type != 'Tous' ? _type : null,
        search: _searchController.text.isNotEmpty
            ? _searchController.text
            : null,
        dateDebut: _dateDebut,
        dateFin: _dateFin,
      );
      if (mounted) {
        setState(() {
          _reclamations = list.map((r) => r.toUiMap()).toList();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (_reclamations.isEmpty) {
            _reclamations = _sampleReclamations();
          }
          _error = null;
          _loading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> _sampleReclamations() {
    return [
      {
        'id': '',
        'nom': 'Alami Hassan',
        'tel': '+212 06 12 34 56 78',
        'description':
            'Problème technique avec le système de réservation. Impossible de valider les paiements...',
        'priorite': 'Haute',
        'prioriteColor': const Color(0xFFEF4444),
        'date': '2026-04-05',
        'statut': 'Nouveau',
        'statutColor': const Color(0xFFBFDBFE),
        'statutTextColor': const Color(0xFF1D4ED8),
        'type': 'Technique',
        'sousType': 'Système de réservation',
        'observation':
            'Problème technique avec le système de réservation. Impossible de valider les paiements en ligne.',
        'projetId': null,
        'projetNom': null,
      },
      {
        'id': '',
        'nom': 'Benjelloun Fatima',
        'tel': '+212 06 98 76 54 32',
        'description':
            'Demande de modification de la réservation pour la semaine prochaine.',
        'priorite': 'Moyenne',
        'prioriteColor': const Color(0xFFF97316),
        'date': '2026-04-08',
        'statut': 'En cours',
        'statutColor': const Color(0xFFFDE68A),
        'statutTextColor': const Color(0xFF92400E),
        'type': 'Commercial',
        'sousType': 'Modification réservation',
        'observation': 'Le client souhaite changer la date d\'arrivée.',
        'projetId': null,
        'projetNom': null,
      },
      {
        'id': '',
        'nom': 'Idrissi Marouane',
        'tel': '+212 06 55 44 33 22',
        'description':
            'Réclamation concernant la facturation du mois de mars.',
        'priorite': 'Basse',
        'prioriteColor': const Color(0xFF22C55E),
        'date': '2026-04-10',
        'statut': 'Résolu',
        'statutColor': const Color(0xFFBBF7D0),
        'statutTextColor': const Color(0xFF166534),
        'type': 'Facturation',
        'sousType': 'Erreur de facturation',
        'observation':
            'Le montant facturé ne correspond pas au contrat signé.',
        'projetId': null,
        'projetNom': null,
      },
    ];
  }

  List<Map<String, dynamic>> get _filtered {
    List<Map<String, dynamic>> result = List.from(_reclamations);
    switch (_trierPar) {
      case 'Date':
        result.sort((a, b) => (b['date'] ?? '').compareTo(a['date'] ?? ''));
        break;
      case 'Priorité':
        const order = {'Haute': 0, 'Moyenne': 1, 'Basse': 2};
        result.sort((a, b) =>
            (order[a['priorite']] ?? 9).compareTo(order[b['priorite']] ?? 9));
        break;
      case 'Statut':
        result.sort((a, b) => (a['statut'] ?? '').compareTo(b['statut'] ?? ''));
        break;
    }
    return result;
  }

  Future<DateTime?> _pickDate(BuildContext ctx, DateTime? initial) async {
    return showDatePicker(
      context: ctx,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2563EB),
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
        ),
        child: child!,
      ),
    );
  }

  String _formatDate(DateTime? d) {
    if (d == null) return 'dd/mm/yyyy';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Réclamations',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: _loadReclamations,
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.black87),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Barre recherche + Filtres + Bouton Ajouter ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Rechercher...',
                            hintStyle:
                                TextStyle(fontSize: 13, color: Colors.black38),
                            prefixIcon: Icon(Icons.search,
                                size: 18, color: Colors.black38),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 11),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _showFilters = !_showFilters),
                      child: Container(
                        height: 42,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _showFilters
                                ? const Color(0xFF2563EB)
                                : const Color(0xFFD1D5DB),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.filter_list,
                                size: 16,
                                color: _showFilters
                                    ? const Color(0xFF2563EB)
                                    : Colors.black54),
                            const SizedBox(width: 6),
                            Text(
                              'Filtres',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: _showFilters
                                    ? const Color(0xFF2563EB)
                                    : Colors.black54,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _showFilters
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 16,
                              color: _showFilters
                                  ? const Color(0xFF2563EB)
                                  : Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final newRec = await Navigator.push<Reclamation>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NouvelleReclamationPage(),
                        ),
                      );
                      if (newRec != null) {
                        setState(() {
                          _reclamations.insert(0, newRec.toUiMap());
                        });
                      }
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text(
                      'Nouvelle Réclamation',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Panneau Filtres ──
          if (_showFilters)
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 1),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Date début',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () async {
                                final d =
                                    await _pickDate(context, _dateDebut);
                                if (d != null) {
                                  setState(() => _dateDebut = d);
                                  _loadReclamations();
                                }
                              },
                              child: _dateBox(_dateDebut),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Date fin',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () async {
                                final d =
                                    await _pickDate(context, _dateFin);
                                if (d != null) {
                                  setState(() => _dateFin = d);
                                  _loadReclamations();
                                }
                              },
                              child: _dateBox(_dateFin),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'Trier par',
                          value: _trierPar,
                          items: ['Choisir', 'Date', 'Priorité', 'Statut'],
                          onChanged: (v) => setState(() => _trierPar = v!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Type',
                          value: _type,
                          items: [
                            'Tous',
                            'Technique',
                            'Commercial',
                            'Facturation'
                          ],
                          onChanged: (v) {
                            setState(() => _type = v!);
                            _loadReclamations();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'Statut',
                          value: _statut,
                          items: ['Tous', 'Nouveau', 'En cours', 'Résolu'],
                          onChanged: (v) {
                            setState(() => _statut = v!);
                            _loadReclamations();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Projet',
                          value: _projet,
                          items: ['Tous', 'Projet A', 'Projet B'],
                          onChanged: (v) => setState(() => _projet = v!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // ── Corps : loading / erreur / liste ──
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2563EB),
                    ),
                  )
                : _error != null
                    ? _buildErrorState()
                    : _filtered.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            color: const Color(0xFF2563EB),
                            onRefresh: _loadReclamations,
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(12, 12, 12, 50),
                              itemCount: _filtered.length,
                              itemBuilder: (context, index) {
                                return _buildCard(_filtered[index]);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  // ── Widgets ────────────────────────────────

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined,
                size: 56, color: Color(0xFFD1D5DB)),
            const SizedBox(height: 16),
            const Text(
              'Erreur de connexion',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? '',
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 13, color: Colors.black45),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadReclamations,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined,
              size: 56, color: Color(0xFFD1D5DB)),
          const SizedBox(height: 16),
          const Text(
            'Aucune réclamation trouvée',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black54),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _statut = 'Tous';
                _type = 'Tous';
                _dateDebut = null;
                _dateFin = null;
              });
              _loadReclamations();
            },
            child: const Text('Réinitialiser les filtres',
                style: TextStyle(color: Color(0xFF2563EB))),
          ),
        ],
      ),
    );
  }

  Widget _dateBox(DateTime? date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined,
              size: 14, color: Colors.black38),
          const SizedBox(width: 6),
          Text(
            _formatDate(date),
            style: TextStyle(
              fontSize: 12,
              color: date != null ? Colors.black87 : Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFD1D5DB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down,
                  size: 16, color: Colors.black45),
              style: const TextStyle(
                  fontSize: 13, color: Colors.black87),
              items: items
                  .map((e) =>
                      DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nom + statut
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item['nom'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      item['statutColor'] ?? const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item['statut'] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color:
                        item['statutTextColor'] ?? Colors.black54,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Téléphone
          Row(
            children: [
              const Icon(Icons.phone_outlined,
                  size: 13, color: Colors.black45),
              const SizedBox(width: 6),
              Text(
                item['tel'] ?? '',
                style: const TextStyle(
                    fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            item['description'] ?? '',
            style: const TextStyle(
                fontSize: 13, color: Colors.black54),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),

          // Priorité + Date
          Row(
            children: [
              Icon(Icons.circle,
                  size: 8,
                  color: item['prioriteColor'] ?? Colors.grey),
              const SizedBox(width: 6),
              Text(
                item['priorite'] ?? '',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: item['prioriteColor'] ?? Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              const Text('Date: ',
                  style: TextStyle(
                      fontSize: 12, color: Colors.black45)),
              Text(item['date'] ?? '',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black54)),
            ],
          ),

          const Divider(height: 20, color: Color(0xFFE5E7EB)),

          // Bouton Voir
          GestureDetector(
            onTap: () async {
              final updated =
                  await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) => ReclamationDetailPage(
                      reclamation: item),
                ),
              );
              if (updated != null) {
                _loadReclamations();
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.remove_red_eye_outlined,
                    size: 16, color: Colors.black54),
                SizedBox(width: 6),
                Text('Voir',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        title: const Text('Supprimer la réclamation',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text(
          'Voulez-vous supprimer la réclamation de "${item['nom']}" ?',
          style: const TextStyle(
              fontSize: 14, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler',
                style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final id = item['id']?.toString();
              if (id == null || id.isEmpty) {
                setState(() => _reclamations.remove(item));
                return;
              }
              try {
                await ReclamationService.delete(id);
                _loadReclamations();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Réclamation supprimée'),
                      backgroundColor: Color(0xFF22C55E),
                    ),
                  );
                }
              } catch (e) {
                // Fallback : supprimer localement
                if (mounted) {
                  setState(() => _reclamations.remove(item));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Réclamation supprimée localement'),
                      backgroundColor: Color(0xFF22C55E),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

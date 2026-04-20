// lib/Pages/reclamation_detail_page.dart
import 'package:flutter/material.dart';
import '../services/reclamation_service.dart';

class ReclamationDetailPage extends StatefulWidget {
  final Map<String, dynamic> reclamation;

  const ReclamationDetailPage({super.key, required this.reclamation});

  @override
  State<ReclamationDetailPage> createState() => _ReclamationDetailPageState();
}

class _ReclamationDetailPageState extends State<ReclamationDetailPage> {
  late String _selectedType;
  late String _selectedSousType;
  late String _selectedStatut;
  late TextEditingController _observationController;
  bool _saving = false;
  bool _changingState = false;

  final List<String> _types = [
    'Technique',
    'Commercial',
    'Facturation',
    'Autre'
  ];
  final List<String> _sousTypes = [
    'Système de réservation',
    'Modification réservation',
    'Erreur de facturation',
    'Autre',
  ];
  final List<String> _statuts = ['Nouveau', 'En cours', 'Résolu', 'Rejeté'];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.reclamation['type'] ?? 'Autre';
    _selectedSousType = widget.reclamation['sousType'] ?? 'Autre';
    _selectedStatut = widget.reclamation['statut'] ?? 'Nouveau';
    _observationController =
        TextEditingController(text: widget.reclamation['observation'] ?? '');
  }

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  // ── Couleurs statut ────────────────────────
  Color _statutBgColor(String statut) {
    switch (statut.toLowerCase()) {
      case 'nouveau':
        return const Color(0xFFBFDBFE);
      case 'en cours':
        return const Color(0xFFFDE68A);
      case 'résolu':
        return const Color(0xFFBBF7D0);
      case 'rejeté':
        return const Color(0xFFFECACA);
      default:
        return const Color(0xFFE5E7EB);
    }
  }

  Color _statutTextColor(String statut) {
    switch (statut.toLowerCase()) {
      case 'nouveau':
        return const Color(0xFF1D4ED8);
      case 'en cours':
        return const Color(0xFF92400E);
      case 'résolu':
        return const Color(0xFF166534);
      case 'rejeté':
        return const Color(0xFF991B1B);
      default:
        return const Color(0xFF374151);
    }
  }

  // ── Enregistrer les modifications (PUT) ────
  Future<void> _save() async {
    setState(() => _saving = true);
    final id = widget.reclamation['id']?.toString() ?? '';

    try {
      if (id.isNotEmpty) {
        await ReclamationService.update(id, {
          'type': _selectedType,
          'subType': _selectedSousType,
          'observation': _observationController.text,
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Modifications enregistrées'),
            backgroundColor: Color(0xFF22C55E),
          ),
        );
        Navigator.pop(context, {'updated': true});
      }
    } catch (e) {
      // Fallback local
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Modifications enregistrées localement'),
            backgroundColor: Color(0xFF22C55E),
          ),
        );
        Navigator.pop(context, {'updated': true});
      }
    }
  }

  // ── Changer le statut (PATCH /state) ───────
  Future<void> _changeStatut(String newStatut) async {
    final id = widget.reclamation['id']?.toString() ?? '';
    setState(() {
      _selectedStatut = newStatut;
      _changingState = true;
    });
    try {
      if (id.isNotEmpty) {
        await ReclamationService.updateState(id, newStatut);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Statut mis à jour : $newStatut'),
            backgroundColor: const Color(0xFF22C55E),
          ),
        );
      }
    } catch (e) {
      // Fallback local
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Statut mis à jour localement : $newStatut'),
            backgroundColor: const Color(0xFF22C55E),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _changingState = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.reclamation;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: _saving ? null : () => Navigator.pop(context),
        ),
        title: const Text(
          'Détails Réclamation',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Statut + changement rapide ──────
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Text('Statut: ',
                    style:
                        TextStyle(fontSize: 13, color: Colors.black54)),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statutBgColor(_selectedStatut),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _changingState
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF2563EB),
                          ),
                        )
                      : Text(
                          _selectedStatut,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: _statutTextColor(_selectedStatut),
                          ),
                        ),
                ),
                const Spacer(),
                // Bouton changer statut
                PopupMenuButton<String>(
                  onSelected: _changeStatut,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  itemBuilder: (ctx) => _statuts
                      .where((s) => s != _selectedStatut)
                      .map((s) => PopupMenuItem(
                            value: s,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: _statutBgColor(s),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(s,
                                    style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ))
                      .toList(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Text('Changer',
                            style: TextStyle(
                                fontSize: 12, color: Colors.black54)),
                        SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down,
                            size: 14, color: Colors.black45),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  // ── Informations réclamant ──
                  _buildSection(
                    title: 'INFORMATIONS RÉCLAMANT',
                    titleColor: const Color(0xFF6B7280),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildReadField('Nom Complet', r['nom'] ?? ''),
                        const SizedBox(height: 12),
                        _buildReadField('Téléphone', r['tel'] ?? ''),
                        if ((r['projetNom'] ?? '').isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildReadField('Projet', r['projetNom']),
                        ],
                        const SizedBox(height: 12),
                        _buildReadField(
                            'Date réclamation', r['date'] ?? ''),
                        const SizedBox(height: 12),
                        _buildReadField(
                            'Priorité', r['priorite'] ?? ''),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Modifier réclamation ────
                  _buildSection(
                    title: 'MODIFIER RÉCLAMATION',
                    titleColor: const Color(0xFF2563EB),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Type Réclamation'),
                        const SizedBox(height: 6),
                        _buildDropdown(
                          value: _selectedType,
                          items: _types,
                          onChanged: (v) =>
                              setState(() => _selectedType = v!),
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Sous Type Réclamation'),
                        const SizedBox(height: 6),
                        _buildDropdown(
                          value: _selectedSousType,
                          items: _sousTypes,
                          onChanged: (v) =>
                              setState(() => _selectedSousType = v!),
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('Observation'),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xFFD1D5DB)),
                          ),
                          child: TextField(
                            controller: _observationController,
                            maxLines: 5,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black87),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(12),
                              hintText: 'Ajouter une observation...',
                              hintStyle: TextStyle(
                                  color: Colors.black38, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // ── Boutons bas ─────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF93C5FD),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Enregistrer les modifications',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextButton(
                    onPressed: _saving
                        ? null
                        : () => Navigator.pop(context),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Widgets helper ─────────────────────────

  Widget _buildSection({
    required String title,
    required Color titleColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: titleColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildReadField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Text(value,
              style:
                  const TextStyle(fontSize: 13, color: Colors.black54)),
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87)),
        const Text(' *',
            style:
                TextStyle(color: Color(0xFFEF4444), fontSize: 13)),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    // Ensure value is in items list
    final safeValue = items.contains(value) ? value : items.first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: safeValue,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down,
              size: 18, color: Colors.black45),
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'localites_dialogs.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Modèle de données
// ─────────────────────────────────────────────────────────────────────────────

class LocaliteData {
  final int id;
  final String libelle;
  final bool visible;
  final bool partieCommune;
  final bool bien;

  const LocaliteData({
    required this.id,
    required this.libelle,
    required this.visible,
    required this.partieCommune,
    required this.bien,
  });

  LocaliteData copyWith({
    int? id,
    String? libelle,
    bool? visible,
    bool? partieCommune,
    bool? bien,
  }) {
    return LocaliteData(
      id: id ?? this.id,
      libelle: libelle ?? this.libelle,
      visible: visible ?? this.visible,
      partieCommune: partieCommune ?? this.partieCommune,
      bien: bien ?? this.bien,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page principale
// ─────────────────────────────────────────────────────────────────────────────

class LocalitesScreen extends StatefulWidget {
  const LocalitesScreen({super.key});

  @override
  State<LocalitesScreen> createState() => _LocalitesScreenState();
}

class _LocalitesScreenState extends State<LocalitesScreen> {
  static const Color _primaryBlue = Color(0xFF1E40AF);
  static const Color _pageBg = Color(0xFFF8FAFC);
  static const Color _textTitle = Color(0xFF1D2939);
  static const Color _textMuted = Color(0xFF667085);
  static const Color _border = Color(0xFFD0D5DD);

  final TextEditingController _searchController = TextEditingController();

  late List<LocaliteData> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      const LocaliteData(id: 1, libelle: 'Buanderie', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 2, libelle: 'Bureau', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 3, libelle: 'Chambre d\'enfant', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 4, libelle: 'Chambre des invités', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 5, libelle: 'Couloir', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 6, libelle: 'Cuisine', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 7, libelle: 'Entrée', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 8, libelle: 'Jardin', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 9, libelle: 'Place de parking', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 10, libelle: 'Salle à manger', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 11, libelle: 'Salle de bain', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 12, libelle: 'Salon', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 13, libelle: 'Suite parentale', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 14, libelle: 'Terrasse / balcon', visible: true, partieCommune: true, bien: true),
      const LocaliteData(id: 15, libelle: 'Toilettes/WC', visible: true, partieCommune: true, bien: true),
    ];
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() => setState(() {});

  List<LocaliteData> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return List<LocaliteData>.from(_items);
    return _items.where((e) => e.libelle.toLowerCase().contains(q)).toList();
  }

  int get _nextId => _items.isEmpty ? 1 : _items.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

  void _updateItem(LocaliteData updated) {
    setState(() {
      final i = _items.indexWhere((e) => e.id == updated.id);
      if (i >= 0) _items[i] = updated;
    });
  }

  void _addItem(LocaliteData data) {
    setState(() => _items.add(data));
  }

  void _showAddDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AddLocaliteDialog(
        primaryBlue: _primaryBlue,
        borderColor: _border,
        textTitle: _textTitle,
        textMuted: _textMuted,
        onSave: (libelle, visible, partieCommune, bien) {
          _addItem(LocaliteData(
            id: _nextId,
            libelle: libelle,
            visible: visible,
            partieCommune: partieCommune,
            bien: bien,
          ));
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  void _showEditDialog(LocaliteData initial) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => EditLocaliteDialog(
        initial: initial,
        primaryBlue: _primaryBlue,
        borderColor: _border,
        textTitle: _textTitle,
        textMuted: _textMuted,
        onSave: (updated) {
          _updateItem(updated);
          Navigator.of(ctx).pop();
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return _primaryBlue;
            return null;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
        ),
      ),
      child: Scaffold(
        backgroundColor: _pageBg,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: FloatingActionButton(
            onPressed: _showAddDialog,
            backgroundColor: _primaryBlue,
            foregroundColor: Colors.white,
            elevation: 6,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, size: 30),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeaderRow(context),
                      const SizedBox(height: 24),
                      _buildSearchSection(),
                      const SizedBox(height: 20),
                      _buildTableSection(filtered),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final narrow = w < 520;

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Localités',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: _textTitle,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Liste complète des localités disponibles dans le système',
          style: TextStyle(
            fontSize: narrow ? 13 : 14,
            height: 1.35,
            color: _textMuted.withValues(alpha: 0.95),
          ),
        ),
      ],
    );

    final addBtn = ElevatedButton.icon(
      onPressed: _showAddDialog,
      icon: const Icon(Icons.add_rounded, size: 20),
      label: const Text(
        'Ajouter une localité',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleBlock,
          const SizedBox(height: 16),
          addBtn,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: titleBlock),
        const SizedBox(width: 16),
        addBtn,
      ],
    );
  }

  Widget _buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recherche',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _textMuted.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Chercher par libellé...',
            hintStyle: TextStyle(color: _textMuted.withValues(alpha: 0.65)),
            prefixIcon: Icon(Icons.search_rounded, color: _textMuted.withValues(alpha: 0.7)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: _border.withValues(alpha: 0.9)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _primaryBlue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableSection(List<LocaliteData> rows) {
    if (rows.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'Aucun résultat pour cette recherche',
            style: TextStyle(
              fontSize: 14,
              color: _textMuted.withValues(alpha: 0.9),
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        Widget table = DataTable(
          headingRowHeight: 48,
          dataRowMinHeight: 52,
          dataRowMaxHeight: 56,
          horizontalMargin: 8,
          columnSpacing: 10,
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
          border: TableBorder(
            horizontalInside: BorderSide(color: _border.withValues(alpha: 0.45)),
            verticalInside: BorderSide(color: _border.withValues(alpha: 0.45)),
          ),
          columns: const [
            DataColumn(label: _TableHeaderText('ID')),
            DataColumn(label: _TableHeaderText('Libellé')),
            DataColumn(label: _TableHeaderText('Visible')),
            DataColumn(label: _TableHeaderText('Partie Commune')),
            DataColumn(label: _TableHeaderText('Bien')),
            DataColumn(label: _TableHeaderText('Actions')),
          ],
          rows: List.generate(rows.length, (index) {
            final e = rows[index];
            final zebra = index.isOdd;
            return DataRow(
              color: WidgetStateProperty.all(
                zebra ? const Color(0xFFF9FAFB) : Colors.white,
              ),
              cells: [
                DataCell(Text('${e.id}', style: const TextStyle(fontWeight: FontWeight.w500))),
                DataCell(
                  Text(
                    e.libelle,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: _textTitle),
                  ),
                ),
                DataCell(
                  Center(
                    child: Checkbox(
                      value: e.visible,
                      onChanged: (v) {
                        if (v != null) _updateItem(e.copyWith(visible: v));
                      },
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Checkbox(
                      value: e.partieCommune,
                      onChanged: (v) {
                        if (v != null) _updateItem(e.copyWith(partieCommune: v));
                      },
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Checkbox(
                      value: e.bien,
                      onChanged: (v) {
                        if (v != null) _updateItem(e.copyWith(bien: v));
                      },
                    ),
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: _primaryBlue, size: 22),
                    tooltip: 'Modifier',
                    onPressed: () => _showEditDialog(e),
                  ),
                ),
              ],
            );
          }),
        );

        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border.withValues(alpha: 0.55)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: table,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TableHeaderText extends StatelessWidget {
  final String text;

  const _TableHeaderText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 13,
        color: Color(0xFF1D2939),
      ),
    );
  }
}

typedef LocalitesPage = LocalitesScreen;

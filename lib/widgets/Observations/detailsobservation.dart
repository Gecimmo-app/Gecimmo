import 'package:flutter/material.dart';

class DetailsObservationPage extends StatelessWidget {
  final String bienName;
  final String status;
  final String dateObservation;
  final String prevision;
  final String realisation;
  final String localite;
  final String type;
  final String createdBy;
  final String focusSection;

  const DetailsObservationPage({
    super.key,
    required this.bienName,
    required this.status,
    required this.dateObservation,
    required this.prevision,
    required this.realisation,
    required this.localite,
    required this.type,
    required this.createdBy,
    this.focusSection = 'Observation',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      appBar: AppBar(
        title: const Text(
          'Details de l\'observation',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;

            final detailsPanel = _DetailsPanel(
              bienName: bienName,
              status: status,
              dateObservation: dateObservation,
              prevision: prevision,
              realisation: realisation,
              localite: localite,
              type: type,
              createdBy: createdBy,
              focusSection: focusSection,
            );

            final imagePanel = const _PlanPanel();

            if (isWide) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 11,
                      child: SingleChildScrollView(
                        child: detailsPanel,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(flex: 10, child: imagePanel),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                detailsPanel,
                const SizedBox(height: 16),
                imagePanel,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DetailsPanel extends StatelessWidget {
  final String bienName;
  final String status;
  final String dateObservation;
  final String prevision;
  final String realisation;
  final String localite;
  final String type;
  final String createdBy;
  final String focusSection;

  const _DetailsPanel({
    required this.bienName,
    required this.status,
    required this.dateObservation,
    required this.prevision,
    required this.realisation,
    required this.localite,
    required this.type,
    required this.createdBy,
    required this.focusSection,
  });

  @override
  Widget build(BuildContext context) {
    final contentChildren = <Widget>[
      _SectionBlock(
        title: 'Observations Info',
        buttonLabel: 'Voir les images (1)',
        rows: [
          _InfoRowData('Date de création', dateObservation),
          _InfoRowData('Statut', status),
          _InfoRowData('Prestataire', 'Prestataire Demo'),
          _InfoRowData('Corps métier', type),
        ],
        highlighted: focusSection == 'Observation',
      ),
      _SectionBlock(
        title: 'Réalisation infos',
        buttonLabel: 'Voir l\'image de réalisation',
        rows: [
          _InfoRowData('Date de réalisation', realisation),
          _InfoRowData('Réalisé par', createdBy),
          _InfoRowData('Observation de réalisation', 'terminé'),
        ],
        highlighted: focusSection == 'Réalisation',
      ),
      _SectionBlock(
        title: 'Refus infos',
        buttonLabel: 'Voir l\'image du refus',
        rows: [
          _InfoRowData('Date de refus', prevision),
          _InfoRowData('Refusé par', createdBy),
          _InfoRowData('Observation de refus', 'Aucune'),
        ],
        highlighted: focusSection == 'Refus',
      ),
      const Padding(
        padding: EdgeInsets.fromLTRB(18, 14, 18, 8),
        child: Text(
          'Historique',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      const Divider(height: 1),
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFD6DCE8)),
                ),
                child: const Icon(Icons.check, size: 18, color: Color(0xFF1E40AF)),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acceptation de l\'observation : bien',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'admin user',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              const Text(
                'Tuesday, Apr 16 2026',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
        child: Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Laisser un commentaire',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF1E40AF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.chevron_right, color: Colors.white),
            ),
          ],
        ),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _PanelTitleBar(title: 'Details de l\'observation'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: contentChildren,
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelTitleBar extends StatelessWidget {
  final String title;

  const _PanelTitleBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final String title;
  final String buttonLabel;
  final List<_InfoRowData> rows;
  final bool highlighted;

  const _SectionBlock({
    required this.title,
    required this.buttonLabel,
    required this.rows,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFF8FBFF) : Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(buttonLabel, style: const TextStyle(fontSize: 11)),
                ),
              ],
            ),
          ),
          ...rows.map((row) => _InfoRow(label: row.label, value: row.value)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _InfoRowData {
  final String label;
  final String value;

  const _InfoRowData(this.label, this.value);
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanPanel extends StatelessWidget {
  const _PlanPanel();
  static const String _planAssetPath = 'assets/plan.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _PanelTitleBar(title: 'Plan / visuel'),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    _planAssetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.broken_image_outlined, size: 56, color: Color(0xFF94A3B8)),
                            SizedBox(height: 12),
                            Text(
                              'Impossible de charger le plan',
                              style: TextStyle(
                                color: Color(0xFF475569),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

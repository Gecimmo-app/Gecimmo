import 'package:flutter/material.dart';

class ObservationsPage extends StatefulWidget {
  const ObservationsPage({super.key});

  @override
  State<ObservationsPage> createState() => _ObservationsPageState();
}

class _ObservationsPageState extends State<ObservationsPage> {
  /// `true` = cartes (grille), `false` = tableau liste (colonnes Numéro, Date, Observation).
  bool isGridView = true;

  /// Valeur affichée dans le pied de page (5, 10 ou 20) — aligné sur la maquette « Rows per page ».
  int rowsPerPage = 5;

  final List<ObservationData> observations = [
    ObservationData(
      id: "#50",
      numero: "50",
      date: "07/04/2026 11:38",
      status: "Accepté",
      statusColor: Colors.green,
      title: "obser 1",
      observation: "obser 1",
      type: "Plomberie",
      localite: "Bureau",
      datePrevisionnelle: "09/04/2026 12:00",
      dateRealisation: "07/04/2026 11:43",
      corpsMetier: "Plomberie",
      emplacement: "Buanderie",
      prestataire: "Prestataire 1",
    ),
    ObservationData(
      id: "#51",
      numero: "51",
      date: "08/04/2026 09:15",
      status: "En cours",
      statusColor: Colors.orange,
      title: "obser 2",
      observation: "obser 2",
      type: "Électricité",
      localite: "Cuisine",
      datePrevisionnelle: "10/04/2026 14:00",
      dateRealisation: "",
      corpsMetier: "Électricité",
      emplacement: "Cuisine",
      prestataire: "Prestataire 2",
    ),
    ObservationData(
      id: "#52",
      numero: "52",
      date: "08/04/2026 14:30",
      status: "En attente",
      statusColor: Colors.red,
      title: "obser 3",
      observation: "obser 3",
      type: "Peinture",
      localite: "Salon",
      datePrevisionnelle: "11/04/2026 10:00",
      dateRealisation: "",
      corpsMetier: "Peinture",
      emplacement: "Salon",
      prestataire: "Prestataire 3",
    ),
  ];

  void _showActionMenu(BuildContext context, ObservationData obs) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Observation ${obs.id}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(obs.date, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: obs.statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text(obs.status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: obs.statusColor)),
                ),
                const Divider(height: 20),
                _buildActionTile(Icons.calendar_today_outlined, "Date prévue", () => Navigator.pop(context)),
                _buildActionTile(Icons.map_outlined, "Afficher sur plan", () => Navigator.pop(context)),
                _buildActionTile(Icons.build_outlined, obs.corpsMetier, () => Navigator.pop(context)),
                _buildActionTile(Icons.history_outlined, "Historique de l'observation", () => Navigator.pop(context)),
                _buildActionTile(Icons.business_outlined, obs.prestataire, () => Navigator.pop(context)),
                _buildActionTile(Icons.image_outlined, "Image de l'observation", () => Navigator.pop(context)),
                if (obs.dateRealisation.isNotEmpty)
                  _buildActionTile(Icons.check_circle_outline, "Réalisé", () => Navigator.pop(context)),
                _buildActionTile(Icons.image_outlined, "Image de la réalisation", () => Navigator.pop(context)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 24, color: const Color(0xFF1E40AF)),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header (Liste/Grille)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Liste", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() => isGridView = false),
                    icon: Icon(Icons.list, size: 22, color: !isGridView ? const Color(0xFF1E40AF) : Colors.grey),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => setState(() => isGridView = true),
                    icon: Icon(Icons.grid_view, size: 22, color: isGridView ? const Color(0xFF1E40AF) : Colors.grey),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        ..._buildObservationsListSection(),
      ],
    );
  }

  /// Corps de l’onglet : vide, tableau (liste) ou grille — scroll vertical + horizontal pour le tableau.
  List<Widget> _buildObservationsListSection() {
    if (observations.isEmpty) {
      return [
        const Expanded(
          child: Center(
            child: Text("Aucune observation trouvée", style: TextStyle(color: Color(0xFF64748B))),
          ),
        ),
      ];
    }

    if (!isGridView) {
      return [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          _buildHeaderCell("Numéro", 80),
                          _buildHeaderCell("Date", 150),
                          _buildHeaderCell("Observation", 220),
                          const SizedBox(width: 50),
                        ],
                      ),
                    ),
                    ...observations.map(_buildTableRow),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
        _buildObservationsPaginationBar(),
      ];
    }

    return [
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth < 650 ? 1 : (constraints.maxWidth < 1100 ? 2 : 3);
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 510,
              ),
              itemCount: observations.length,
              itemBuilder: (context, index) => _buildGridCard(observations[index]),
            );
          },
        ),
      ),
    ];
  }

  /// Pied de page : « Rows per page », liste déroulante 5 / 10 / 20, plage « 1 - n of n ».
  Widget _buildObservationsPaginationBar() {
    final total = observations.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                "Rows per page",
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: rowsPerPage,
                    isDense: true,
                    icon: const Icon(Icons.arrow_drop_down, size: 18, color: Colors.black87),
                    dropdownColor: Colors.white,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                    items: const [
                      DropdownMenuItem(value: 5, child: Text("5")),
                      DropdownMenuItem(value: 10, child: Text("10")),
                      DropdownMenuItem(value: 20, child: Text("20")),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => rowsPerPage = v);
                    },
                  ),
                ),
              ),
            ],
          ),
          Text(
            "1 - $total of $total",
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildTableRow(ObservationData obs) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCell(obs.numero, 80),
          _buildCell(obs.date, 150),
          _buildCell(obs.observation, 220),
          SizedBox(
            width: 50,
            child: IconButton(
              onPressed: () => _showActionMenu(context, obs),
              icon: const Icon(Icons.more_vert, size: 20, color: Colors.grey),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      ),
    );
  }

  Widget _buildGridCard(ObservationData obs) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Observation ${obs.id}",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              obs.date,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: obs.statusColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          obs.status,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Observation Name
                  Text(
                    obs.observation,
                    style: const TextStyle(fontSize: 15, color: Color(0xFF334155), fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Expected Date container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFDBEAFE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF3B82F6)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Date prévisionnelle de réalisation",
                                style: TextStyle(fontSize: 12, color: Color(0xFF2563EB), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                obs.datePrevisionnelle,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Details Row
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.build_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                obs.corpsMetier,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.my_location_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                obs.emplacement,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Prestataire Row
                  Row(
                    children: [
                       const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                       const SizedBox(width: 6),
                       Expanded(
                         child: Text(
                           obs.prestataire,
                           style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                         ),
                       ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Status Realisé Container
                  if (obs.dateRealisation.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Center(
                        child: Text(
                          "Réalisé le : ${obs.dateRealisation}",
                          style: const TextStyle(fontSize: 13, color: Color(0xFF166534), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Action Menu
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => _showActionMenu(context, obs),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[200]!),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Image footprint at the bottom
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Image.network(
              "https://images.unsplash.com/photo-1496115965489-21be7e6e59a0?auto=format&fit=crop&q=80&w=600&h=200",
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 140,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ObservationData {
  final String id;
  final String numero;
  final String date;
  final String status;
  final Color statusColor;
  final String title;
  final String observation;
  final String type;
  final String localite;
  final String datePrevisionnelle;
  final String dateRealisation;
  final String corpsMetier;
  final String emplacement;
  final String prestataire;

  ObservationData({
    required this.id,
    required this.numero,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.title,
    required this.observation,
    required this.type,
    required this.localite,
    required this.datePrevisionnelle,
    required this.dateRealisation,
    required this.corpsMetier,
    required this.emplacement,
    required this.prestataire,
  });
}

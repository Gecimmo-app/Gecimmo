import 'package:flutter/material.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  bool isGridView = false;
  String rowsPerPage = "5";
  
  final List<TicketData> tickets = [
    TicketData(
      id: "#1", bien: "Bien4", info: "GH1.1 - I1 - 1er",
      natureVisite: "Réclamation", natureStructure: "Appartement",
      date: "07/04/2026", heure: "11:38", groupement: "GH1.1",
      type: "Plomberie", emplacement: "Buanderie", prestataire: "Prestataire 1",
      status: "En cours", statusColor: Colors.orange,
    ),
    TicketData(
      id: "#2", bien: "Bien5", info: "GH1.1 - I2 - 2er",
      natureVisite: "Livraison", natureStructure: "Maison",
      date: "08/04/2026", heure: "14:30", groupement: "GH1.1",
      type: "Électricité", emplacement: "Cuisine", prestataire: "Prestataire 2",
      status: "Traité", statusColor: Colors.green,
    ),
    TicketData(
      id: "#3", bien: "Bien6", info: "GH2.1 - I1 - 1er",
      natureVisite: "Réclamation", natureStructure: "Villa",
      date: "09/04/2026", heure: "09:00", groupement: "GH2.1",
      type: "Peinture", emplacement: "Salon", prestataire: "Prestataire 3",
      status: "Planifié", statusColor: Colors.blue,
    ),
  ];

  void _showActionMenu(BuildContext context, TicketData ticket) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionTile(Icons.visibility_outlined, "Voir les observations", () => Navigator.pop(context)),
              const Divider(height: 8),
              _buildActionTile(Icons.add_circle_outline, "Créer une observation", () => Navigator.pop(context)),
              const Divider(height: 8),
              _buildActionTile(Icons.schedule_outlined, "Planifier la réalisation", () => Navigator.pop(context)),
              const Divider(height: 8),
              _buildActionTile(Icons.download_outlined, "Télécharger le rapport", () => Navigator.pop(context)),
              const Divider(height: 8),
              _buildActionTile(Icons.edit_note_outlined, "Signer le PV", () => Navigator.pop(context)),
              const Divider(height: 8),
              _buildActionTile(Icons.email_outlined, "Envoyer PV par email", () => Navigator.pop(context)),
            ],
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
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
          ),
          const SizedBox(height: 8),
          // ============ TABLE AVEC HORIZONTAL SCROLL ============
          if (!isGridView && tickets.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _buildHeaderCell("Bien", 100),
                        _buildHeaderCell("Nature Visite", 120),
                        _buildHeaderCell("Nature Structure", 130),
                        _buildHeaderCell("Date", 90),
                        _buildHeaderCell("Heure", 70),
                        _buildHeaderCell("Groupement", 100),
                        _buildHeaderCell("Type", 100),
                        _buildHeaderCell("Emplacements", 110),
                        _buildHeaderCell("Prestataires", 110),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  // Rows
                  ...tickets.map((t) => _buildTableRow(t)),
                ],
              ),
            ),
          
          // Grid View
          if (isGridView && tickets.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: tickets.length,
              itemBuilder: (context, index) => _buildGridCard(tickets[index]),
            ),
          
          // Empty state
          if (tickets.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text("Aucun ticket trouvé", style: TextStyle(color: Color(0xFF64748B))),
              ),
            ),
          
          // ============ PAGINATION (vue liste / tableau uniquement) ============
          if (tickets.isNotEmpty && !isGridView)
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 24),
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
                      const Text("Rows per page", style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showRowsPerPageDialog(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Text(rowsPerPage, style: const TextStyle(fontSize: 13)),
                              const Icon(Icons.arrow_drop_down, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "1 - ${tickets.length} of ${tickets.length}",
                    style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildTableRow(TicketData t) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          _buildCell(t.bien, 100),
          _buildCell(t.natureVisite, 120, isChip: true),
          _buildCell(t.natureStructure, 130, isChip: true),
          _buildCell(t.date, 90),
          _buildCell(t.heure, 70),
          _buildCell(t.groupement, 100, isChip: true),
          _buildCell(t.type, 100, isChip: true),
          _buildCell(t.emplacement, 110, isChip: true),
          _buildCell(t.prestataire, 110, isChip: true),
          SizedBox(
            width: 40,
            child: IconButton(
              onPressed: () => _showActionMenu(context, t),
              icon: const Icon(Icons.more_horiz, size: 20, color: Colors.grey),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text, double width, {bool isChip = false}) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: isChip
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              )
            : Text(
                text,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
      ),
    );
  }

  Widget _buildGridCard(TicketData t) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t.id, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E40AF))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: t.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(t.status, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: t.statusColor)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(t.bien, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(t.info, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
              const Divider(height: 12),
              Row(children: [
                const Icon(Icons.calendar_today, size: 10, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(child: Text("${t.date} ${t.heure}", style: const TextStyle(fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on, size: 10, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(child: Text(t.emplacement, style: const TextStyle(fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.business, size: 10, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(child: Text(t.prestataire, style: const TextStyle(fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              onPressed: () => _showActionMenu(context, t),
              icon: const Icon(Icons.more_horiz, size: 18, color: Colors.grey),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }

  void _showRowsPerPageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Rows per page"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ["5", "10", "25", "50"].map((v) {
              return ListTile(
                title: Text(v),
                trailing: rowsPerPage == v ? const Icon(Icons.check, color: Color(0xFF1E40AF)) : null,
                onTap: () {
                  setState(() => rowsPerPage = v);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class TicketData {
  final String id, bien, info, natureVisite, natureStructure, date, heure, groupement, type, emplacement, prestataire, status;
  final Color statusColor;
  TicketData({
    required this.id,
    required this.bien,
    required this.info,
    required this.natureVisite,
    required this.natureStructure,
    required this.date,
    required this.heure,
    required this.groupement,
    required this.type,
    required this.emplacement,
    required this.prestataire,
    required this.status,
    required this.statusColor,
  });
}
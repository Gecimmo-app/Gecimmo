import 'package:flutter/material.dart';

class DroitFormulaire {
  final String formulaire;
  final String description;
  bool consulter;
  bool ajouter;
  bool modifier;
  bool supprimer;

  DroitFormulaire(this.formulaire, this.description, {
    this.consulter = false,
    this.ajouter = false,
    this.modifier = false,
    this.supprimer = false,
  });
}

class DroitSpecial {
  final String droit;
  final String formulaire;
  final String description;
  bool active;

  DroitSpecial(this.droit, this.formulaire, this.description, {this.active = false});
}

class AjouterUtilisateurScreen extends StatefulWidget {
  const AjouterUtilisateurScreen({super.key});

  @override
  State<AjouterUtilisateurScreen> createState() => _AjouterUtilisateurScreenState();
}

class _AjouterUtilisateurScreenState extends State<AjouterUtilisateurScreen> {
  static const Color _primaryBlue = Color(0xFF3B82F6);
  static const Color _pageBg = Color(0xFFF8FAFC);
  static const Color _textTitle = Color(0xFF1D2939);
  static const Color _textMuted = Color(0xFF667085);
  static const Color _border = Color(0xFFEAECF0);

  final _nomCtrl = TextEditingController();
  final _loginCtrl = TextEditingController();
  String? _selectedRole;

  final List<String> _roles = ['Admin', 'Commercial', 'ADV', 'Comptable', 'Recouvrement', 'SI', 'Marketing', 'Responsable commercial'];

  final List<DroitFormulaire> _droitsFormulaire = [
    DroitFormulaire('Visites', 'Visites SAV'),
    DroitFormulaire('Tickets', 'Tickets SAV'),
    DroitFormulaire('Reclamations SAV', 'Gérer les réclamations SAV'),
    DroitFormulaire('Prestataires', 'Gestion des prestataires'),
    DroitFormulaire('ParametrageSAV', 'Parametrages des listes SAV'),
    DroitFormulaire('Utilisateur SAV', 'Gestion des utilisateurs'),
  ];

  final List<DroitSpecial> _droitsSpeciaux = [
    DroitSpecial('RealiserObservation', 'Tickets', 'Realiser une observation'),
    DroitSpecial('AccepteObservation', 'Tickets', 'Accepter une observation'),
    DroitSpecial('RefusObservation', 'Tickets', 'Refuser une observation'),
    DroitSpecial('PlanificationTravaux', 'Tickets', 'Planification Travaux'),
    DroitSpecial('PlanificationTravauxObservation', 'Tickets', 'Planification travaux de l\'observation'),
    DroitSpecial('CommercialConsulteDetail', 'Reclamations SAV', 'Les commerciaux peuvent accéder uniquement à la reclamation'),
  ];

  @override
  void dispose() {
    _nomCtrl.dispose();
    _loginCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return _primaryBlue;
            return null;
          }),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      child: Scaffold(
        backgroundColor: _pageBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: _textTitle),
          title: const Text(
            'Ajouter un utilisateur',
            style: TextStyle(
              color: _textTitle,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: _border),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInformationsGenerales(),
                Container(height: 1, color: _border),
                _buildDroitsFormulaires(context),
                Container(height: 1, color: _border),
                _buildDroitsSpeciaux(context),
                Container(height: 1, color: _border),
                _buildBottomActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, [String? trailing]) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textTitle),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(fontSize: 13, color: _textMuted.withValues(alpha: 0.9)),
            ),
        ],
      ),
    );
  }

  Widget _buildInformationsGenerales() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Informations générales'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 24),
          child: Column(
            children: [
              _buildField('Nom Complet *', TextField(
                controller: _nomCtrl,
                decoration: _inputDeco(''),
              )),
              const SizedBox(height: 20),
              _buildField('Login *', TextField(
                controller: _loginCtrl,
                decoration: _inputDeco(''),
              )),
              const SizedBox(height: 20),
              _buildField('Rôle *', DropdownButtonFormField<String>(
                value: _selectedRole,
                hint: const Text('Sélectionner un rôle'),
                decoration: _inputDeco(''),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setState(() => _selectedRole = v),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(String label, Widget child) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: _textTitle.withValues(alpha: 0.85)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: child),
      ],
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: _textMuted.withValues(alpha: 0.6)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _primaryBlue, width: 1.5),
      ),
    );
  }

  Widget _buildDroitsFormulaires(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Droits formulaires', '${_droitsFormulaire.length} formulaire(s) disponible(s)'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width - 48), // Total width minus external paddings
            child: DataTable(
              headingRowHeight: 48,
              dataRowMinHeight: 52,
              dataRowMaxHeight: 56,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
              columnSpacing: 30,
              dividerThickness: 1,
              columns: const [
                DataColumn(label: _ColHeader('FORMULAIRE')),
                DataColumn(label: _ColHeader('DESCRIPTION')),
                DataColumn(label: _ColHeader('CONSULTER')),
                DataColumn(label: _ColHeader('AJOUTER')),
                DataColumn(label: _ColHeader('MODIFIER')),
                DataColumn(label: _ColHeader('SUPPRIMER')),
              ],
              rows: _droitsFormulaire.map((d) {
                return DataRow(
                  cells: [
                    DataCell(Text(d.formulaire, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                    DataCell(Text(d.description, style: TextStyle(fontSize: 13, color: _textMuted.withValues(alpha: 0.9)))),
                    DataCell(Center(child: Checkbox(value: d.consulter, onChanged: (v) => setState(() => d.consulter = v!)))),
                    DataCell(Center(child: Checkbox(value: d.ajouter, onChanged: (v) => setState(() => d.ajouter = v!)))),
                    DataCell(Center(child: Checkbox(value: d.modifier, onChanged: (v) => setState(() => d.modifier = v!)))),
                    DataCell(Center(child: Checkbox(value: d.supprimer, onChanged: (v) => setState(() => d.supprimer = v!)))),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDroitsSpeciaux(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Droits spéciaux', '${_droitsSpeciaux.length} droit(s) spécial(aux) disponible(s)'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: MediaQuery.sizeOf(context).width - 48),
            child: DataTable(
              headingRowHeight: 48,
              dataRowMinHeight: 52,
              dataRowMaxHeight: 56,
              headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
              columnSpacing: 40,
              dividerThickness: 1,
              columns: const [
                DataColumn(label: _ColHeader('DROIT')),
                DataColumn(label: _ColHeader('FORMULAIRE')),
                DataColumn(label: _ColHeader('DESCRIPTION')),
                DataColumn(label: _ColHeader('ACTIVÉ')),
              ],
              rows: _droitsSpeciaux.map((d) {
                return DataRow(
                  cells: [
                    DataCell(Text(d.droit, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                    DataCell(Text(d.formulaire, style: TextStyle(fontSize: 13, color: _textMuted.withValues(alpha: 0.9)))),
                    DataCell(Text(d.description, style: TextStyle(fontSize: 13, color: _textMuted.withValues(alpha: 0.9)))),
                    DataCell(Center(child: Checkbox(value: d.active, onChanged: (v) => setState(() => d.active = v!)))),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: _textTitle,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              side: const BorderSide(color: _border),
            ),
            child: const Text('Annuler', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              // Action Save
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Enregistrer', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _ColHeader extends StatelessWidget {
  final String text;
  const _ColHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF667085).withValues(alpha: 0.8),
        letterSpacing: 0.5,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'utilisateurs_page.dart'; // Pour UtilisateurData

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

class DetailUtilisateurScreen extends StatefulWidget {
  final UtilisateurData utilisateur;

  const DetailUtilisateurScreen({super.key, required this.utilisateur});

  @override
  State<DetailUtilisateurScreen> createState() => _DetailUtilisateurScreenState();
}

class _DetailUtilisateurScreenState extends State<DetailUtilisateurScreen> {
  final List<String> _allProjects = [
    'Projet1', 'Projet2', 'Projet3', 'Projet4', 'Projet5', 'Projet6', 'Projet7',
  ];
  List<String> _selectedProjects = [];

  final List<DroitFormulaire> _droitsFormulaire = [
    // Anciennes lignes
    DroitFormulaire('Visites', 'Visites SAV', consulter: true, ajouter: true, modifier: true),
    DroitFormulaire('Tickets', 'Tickets SAV', consulter: true, ajouter: true, modifier: true),
    DroitFormulaire('Reclamations SAV', 'Gérer les réclamations SAV'),
    DroitFormulaire('Prestataires', 'Gestion des prestataires'),
    // Lignes de l'image
    DroitFormulaire('ParametrageSAV', 'Parametrages des listes SAV'),
    DroitFormulaire('Utilisateur SAV', 'Gestion des utilisateurs'),
    DroitFormulaire('Dashboards SAV', 'Consultation des Dashboards SAV'),
    DroitFormulaire('Visites SAV', 'Consultation des Visites SAV'),
    DroitFormulaire('Tickets SAV', 'Consultation des Tickets et Observations SAV'),
    DroitFormulaire('Agenda SAV', 'Gestion des réunions et du suivi SAV'),
  ];

  final List<DroitSpecial> _droitsSpeciaux = [
    // Anciennes lignes
    DroitSpecial('RealiserObservation', 'Tickets', 'Réaliser une observation'),
    DroitSpecial('AcceptObservation', 'Tickets', 'Accepter une observation'),
    DroitSpecial('RefusObservation', 'Tickets', 'Refuser une observation'),
    DroitSpecial('PlanificationTravaux', 'Tickets', 'Planification Travaux'),
    DroitSpecial('PlanificationTravauxObservation', 'Tickets', 'Planification travaux de l\'observation'),
    // Lignes de l'image
    DroitSpecial('Réception Technique', 'Visites SAV', 'Consulter et Ajouter Les Visites De Type Réception Technique'),
    DroitSpecial('Livraison Technique', 'Visites SAV', 'Consulter et ajouter les visites de type Livraison Technique'),
    DroitSpecial('Livraison Client', 'Visites SAV', 'Consulter et ajouter les visites de type Livraison Client'),
    DroitSpecial('Livraison Syndic', 'Visites SAV', 'Consulter et ajouter les visites de type Livraison Syndic'),
    DroitSpecial('Réclamation SAV', 'Visites SAV', 'Consulter et ajouter les visites de type Réclamation SAV'),
    DroitSpecial('CheckAllAgenda', 'Agenda SAV', 'Consulter toutes les réunions de l\'Agenda SAV'),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return const Color(0xFF3B82F6);
            return null;
          }),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFEFF6FF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E40AF),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Détails de l'utilisateur",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildInfoUserCard()),
                        const SizedBox(width: 24),
                        Expanded(child: _buildProjectConfigCard()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      _buildInfoUserCard(),
                      const SizedBox(height: 24),
                      _buildProjectConfigCard(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),
              _buildDroitsFormulaires(context),
              const SizedBox(height: 40),
              _buildDroitsSpeciaux(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoUserCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFEFF6FF),
                  child: Icon(Icons.person_outline, color: Colors.blue[700]),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations utilisateur',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    Text(
                      'Détails du profil',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildInfoField('Nom complet', widget.utilisateur.nomComplet, Icons.person_outline)),
                const SizedBox(width: 16),
                Expanded(child: _buildInfoField('Login', widget.utilisateur.role, null)),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoField('Email', widget.utilisateur.email, Icons.email_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value, IconData? icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectConfigCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFEFF6FF),
                  child: Icon(Icons.settings_outlined, color: Colors.grey[700]),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Configuration des projets',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const Text(
                      'Attribution et gestion',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Sélection des projets',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 4),
            Text(
              'Attribuez des projets à cet utilisateur pour lui donner accès aux fonctionnalités spécifiques.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _showMultiSelectProjects,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _selectedProjects.isEmpty ? 'Aucun projet attribué' : _selectedProjects.join(', '),
                  style: const TextStyle(fontSize: 14, color: Color(0xFF334155)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFEF3C7)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attention',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Les modifications ne seront appliquées qu\'après avoir cliqué sur "Enregistrer". L\'utilisateur perdra l\'accès aux projets désélectionnés.',
                    style: TextStyle(fontSize: 12, color: Color(0xFFB45309)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Projets sélectionnés: ${_selectedProjects.length}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Projets enregistrés avec succès'), backgroundColor: Colors.green),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E40AF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Enregistrer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMultiSelectProjects() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Sélectionner des projets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              contentPadding: const EdgeInsets.only(top: 12, bottom: 12),
              content: SizedBox(
                width: 400,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _allProjects.length,
                  itemBuilder: (context, index) {
                    final projet = _allProjects[index];
                    final isSelected = _selectedProjects.contains(projet);
                    return ListTile(
                      leading: isSelected ? const Icon(Icons.check, color: Color(0xFF3B82F6)) : const SizedBox(width: 24),
                      title: Text(projet, style: TextStyle(color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF1E293B), fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
                      tileColor: isSelected ? const Color(0xFFEFF6FF) : null,
                      onTap: () {
                        setDialogState(() {
                          if (isSelected) {
                            _selectedProjects.remove(projet);
                          } else {
                            _selectedProjects.add(projet);
                          }
                        });
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, [String? trailing]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A)),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(fontSize: 13, color: const Color(0xFF64748B).withValues(alpha: 0.9)),
            ),
        ],
      ),
    );
  }

  Widget _buildDroitsFormulaires(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Droits formulaires', '${_droitsFormulaire.length} formulaire(s) disponible(s)'),
        ..._droitsFormulaire.map((d) => _buildProfessionalFormCard(d)).toList(),
      ],
    );
  }

  Widget _buildDroitsSpeciaux(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader('Droits spéciaux', '${_droitsSpeciaux.length} droit(s) spécial(aux) disponible(s)'),
        ..._droitsSpeciaux.map((d) => _buildProfessionalSpecialCard(d)).toList(),
      ],
    );
  }

  Widget _buildProfessionalFormCard(DroitFormulaire right) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Color(0xFF4F46E5),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        right.formulaire,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        right.description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'PERMISSIONS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFF3F4F6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  children: [
                    _buildPermissionChip(
                      'Consulter',
                      right.consulter,
                      (v) => setState(() => right.consulter = v),
                      Icons.visibility_outlined,
                    ),
                    _buildPermissionChip(
                      'Ajouter',
                      right.ajouter,
                      (v) => setState(() => right.ajouter = v),
                      Icons.add_circle_outline,
                    ),
                    _buildPermissionChip(
                      'Modifier',
                      right.modifier,
                      (v) => setState(() => right.modifier = v),
                      Icons.edit_outlined,
                    ),
                    _buildPermissionChip(
                      'Supprimer',
                      right.supprimer,
                      (v) => setState(() => right.supprimer = v),
                      Icons.delete_outline,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionChip(
    String label,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: value ? const Color(0xFFEEF2FF) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value ? const Color(0xFF6366F1) : const Color(0xFFE5E7EB),
            width: value ? 1.2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 12,
              color: value ? const Color(0xFF6366F1) : const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: value ? FontWeight.w600 : FontWeight.w500,
                color: value
                    ? const Color(0xFF6366F1)
                    : const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(width: 4),
            Transform.scale(
              scale: 0.7,
              child: Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                activeColor: const Color(0xFF6366F1),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalSpecialCard(DroitSpecial right) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.star_border,
              size: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        right.droit,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        right.formulaire,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  right.description,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: right.active,
            onChanged: (v) => setState(() => right.active = v),
            activeColor: const Color(0xFF6366F1),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

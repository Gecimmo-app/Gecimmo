import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifPush   = true;
  bool _notifEmail  = false;
  bool _notif1h     = true;
  bool _notif24h    = true;
  bool _darkMode    = false;
  String _lang      = 'Français';
  String _defView   = 'Mois';

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppTheme.background,
    appBar: AppBar(title: const Text('Paramètres')),
    body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
      // Profile
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
        CircleAvatar(radius: 30, backgroundColor: const Color(0xFF6366F1),
          child: const Text('A', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
        const SizedBox(width: 14),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Admin Utilisateur', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          Text('admin@crmagenda.fr', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          Text('Administrateur', style: TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w500)),
        ])),
        IconButton(icon: const Icon(Icons.edit_outlined, color: AppTheme.textSecondary), onPressed: () {}),
      ]))),
      const SizedBox(height: 16),

      _SectionTitle('Notifications'),
      Card(child: Column(children: [
        _SwitchTile('Notifications push', 'Recevoir des alertes sur l\'appareil', Icons.notifications_outlined, _notifPush, (v) => setState(() => _notifPush = v)),
        const Divider(height: 1, indent: 56),
        _SwitchTile('Notifications email', 'Recevoir un email de rappel', Icons.email_outlined, _notifEmail, (v) => setState(() => _notifEmail = v)),
        const Divider(height: 1, indent: 56),
        _SwitchTile('Rappel 1 heure avant', 'Alerte 60 min avant chaque tâche', Icons.timer_outlined, _notif1h, (v) => setState(() => _notif1h = v)),
        const Divider(height: 1, indent: 56),
        _SwitchTile('Rappel 24h avant', 'Alerte la veille de chaque tâche', Icons.today_outlined, _notif24h, (v) => setState(() => _notif24h = v)),
      ])),
      const SizedBox(height: 16),

      _SectionTitle('Affichage'),
      Card(child: Column(children: [
        _SwitchTile('Mode sombre', 'Interface en thème sombre', Icons.dark_mode_outlined, _darkMode, (v) => setState(() => _darkMode = v)),
        const Divider(height: 1, indent: 56),
        _SelectTile('Langue', _lang, Icons.language_outlined, () => _pickOption('Langue', ['Français','English','العربية'], (v) => setState(() => _lang = v))),
        const Divider(height: 1, indent: 56),
        _SelectTile('Vue par défaut', _defView, Icons.calendar_view_month_outlined, () => _pickOption('Vue par défaut', ['Jour','Semaine','Mois'], (v) => setState(() => _defView = v))),
      ])),
      const SizedBox(height: 16),

      _SectionTitle('Compte'),
      Card(child: Column(children: [
        _LinkTile('Changer le mot de passe', Icons.lock_outline, AppTheme.textPrimary, () {}),
        const Divider(height: 1, indent: 56),
        _LinkTile('Exporter les données', Icons.download_outlined, AppTheme.primary, () {}),
        const Divider(height: 1, indent: 56),
        _LinkTile('À propos', Icons.info_outline, AppTheme.textPrimary, () => _showAbout()),
        const Divider(height: 1, indent: 56),
        _LinkTile('Se déconnecter', Icons.logout, AppTheme.red, () => _confirmLogout()),
      ])),
      const SizedBox(height: 32),
    ])),
  );

  void _pickOption(String title, List<String> opts, Function(String) onSel) {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const SizedBox(height: 8),
        ...opts.map((o) => ListTile(title: Text(o), onTap: () { onSel(o); Navigator.pop(context); })),
        const SizedBox(height: 16),
      ]),
    );
  }

  void _showAbout() => showDialog(context: context, builder: (_) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    title: const Text('CRM Agenda'),
    content: const Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Version 1.0.0'), SizedBox(height: 4),
      Text('© 2026 CRM Agenda. Tous droits réservés.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
    ]),
    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer'))],
  ));

  void _confirmLogout() => showDialog(context: context, builder: (_) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    title: const Text('Se déconnecter ?'),
    content: const Text('Vous serez redirigé vers la page de connexion.'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
      ElevatedButton(onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.red),
        child: const Text('Déconnecter')),
    ],
  ));
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textHint, letterSpacing: 1)),
  );
}

class _SwitchTile extends StatelessWidget {
  final String title, sub; final IconData icon; final bool value; final ValueChanged<bool> onChanged;
  const _SwitchTile(this.title, this.sub, this.icon, this.value, this.onChanged);
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: AppTheme.textSecondary, size: 22),
    title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
    trailing: Switch(value: value, onChanged: onChanged, activeColor: AppTheme.primary),
  );
}

class _SelectTile extends StatelessWidget {
  final String title, value; final IconData icon; final VoidCallback onTap;
  const _SelectTile(this.title, this.value, this.icon, this.onTap);
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: AppTheme.textSecondary, size: 22),
    title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(value, style: const TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w500)),
      const SizedBox(width: 4),
      const Icon(Icons.chevron_right, size: 18, color: AppTheme.textHint),
    ]),
    onTap: onTap,
  );
}

class _LinkTile extends StatelessWidget {
  final String title; final IconData icon; final Color color; final VoidCallback onTap;
  const _LinkTile(this.title, this.icon, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: color, size: 22),
    title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
    trailing: const Icon(Icons.chevron_right, size: 18, color: AppTheme.textHint),
    onTap: onTap,
  );
}
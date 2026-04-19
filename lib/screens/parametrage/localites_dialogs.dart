import 'package:flutter/material.dart';
import 'localites_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Dialog : Ajouter
// ─────────────────────────────────────────────────────────────────────────────

class AddLocaliteDialog extends StatefulWidget {
  final Color primaryBlue;
  final Color borderColor;
  final Color textTitle;
  final Color textMuted;
  final void Function(String libelle, bool visible, bool partieCommune, bool bien) onSave;

  const AddLocaliteDialog({
    super.key,
    required this.primaryBlue,
    required this.borderColor,
    required this.textTitle,
    required this.textMuted,
    required this.onSave,
  });

  @override
  State<AddLocaliteDialog> createState() => _AddLocaliteDialogState();
}

class _AddLocaliteDialogState extends State<AddLocaliteDialog> {
  final _libelleCtrl = TextEditingController();
  bool _visible = true;
  bool _partieCommune = false;
  bool _bien = false;
  String? _error;

  @override
  void dispose() {
    _libelleCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final t = _libelleCtrl.text.trim();
    if (t.isEmpty) {
      setState(() => _error = 'Le libellé est obligatoire');
      return;
    }
    widget.onSave(t, _visible, _partieCommune, _bien);
  }

  @override
  Widget build(BuildContext context) {
    final dialogCheckboxTheme = CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return widget.primaryBlue;
        return null;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
    );

    return Theme(
      data: Theme.of(context).copyWith(checkboxTheme: dialogCheckboxTheme),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Ajouter une nouvelle localité',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: widget.textTitle,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Libellé *',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.textMuted.withValues(alpha: 0.95),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _libelleCtrl,
                  decoration: InputDecoration(
                    hintText: 'Entrez le libellé',
                    errorText: _error,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: widget.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: widget.borderColor.withValues(alpha: 0.9)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: widget.primaryBlue, width: 1.5),
                    ),
                  ),
                  onChanged: (_) => setState(() => _error = null),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    CheckboxListTile(
                      value: _visible,
                      onChanged: (v) => setState(() => _visible = v ?? false),
                      title: const Text('Visible', style: TextStyle(fontSize: 14)),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    CheckboxListTile(
                      value: _partieCommune,
                      onChanged: (v) => setState(() => _partieCommune = v ?? false),
                      title: const Text('Partie Commune', style: TextStyle(fontSize: 14)),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    CheckboxListTile(
                      value: _bien,
                      onChanged: (v) => setState(() => _bien = v ?? false),
                      title: const Text('Bien', style: TextStyle(fontSize: 14)),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                DialogBottomActions(
                  onCancel: () => Navigator.of(context).pop(),
                  onSubmit: _submit,
                  submitLabel: 'Ajouter la localité',
                  primaryBlue: widget.primaryBlue,
                  borderColor: widget.borderColor,
                  textTitle: widget.textTitle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dialog : Modifier
// ─────────────────────────────────────────────────────────────────────────────

class EditLocaliteDialog extends StatefulWidget {
  final LocaliteData initial;
  final Color primaryBlue;
  final Color borderColor;
  final Color textTitle;
  final Color textMuted;
  final void Function(LocaliteData updated) onSave;

  const EditLocaliteDialog({
    super.key,
    required this.initial,
    required this.primaryBlue,
    required this.borderColor,
    required this.textTitle,
    required this.textMuted,
    required this.onSave,
  });

  @override
  State<EditLocaliteDialog> createState() => _EditLocaliteDialogState();
}

class _EditLocaliteDialogState extends State<EditLocaliteDialog> {
  late final TextEditingController _libelleCtrl;
  late bool _visible;
  late bool _partieCommune;
  late bool _bien;
  String? _error;

  @override
  void initState() {
    super.initState();
    _libelleCtrl = TextEditingController(text: widget.initial.libelle);
    _visible = widget.initial.visible;
    _partieCommune = widget.initial.partieCommune;
    _bien = widget.initial.bien;
  }

  @override
  void dispose() {
    _libelleCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final t = _libelleCtrl.text.trim();
    if (t.isEmpty) {
      setState(() => _error = 'Le libellé est obligatoire');
      return;
    }
    widget.onSave(widget.initial.copyWith(
      libelle: t, 
      visible: _visible, 
      partieCommune: _partieCommune,
      bien: _bien
    ));
  }

  @override
  Widget build(BuildContext context) {
    final dialogCheckboxTheme = CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return widget.primaryBlue;
        return null;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
    );

    return Theme(
      data: Theme.of(context).copyWith(checkboxTheme: dialogCheckboxTheme),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Modifier la localité',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: widget.textTitle,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Libellé *',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.textMuted.withValues(alpha: 0.95),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _libelleCtrl,
                  decoration: InputDecoration(
                    hintText: 'Entrez le libellé',
                    errorText: _error,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: widget.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: widget.borderColor.withValues(alpha: 0.9)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: widget.primaryBlue, width: 1.5),
                    ),
                  ),
                  onChanged: (_) => setState(() => _error = null),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    CheckboxListTile(
                      value: _visible,
                      onChanged: (v) => setState(() => _visible = v ?? false),
                      title: const Text('Visible', style: TextStyle(fontSize: 14)),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    CheckboxListTile(
                      value: _partieCommune,
                      onChanged: (v) => setState(() => _partieCommune = v ?? false),
                      title: const Text('Partie Commune', style: TextStyle(fontSize: 14)),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    CheckboxListTile(
                      value: _bien,
                      onChanged: (v) => setState(() => _bien = v ?? false),
                      title: const Text('Bien', style: TextStyle(fontSize: 14)),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                DialogBottomActions(
                  onCancel: () => Navigator.of(context).pop(),
                  onSubmit: _submit,
                  submitLabel: 'Enregistrer les modifications',
                  primaryBlue: widget.primaryBlue,
                  borderColor: widget.borderColor,
                  textTitle: widget.textTitle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Barre d’actions réutilisable
class DialogBottomActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final String submitLabel;
  final Color primaryBlue;
  final Color borderColor;
  final Color textTitle;

  const DialogBottomActions({
    super.key,
    required this.onCancel,
    required this.onSubmit,
    required this.submitLabel,
    required this.primaryBlue,
    required this.borderColor,
    required this.textTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 10,
        children: [
          OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: textTitle,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              side: BorderSide(color: borderColor),
            ),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text(
              submitLabel,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}

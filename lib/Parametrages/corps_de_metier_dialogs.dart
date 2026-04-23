import 'package:flutter/material.dart';
import 'corps_de_metier_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Dialog : Ajouter
// ─────────────────────────────────────────────────────────────────────────────

class AddCorpsMetierDialog extends StatefulWidget {
  final Color primaryBlue;
  final Color borderColor;
  final Color textTitle;
  final Color textMuted;
  final void Function(String libelle, bool bien, bool partieCommune) onSave;

  const AddCorpsMetierDialog({
    super.key,
    required this.primaryBlue,
    required this.borderColor,
    required this.textTitle,
    required this.textMuted,
    required this.onSave,
  });

  @override
  State<AddCorpsMetierDialog> createState() => _AddCorpsMetierDialogState();
}

class _AddCorpsMetierDialogState extends State<AddCorpsMetierDialog> {
  final _libelleCtrl = TextEditingController();
  bool _bien = true;
  bool _partieCommune = true;
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
    widget.onSave(t, _bien, _partieCommune);
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  'Ajouter un nouveau type de ticket',
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
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        value: _bien,
                        onChanged: (v) => setState(() => _bien = v ?? false),
                        title: const Text('Bien', style: TextStyle(fontSize: 14)),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CheckboxListTile(
                        value: _partieCommune,
                        onChanged: (v) => setState(() => _partieCommune = v ?? false),
                        title: const Text('Partie commune', style: TextStyle(fontSize: 14)),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                DialogBottomActions(
                  onCancel: () => Navigator.of(context).pop(),
                  onSubmit: _submit,
                  submitLabel: 'Enregistrer',
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

class EditCorpsMetierDialog extends StatefulWidget {
  final CorpsDeMetierData initial;
  final Color primaryBlue;
  final Color borderColor;
  final Color textTitle;
  final Color textMuted;
  final void Function(CorpsDeMetierData updated) onSave;

  const EditCorpsMetierDialog({
    super.key,
    required this.initial,
    required this.primaryBlue,
    required this.borderColor,
    required this.textTitle,
    required this.textMuted,
    required this.onSave,
  });

  @override
  State<EditCorpsMetierDialog> createState() => _EditCorpsMetierDialogState();
}

class _EditCorpsMetierDialogState extends State<EditCorpsMetierDialog> {
  late final TextEditingController _libelleCtrl;
  late bool _bien;
  late bool _partieCommune;
  String? _error;

  @override
  void initState() {
    super.initState();
    _libelleCtrl = TextEditingController(text: widget.initial.libelle);
    _bien = widget.initial.bien;
    _partieCommune = widget.initial.partieCommune;
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
    widget.onSave(widget.initial.copyWith(libelle: t, bien: _bien, partieCommune: _partieCommune));
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  'Modifier le type de ticket',
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
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        value: _bien,
                        onChanged: (v) => setState(() => _bien = v ?? false),
                        title: const Text('Bien', style: TextStyle(fontSize: 14)),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: CheckboxListTile(
                        value: _partieCommune,
                        onChanged: (v) => setState(() => _partieCommune = v ?? false),
                        title: const Text('Partie commune', style: TextStyle(fontSize: 14)),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE4E7EC)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded, size: 18, color: widget.textMuted.withValues(alpha: 0.85)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Ce type est associé aux biens',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            color: widget.textMuted.withValues(alpha: 0.95),
                          ),
                        ),
                      ),
                    ],
                  ),
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

/// Barre d’actions des dialogues : pas de [Row] fixe → [Wrap] pour éviter l’overflow sur petits écrans.
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

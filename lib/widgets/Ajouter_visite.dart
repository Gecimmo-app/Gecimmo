import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// ─────────────────────────────────────────────
//  THEME SYSTEM
// ─────────────────────────────────────────────
class AppTheme {
  static const Color primary = Color(0xFF1E40AF);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryBackground = Color(0xFFEFF6FF);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color accent = Color(0xFF8B5CF6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFEFF6FF);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);

  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 20.0;
  static const double spacingXLarge = 24.0;

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 2);
}

class AppTextStyles {
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppTheme.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppTheme.textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppTheme.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppTheme.textPrimary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppTheme.textSecondary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppTheme.textSecondary,
    letterSpacing: 0.5,
  );
}

// ─────────────────────────────────────────────
//  DOMAIN MODELS
// ─────────────────────────────────────────────
enum VisitType {
  technicalReception('Réception Technique'),
  technicalDelivery('Livraison Technique'),
  clientDelivery('Livraison Client'),
  complaint('Réclamation');

  final String label;
  const VisitType(this.label);
}

enum VisitNature {
  commonArea('Partie Commune'),
  property('Bien');

  final String label;
  const VisitNature(this.label);
}

enum StructureNature {
  exterior('Extralimmeuble'),
  interior('Intralimmeuble');

  final String label;
  const StructureNature(this.label);
}

class Visit {
  final String id;
  final VisitType type;
  final String project;
  final String tranche;
  final VisitNature? visitNature;
  final StructureNature? structureNature;
  final String? grouping;
  final String? building;
  final String? floor;
  final String? propertyName;
  final String? technicalLead;
  final String? deliveryLead;
  final String? plan;
  final Offset? planCoordinates;
  final String? locality;
  final String? trade;
  final String? provider;
  final String? observation;
  final List<String> attachmentPaths;
  final DateTime createdAt;

  const Visit({
    required this.id,
    required this.type,
    required this.project,
    required this.tranche,
    this.visitNature,
    this.structureNature,
    this.grouping,
    this.building,
    this.floor,
    this.propertyName,
    this.technicalLead,
    this.deliveryLead,
    this.plan,
    this.planCoordinates,
    this.locality,
    this.trade,
    this.provider,
    this.observation,
    this.attachmentPaths = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.label,
    'project': project,
    'tranche': tranche,
    'visitNature': visitNature?.label,
    'structureNature': structureNature?.label,
    'grouping': grouping,
    'building': building,
    'floor': floor,
    'propertyName': propertyName,
    'technicalLead': technicalLead,
    'deliveryLead': deliveryLead,
    'plan': plan,
    'planCoordinates': planCoordinates != null ? {'dx': planCoordinates!.dx, 'dy': planCoordinates!.dy} : null,
    'locality': locality,
    'trade': trade,
    'provider': provider,
    'observation': observation,
    'attachmentPaths': attachmentPaths,
    'createdAt': createdAt.toIso8601String(),
  };
}

// ─────────────────────────────────────────────
//  FORM STATE
// ─────────────────────────────────────────────
class VisitFormState {
  final VisitType? visitType;
  final String? project;
  final String? tranche;
  final VisitNature? visitNature;
  final StructureNature? structureNature;
  final String? grouping;
  final String? building;
  final String? floor;
  final String? propertyName;
  final String? technicalLead;
  final String? deliveryLead;
  final String? plan;
  final Offset? planCoordinates;
  final String? locality;
  final String? trade;
  final String? provider;
  final String observation;
  final List<XFile> attachments;

  const VisitFormState({
    this.visitType,
    this.project,
    this.tranche,
    this.visitNature,
    this.structureNature,
    this.grouping,
    this.building,
    this.floor,
    this.propertyName,
    this.technicalLead,
    this.deliveryLead,
    this.plan,
    this.planCoordinates,
    this.locality,
    this.trade,
    this.provider,
    this.observation = '',
    this.attachments = const [],
  });

  bool get isValid => 
      visitType != null && 
      project != null && 
      project!.isNotEmpty &&
      tranche != null &&
      tranche!.isNotEmpty;

  VisitFormState copyWith({
    VisitType? visitType,
    String? project,
    String? tranche,
    VisitNature? visitNature,
    StructureNature? structureNature,
    String? grouping,
    String? building,
    String? floor,
    String? propertyName,
    String? technicalLead,
    String? deliveryLead,
    String? plan,
    Offset? planCoordinates,
    String? locality,
    String? trade,
    String? provider,
    String? observation,
    List<XFile>? attachments,
  }) {
    return VisitFormState(
      visitType: visitType ?? this.visitType,
      project: project ?? this.project,
      tranche: tranche ?? this.tranche,
      visitNature: visitNature ?? this.visitNature,
      structureNature: structureNature ?? this.structureNature,
      grouping: grouping ?? this.grouping,
      building: building ?? this.building,
      floor: floor ?? this.floor,
      propertyName: propertyName ?? this.propertyName,
      technicalLead: technicalLead ?? this.technicalLead,
      deliveryLead: deliveryLead ?? this.deliveryLead,
      plan: plan ?? this.plan,
      planCoordinates: planCoordinates ?? this.planCoordinates,
      locality: locality ?? this.locality,
      trade: trade ?? this.trade,
      provider: provider ?? this.provider,
      observation: observation ?? this.observation,
      attachments: attachments ?? this.attachments,
    );
  }

  Visit toVisit(String id) {
    return Visit(
      id: id,
      type: visitType!,
      project: project!,
      tranche: tranche!,
      visitNature: visitNature,
      structureNature: structureNature,
      grouping: grouping,
      building: building,
      floor: floor,
      propertyName: propertyName,
      technicalLead: technicalLead,
      deliveryLead: deliveryLead,
      plan: plan,
      planCoordinates: planCoordinates,
      locality: locality,
      trade: trade,
      provider: provider,
      observation: observation.isEmpty ? null : observation,
      attachmentPaths: attachments.map((f) => f.path).toList(),
      createdAt: DateTime.now(),
    );
  }
}

// ─────────────────────────────────────────────
//  CUSTOM FORM WIDGETS
// ─────────────────────────────────────────────
class FormDropdownField<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isRequired;

  const FormDropdownField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primary),
            const SizedBox(width: AppTheme.spacingSmall),
            Text(label, style: AppTextStyles.bodyMedium),
            if (isRequired)
              const Text(' *', style: TextStyle(color: AppTheme.error)),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSmall),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          elevation: 4,
          borderRadius: BorderRadius.circular(16),
          icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: AppTheme.primary),
          dropdownColor: AppTheme.surface,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: AppTheme.surface,
          ),
        ),
      ],
    );
  }
}

class FormSearchableDropdownField<T> extends StatefulWidget {
  final String label;
  final IconData icon;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T?> onChanged;
  final bool isRequired;

  const FormSearchableDropdownField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  State<FormSearchableDropdownField<T>> createState() => _FormSearchableDropdownFieldState<T>();
}

class _FormSearchableDropdownFieldState<T> extends State<FormSearchableDropdownField<T>> {
  void _openSearchDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => _SearchableDropdownSheet<T>(
        label: widget.label,
        items: widget.items,
        itemLabelBuilder: widget.itemLabelBuilder,
        selectedValue: widget.value,
        onSelected: (value) {
          widget.onChanged(value);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayText = widget.value != null ? widget.itemLabelBuilder(widget.value as T) : 'Sélectionner...';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(widget.icon, size: 18, color: AppTheme.primary),
            const SizedBox(width: AppTheme.spacingSmall),
            Text(widget.label, style: AppTextStyles.bodyMedium),
            if (widget.isRequired)
              const Text(' *', style: TextStyle(color: AppTheme.error)),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSmall),
        InkWell(
          onTap: _openSearchDialog,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: widget.value != null ? AppTheme.textPrimary : AppTheme.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: AppTheme.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchableDropdownSheet<T> extends StatefulWidget {
  final String label;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final T? selectedValue;
  final ValueChanged<T> onSelected;

  const _SearchableDropdownSheet({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabelBuilder,
    required this.selectedValue,
    required this.onSelected,
  });

  @override
  State<_SearchableDropdownSheet<T>> createState() => _SearchableDropdownSheetState<T>();
}

class _SearchableDropdownSheetState<T> extends State<_SearchableDropdownSheet<T>> {
  late List<T> _filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items.where((item) {
          final label = widget.itemLabelBuilder(item).toLowerCase();
          return label.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: AppTheme.spacingLarge),
          Text('Rechercher : ${widget.label}', style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppTheme.spacingMedium),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tapez pour rechercher...',
              prefixIcon: const Icon(Icons.search, color: AppTheme.primary),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              filled: true,
              fillColor: AppTheme.background,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final isSelected = item == widget.selectedValue;
                return ListTile(
                  title: Text(widget.itemLabelBuilder(item), style: AppTextStyles.bodyMedium),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: AppTheme.primary) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  selected: isSelected,
                  selectedTileColor: AppTheme.primary.withOpacity(0.05),
                  onTap: () => widget.onSelected(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FormTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final ValueChanged<String> onChanged;
  final int maxLines;
  final String hintText;
  final bool isRequired;

  const FormTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.maxLines = 1,
    this.hintText = '',
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primary),
            const SizedBox(width: AppTheme.spacingSmall),
            Text(label, style: AppTextStyles.bodyMedium),
            if (isRequired)
              const Text(' *', style: TextStyle(color: AppTheme.error)),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSmall),
        TextField(
          maxLines: maxLines,
          onChanged: onChanged,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppTheme.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: AppTheme.surface,
          ),
        ),
      ],
    );
  }
}

class ReadOnlyField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;

  const ReadOnlyField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primary),
            const SizedBox(width: AppTheme.spacingSmall),
            Text(label, style: AppTextStyles.bodyMedium),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSmall),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.border),
            borderRadius: BorderRadius.circular(12),
            color: AppTheme.primaryBackground,
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_outline, size: 18, color: AppTheme.textSecondary),
              const SizedBox(width: AppTheme.spacingSmall),
              Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  STEP INDICATOR
// ─────────────────────────────────────────────
class StepItem {
  final IconData icon;
  final String label;

  const StepItem({
    required this.icon,
    required this.label,
  });
}

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<StepItem> steps;
  final ValueChanged<int> onStepTap;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.steps,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = currentStep >= index;
          final isCurrent = currentStep == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => onStepTap(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: AppTheme.animationDuration,
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? AppTheme.primary : AppTheme.border,
                      boxShadow: isCurrent ? [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ] : [],
                    ),
                    child: Icon(
                      steps[index].icon,
                      color: isActive ? AppTheme.surface : AppTheme.textSecondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    steps[index].label,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                      color: isActive ? AppTheme.primary : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MAIN FLOW WIDGET
// ─────────────────────────────────────────────
class AddVisitFlow extends StatefulWidget {
  final Function(Visit)? onVisitCreated;

  const AddVisitFlow({super.key, this.onVisitCreated});

  @override
  State<AddVisitFlow> createState() => _AddVisitFlowState();
}

class _AddVisitFlowState extends State<AddVisitFlow> {
  final List<StepItem> _steps = const [
    StepItem(icon: Icons.info_outline, label: 'Type'),
    StepItem(icon: Icons.build, label: 'Détails'),
    StepItem(icon: Icons.map_outlined, label: 'Plan'),
    StepItem(icon: Icons.note_add_outlined, label: 'Observation'),
    StepItem(icon: Icons.check_circle_outline, label: 'Validation'),
  ];

  int _currentStep = 0;
  VisitFormState _formState = const VisitFormState();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: IndexedStack(
                  index: _currentStep,
                  children: [
                    _Step1Content(
                      formState: _formState,
                      onFormChanged: _updateFormState,
                    ),
                    _Step2Content(
                      formState: _formState,
                      onFormChanged: _updateFormState,
                    ),
                    _Step3Content(
                      formState: _formState,
                      onFormChanged: _updateFormState,
                    ),
                    _Step4Content(
                      formState: _formState,
                      onFormChanged: _updateFormState,
                      onAddFile: _addFile,
                      onRemoveFile: _removeFile,
                    ),
                    _Step5Content(formState: _formState),
                  ],
                ),
              ),
            ),
          ),
          _BottomNavigation(
            currentStep: _currentStep,
            canGoNext: _canGoToNextStep(),
            onPrevious: _goToPrevious,
            onNext: _goToNext,
            onValidate: _validateAndSubmit,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primary,
      elevation: 0,
      title: Text(
        'Ajouter une visite',
        style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: () => _showExitConfirmation(),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: AppTheme.surface,
          child: StepIndicator(
            currentStep: _currentStep,
            steps: _steps,
            onStepTap: _goToStep,
          ),
        ),
      ),
    );
  }

  void _updateFormState(VisitFormState newState) {
    setState(() {
      _formState = newState;
    });
  }

  bool _canGoToNextStep() {
    switch (_currentStep) {
      case 0:
        return _formState.visitType != null && 
               _formState.project != null && 
               _formState.tranche != null;
      default:
        return true;
    }
  }

  void _goToStep(int step) {
    if (step <= _currentStep) {
      setState(() => _currentStep = step);
    }
  }

  void _goToPrevious() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _goToNext() {
    if (_currentStep < 4 && _canGoToNextStep()) {
      setState(() => _currentStep++);
    }
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter la création', style: AppTextStyles.titleLarge),
        content: const Text('Voulez-vous vraiment quitter ? Les données non enregistrées seront perdues.', style: AppTextStyles.bodyMedium),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fermer le dialogue
              Navigator.pop(context); // Fermer la page
            },
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.error.withOpacity(0.1),
              foregroundColor: AppTheme.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
  }

  void _validateAndSubmit() async {
    if (!_formState.isValid) {
      _showErrorSnackBar('Veuillez remplir tous les champs obligatoires');
      return;
    }

    final visit = _formState.toVisit(DateTime.now().millisecondsSinceEpoch.toString());
    
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      widget.onVisitCreated?.call(visit);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.success, size: 28),
            SizedBox(width: AppTheme.spacingSmall),
            Text('Visite créée avec succès!'),
          ],
        ),
        content: const Text('La visite a été enregistrée avec succès.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.success,
              foregroundColor: AppTheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _addFile() async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AttachmentPicker(
        onGalleryTap: _pickFromGallery,
        onCameraTap: _pickFromCamera,
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    try {
      final files = await _imagePicker.pickMultiImage(imageQuality: 80);
      if (files.isNotEmpty) {
        final newAttachments = List<XFile>.from(_formState.attachments)..addAll(files);
        _updateFormState(_formState.copyWith(attachments: newAttachments));
        _showSuccessSnackBar('${files.length} fichier(s) ajouté(s)');
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de l\'accès à la galerie');
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final file = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (file != null) {
        final newAttachments = List<XFile>.from(_formState.attachments)..add(file);
        _updateFormState(_formState.copyWith(attachments: newAttachments));
        _showSuccessSnackBar('Photo ajoutée avec succès');
      }
    } catch (e) {
      _showErrorSnackBar('Erreur lors de l\'accès à l\'appareil photo');
    }
  }

  void _removeFile(int index) {
    final newAttachments = List<XFile>.from(_formState.attachments)..removeAt(index);
    _updateFormState(_formState.copyWith(attachments: newAttachments));
    _showSuccessSnackBar('Fichier supprimé');
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.check_circle, color: AppTheme.surface, size: 20),
          const SizedBox(width: AppTheme.spacingSmall),
          Text(message),
        ]),
        backgroundColor: AppTheme.success,
        duration: AppTheme.snackBarDuration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.error, color: AppTheme.surface, size: 20),
          const SizedBox(width: AppTheme.spacingSmall),
          Text(message),
        ]),
        backgroundColor: AppTheme.error,
        duration: AppTheme.snackBarDuration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  STEP 1: TYPE & PROJECT
// ─────────────────────────────────────────────
class _Step1Content extends StatelessWidget {
  final VisitFormState formState;
  final Function(VisitFormState) onFormChanged;

  const _Step1Content({
    required this.formState,
    required this.onFormChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: _FormCard(
        children: [
          FormSearchableDropdownField<VisitType>(
            label: 'Type visite',
            icon: Icons.category_outlined,
            value: formState.visitType,
            items: VisitType.values,
            itemLabelBuilder: (type) => type.label,
            onChanged: (value) => onFormChanged(formState.copyWith(visitType: value)),
            isRequired: true,
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          FormSearchableDropdownField<String>(
            label: 'Projet',
            icon: Icons.folder_outlined,
            value: formState.project,
            items: const ['Projet1', 'Projet2', 'Projet3', 'Projet4', 'Projet5'],
            itemLabelBuilder: (e) => e,
            onChanged: (value) => onFormChanged(formState.copyWith(project: value)),
            isRequired: true,
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          FormSearchableDropdownField<String>(
            label: 'Tranche',
            icon: Icons.view_agenda_outlined,
            value: formState.tranche,
            items: const ['Tranche1', 'Tranche2', 'Tranche3', 'Tranche4', 'Tranche5'],
            itemLabelBuilder: (e) => e,
            onChanged: (value) => onFormChanged(formState.copyWith(tranche: value)),
            isRequired: true,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  STEP 2: DETAILS
// ─────────────────────────────────────────────
class _Step2Content extends StatelessWidget {
  final VisitFormState formState;
  final Function(VisitFormState) onFormChanged;

  const _Step2Content({
    required this.formState,
    required this.onFormChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: _FormCard(
        children: [
          FormSearchableDropdownField<VisitNature>(
            label: 'Nature visite',
            icon: Icons.nature_people,
            value: formState.visitNature,
            items: VisitNature.values,
            itemLabelBuilder: (nature) => nature.label,
            onChanged: (value) {
              if (value == VisitNature.property) {
                // Auto-remplissage pour "Bien" simulé depuis le rdv
                onFormChanged(formState.copyWith(
                  visitNature: value,
                  tranche: 'Tranche RDV-101', 
                  deliveryLead: 'Pilote Liv. Auto',
                ));
              } else {
                onFormChanged(formState.copyWith(visitNature: value));
              }
            },
          ),
          if (formState.visitNature == VisitNature.commonArea) ...[
            const SizedBox(height: AppTheme.spacingLarge),
            FormSearchableDropdownField<StructureNature>(
              label: 'Nature structure',
              icon: Icons.apartment,
              value: formState.structureNature,
              items: StructureNature.values,
              itemLabelBuilder: (nature) => nature.label,
              onChanged: (value) => onFormChanged(formState.copyWith(structureNature: value)),
            ),
          ],
          if (formState.visitNature == VisitNature.property) ...[
            const SizedBox(height: AppTheme.spacingLarge),
            ReadOnlyField(
              label: 'Tranche (Depuis RDV)',
              icon: Icons.view_agenda_outlined,
              value: formState.tranche ?? 'Non définie',
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            FormSearchableDropdownField<String>(
              label: 'Groupement',
              icon: Icons.group,
              value: formState.grouping,
              items: const ['GH 1', 'GH 2', 'GH 3', 'GH 4', 'GH 5', 'GH 6.1'],
              itemLabelBuilder: (e) => e,
              onChanged: (value) => onFormChanged(formState.copyWith(grouping: value)),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            FormSearchableDropdownField<String>(
              label: 'Immeuble',
              icon: Icons.apartment,
              value: formState.building,
              items: const ['Immeuble A', 'Immeuble B', 'Immeuble C', 'Immeuble D'],
              itemLabelBuilder: (e) => e,
              onChanged: (value) => onFormChanged(formState.copyWith(building: value)),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            FormSearchableDropdownField<String>(
              label: 'Étage',
              icon: Icons.layers,
              value: formState.floor,
              items: const ['RDC', '1er Étage', '2ème Étage', '3ème Étage'],
              itemLabelBuilder: (e) => e,
              onChanged: (value) => onFormChanged(formState.copyWith(floor: value)),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            FormSearchableDropdownField<String>(
              label: 'Bien',
              icon: Icons.home,
              value: formState.propertyName,
              items: const ['Bien 101', 'Bien 102', 'Bien 201', 'Bien 202'],
              itemLabelBuilder: (e) => e,
              onChanged: (value) => onFormChanged(formState.copyWith(propertyName: value)),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            FormSearchableDropdownField<String>(
              label: 'Pilote technique',
              icon: Icons.person,
              value: formState.technicalLead,
              items: const ['utilisateur1013', 'utilisateur10016', 'utilisateur10088', 'Aucun pilote technique'],
              itemLabelBuilder: (e) => e,
              onChanged: (value) => onFormChanged(formState.copyWith(technicalLead: value)),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            ReadOnlyField(
              label: 'Pilote de livraison',
              icon: Icons.local_shipping,
              value: formState.deliveryLead ?? 'Non défini',
            ),
          ] else ...[
            const SizedBox(height: AppTheme.spacingLarge),
            ReadOnlyField(
              label: 'Tranche',
              icon: Icons.view_agenda_outlined,
              value: formState.tranche ?? 'Non définie',
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            FormSearchableDropdownField<String>(
              label: 'Groupement',
              icon: Icons.group,
              value: formState.grouping,
              items: const ['GH 1', 'GH 2', 'GH 3', 'GH 4', 'GH 5', 'GH 6.1'],
              itemLabelBuilder: (e) => e,
              onChanged: (value) => onFormChanged(formState.copyWith(grouping: value)),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            FormSearchableDropdownField<String>(
              label: 'Pilote technique',
              icon: Icons.person,
              value: formState.technicalLead,
              items: const ['utilisateur1013', 'utilisateur10016', 'utilisateur10088', 'Aucun pilote technique'],
              itemLabelBuilder: (e) => e,
              onChanged: (value) => onFormChanged(formState.copyWith(technicalLead: value)),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  STEP 3: PLAN SELECTION
// ─────────────────────────────────────────────
class _Step3Content extends StatelessWidget {
  final VisitFormState formState;
  final Function(VisitFormState) onFormChanged;

  const _Step3Content({
    required this.formState,
    required this.onFormChanged,
  });

  @override
  Widget build(BuildContext context) {
    const plans = ['Plan RDC', 'Plan 1er Étage', 'Plan 2ème Étage', 'Plan Sous-sol'];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sélectionner un plan', style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppTheme.spacingSmall),
          const Text('Choisissez le plan correspondant à la visite', style: AppTextStyles.bodySmall),
          const SizedBox(height: AppTheme.spacingLarge),
          ...plans.map((plan) => _PlanCard(
                planName: plan,
                isSelected: formState.plan == plan,
                onTap: () {
                   showDialog(
                     context: context,
                     builder: (context) => _InteractivePlanDialog(
                       initialPlan: plan, 
                       initialCoordinates: formState.plan == plan ? formState.planCoordinates : null,
                       onCoordinatesPicked: (offset) {
                         onFormChanged(formState.copyWith(
                           plan: plan,
                           planCoordinates: offset,
                         ));
                       }
                     )
                   );
                },
              )),
          if (formState.plan != null && formState.planCoordinates != null) ...[
             const SizedBox(height: AppTheme.spacingLarge),
             Container(
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(
                 color: AppTheme.primaryBackground,
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(color: AppTheme.primary, width: 1.5)
               ),
               child: Row(
                 children: [
                   const Icon(Icons.location_pin, color: AppTheme.error),
                   const SizedBox(width: AppTheme.spacingMedium),
                   Expanded(
                     child: Text(
                       'Position marquée sur ${formState.plan}', 
                       style: AppTextStyles.bodyMedium.copyWith(color: AppTheme.primary, fontWeight: FontWeight.w600)
                     )
                   ),
                 ]
               )
             )
          ]
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String planName;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.planName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppTheme.animationDuration,
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBackground : AppTheme.surface,
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary.withOpacity(0.1) : AppTheme.border.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.map,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                size: 28,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMedium),
            Expanded(
              child: Text(
                planName,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppTheme.surface, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}

class _InteractivePlanDialog extends StatefulWidget {
  final String initialPlan;
  final Offset? initialCoordinates;
  final ValueChanged<Offset> onCoordinatesPicked;

  const _InteractivePlanDialog({
    required this.initialPlan,
    this.initialCoordinates,
    required this.onCoordinatesPicked,
  });

  @override
  State<_InteractivePlanDialog> createState() => _InteractivePlanDialogState();
}

class _InteractivePlanDialogState extends State<_InteractivePlanDialog> {
  Offset? _selectedCoordinates;

  @override
  void initState() {
    super.initState();
    _selectedCoordinates = widget.initialCoordinates;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(AppTheme.spacingMedium),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pointer sur : ${widget.initialPlan}', style: AppTextStyles.titleLarge),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 4 / 3, // Aspect ratio approximatif pour le plan
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTapDown: (details) {
                          setState(() {
                            _selectedCoordinates = Offset(
                              details.localPosition.dx / constraints.maxWidth,
                              details.localPosition.dy / constraints.maxHeight,
                            );
                          });
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              'https://thumbs.dreamstime.com/z/appartement-plan-plat-31346452.jpg?ct=jpeg',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[200],
                                child: const Center(child: Text('Plan introuvable')),
                              ),
                            ),
                            if (_selectedCoordinates != null)
                              Positioned(
                                left: _selectedCoordinates!.dx * constraints.maxWidth - 12,
                                top: _selectedCoordinates!.dy * constraints.maxHeight - 24,
                                child: const Icon(Icons.location_pin, color: AppTheme.error, size: 24),
                              ),
                          ],
                        ),
                      );
                    }
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _selectedCoordinates == null ? null : () {
                    widget.onCoordinatesPicked(_selectedCoordinates!);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.surface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Valider'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  STEP 4: OBSERVATION & ATTACHMENTS
// ─────────────────────────────────────────────
class _Step4Content extends StatelessWidget {
  final VisitFormState formState;
  final Function(VisitFormState) onFormChanged;
  final VoidCallback onAddFile;
  final Function(int) onRemoveFile;

  const _Step4Content({
    required this.formState,
    required this.onFormChanged,
    required this.onAddFile,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: _FormCard(
        children: [
          FormSearchableDropdownField<String>(
            label: 'Localité',
            icon: Icons.location_on,
            value: formState.locality,
            items: const ['Bourderie', 'Centre Ville', 'Zone Industrielle', "Parc d'activités"],
            itemLabelBuilder: (e) => e,
            onChanged: (value) => onFormChanged(formState.copyWith(locality: value)),
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          FormSearchableDropdownField<String>(
            label: 'Corps de métier',
            icon: Icons.build,
            value: formState.trade,
            items: const ['Maçonnerie', 'Plomberie', 'Électricité', 'Peinture', 'Plâtrerie', 'Menuiserie'],
            itemLabelBuilder: (e) => e,
            onChanged: (value) => onFormChanged(formState.copyWith(trade: value)),
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          FormSearchableDropdownField<String>(
            label: 'Prestataire',
            icon: Icons.business,
            value: formState.provider,
            items: const ['Prestataire 1', 'Prestataire 2', 'Prestataire 3', 'Prestataire 4'],
            itemLabelBuilder: (e) => e,
            onChanged: (value) => onFormChanged(formState.copyWith(provider: value)),
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          FormTextField(
            label: 'Observation',
            icon: Icons.description,
            value: formState.observation,
            onChanged: (value) => onFormChanged(formState.copyWith(observation: value)),
            maxLines: 4,
            hintText: 'Saisissez votre observation...',
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          _AttachmentsSection(
            attachments: formState.attachments,
            onAddFile: onAddFile,
            onRemoveFile: onRemoveFile,
          ),
        ],
      ),
    );
  }
}

class _AttachmentsSection extends StatelessWidget {
  final List<XFile> attachments;
  final VoidCallback onAddFile;
  final ValueChanged<int> onRemoveFile;

  const _AttachmentsSection({
    required this.attachments,
    required this.onAddFile,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.attach_file, size: 18, color: AppTheme.primary),
            SizedBox(width: AppTheme.spacingSmall),
            Text('Pièces jointes', style: AppTextStyles.bodyMedium),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSmall),
        ElevatedButton.icon(
          onPressed: onAddFile,
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Sélectionner des fichiers'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: AppTheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (attachments.isNotEmpty) ...[
          const SizedBox(height: AppTheme.spacingMedium),
          ...attachments.asMap().entries.map((entry) => Container(
                margin: const EdgeInsets.only(bottom: AppTheme.spacingSmall),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getFileIcon(entry.value.name),
                        color: AppTheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMedium),
                    Expanded(
                      child: Text(
                        entry.value.name,
                        style: AppTextStyles.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () => onRemoveFile(entry.key),
                      icon: const Icon(Icons.close, color: AppTheme.error, size: 20),
                    ),
                  ],
                ),
              )),
        ],
      ],
    );
  }

  IconData _getFileIcon(String filename) {
    final extension = filename.toLowerCase();
    if (extension.endsWith('.png') || extension.endsWith('.jpg') || extension.endsWith('.jpeg')) {
      return Icons.image;
    } else if (extension.endsWith('.pdf')) {
      return Icons.picture_as_pdf;
    } else if (extension.endsWith('.doc') || extension.endsWith('.docx')) {
      return Icons.description;
    }
    return Icons.insert_drive_file;
  }
}

class _AttachmentPicker extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;

  const _AttachmentPicker({
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingXLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Ajouter un fichier', style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppTheme.spacingSmall),
          const Text('Choisissez une source', style: AppTextStyles.bodySmall),
          const SizedBox(height: AppTheme.spacingXLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _AttachmentOption(
                icon: Icons.photo_library,
                label: 'Galerie',
                color: AppTheme.accent,
                onTap: () {
                  Navigator.pop(context);
                  onGalleryTap();
                },
              ),
              _AttachmentOption(
                icon: Icons.camera_alt,
                label: 'Appareil photo',
                color: AppTheme.primary,
                onTap: () {
                  Navigator.pop(context);
                  onCameraTap();
                },
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: AppTheme.spacingMedium),
          Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: color, fontSize: 14)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  STEP 5: SUMMARY
// ─────────────────────────────────────────────
class _Step5Content extends StatelessWidget {
  final VisitFormState formState;

  const _Step5Content({required this.formState});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Récapitulatif de la visite', style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppTheme.spacingSmall),
          const Text('Vérifiez les informations avant validation', style: AppTextStyles.bodySmall),
          const SizedBox(height: AppTheme.spacingLarge),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummarySection(
                    title: 'Informations générales',
                    icon: Icons.info_outline,
                    children: [
                      _SummaryRow(label: 'Type visite', value: formState.visitType?.label),
                      _SummaryRow(label: 'Projet', value: formState.project),
                      _SummaryRow(label: 'Tranche', value: formState.tranche),
                    ],
                  ),
                  const Divider(height: AppTheme.spacingXLarge),
                  _SummarySection(
                    title: 'Détails techniques',
                    icon: Icons.build,
                    children: [
                      _SummaryRow(label: 'Nature visite', value: formState.visitNature?.label),
                      if (formState.visitNature == VisitNature.commonArea)
                        _SummaryRow(label: 'Nature structure', value: formState.structureNature?.label),
                      if (formState.visitNature == VisitNature.property) ...[
                        _SummaryRow(label: 'Immeuble', value: formState.building),
                        _SummaryRow(label: 'Étage', value: formState.floor),
                        _SummaryRow(label: 'Bien', value: formState.propertyName),
                      ],
                      _SummaryRow(label: 'Groupement', value: formState.grouping),
                      _SummaryRow(label: 'Pilote technique', value: formState.technicalLead),
                      if (formState.visitNature == VisitNature.property)
                        _SummaryRow(label: 'Pilote de livraison', value: formState.deliveryLead),
                    ],
                  ),
                  const Divider(height: AppTheme.spacingXLarge),
                  _SummarySection(
                    title: 'Localisation',
                    icon: Icons.location_on,
                    children: [
                      _SummaryRow(label: 'Plan', value: formState.plan),
                      if (formState.planCoordinates != null)
                        _SummaryRow(label: 'Coordonnées (X,Y)', value: '(${formState.planCoordinates!.dx.toStringAsFixed(2)}, ${formState.planCoordinates!.dy.toStringAsFixed(2)})'),
                      _SummaryRow(label: 'Localité', value: formState.locality),
                    ],
                  ),
                  const Divider(height: AppTheme.spacingXLarge),
                  _SummarySection(
                    title: 'Intervention',
                    icon: Icons.engineering,
                    children: [
                      _SummaryRow(label: 'Corps de métier', value: formState.trade),
                      _SummaryRow(label: 'Prestataire', value: formState.provider),
                    ],
                  ),
                  if (formState.observation.isNotEmpty) ...[
                    const Divider(height: AppTheme.spacingXLarge),
                    _SummarySection(
                      title: 'Observation',
                      icon: Icons.description,
                      children: [
                        _SummaryRow(label: 'Commentaire', value: formState.observation, isLongText: true),
                      ],
                    ),
                  ],
                  if (formState.attachments.isNotEmpty) ...[
                    const Divider(height: AppTheme.spacingXLarge),
                    _SummarySection(
                      title: 'Pièces jointes',
                      icon: Icons.attach_file,
                      children: [
                        _SummaryRow(label: 'Fichiers', value: '${formState.attachments.length} fichier(s)'),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummarySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SummarySection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.primary),
            const SizedBox(width: AppTheme.spacingSmall),
            Text(title, style: AppTextStyles.bodyLarge),
          ],
        ),
        const SizedBox(height: AppTheme.spacingMedium),
        ...children,
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final dynamic value;
  final bool isLongText;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isLongText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: AppTextStyles.caption),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: isLongText ? FontWeight.normal : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  COMMON COMPONENTS
// ─────────────────────────────────────────────
class _FormCard extends StatelessWidget {
  final List<Widget> children;

  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final int currentStep;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onValidate;

  const _BottomNavigation({
    required this.currentStep,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    required this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMedium),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            onPressed: currentStep > 0 ? onPrevious : null,
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Précédent'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              if (currentStep < 4)
                ElevatedButton.icon(
                  onPressed: canGoNext ? onNext : null,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Suivant'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: AppTheme.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                )
              else
                ElevatedButton.icon(
                  onPressed: onValidate,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Valider'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    foregroundColor: AppTheme.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Alias pour la navigation vers le flux d’ajout de visite ([AddVisitFlow]).
typedef AjouterVisite = AddVisitFlow;
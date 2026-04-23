// configurations_page.dart
import 'package:flutter/material.dart';
import '../widgets/ui_components/modern_ui_components.dart';
import '../widgets/Ajouter_visite.dart' hide AppTheme;

class ConfigurationsPage extends StatefulWidget {
  const ConfigurationsPage({super.key});

  @override
  State<ConfigurationsPage> createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  // Configuration state variables
  bool _isProductionModeEnabled = true;
  bool _isLegalVerificationEnabled = false;
  bool _isBusinessSubBodyEnabled = false;
  
  // Numeric value for date range (default: 88)
  int _defaultDateRange = 88;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      appBar: AppBar(
        title: const Text(
          'Paramètres de configuration',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.cardBackground,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        children: [
          // Card 1: Production Mode
          ModernCard(
            child: _buildSwitchTile(
              title: 'Activer le mode production',
              value: _isProductionModeEnabled,
              onChanged: (value) {
                setState(() {
                  _isProductionModeEnabled = value;
                });
              },
              icon: Icons.factory,
              description: 'Active les fonctionnalités de production complètes',
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingLarge),
          
          // Card 2: Legal Verification
          ModernCard(
            child: _buildSwitchTile(
              title: 'Vérification juridique des réclamations',
              value: _isLegalVerificationEnabled,
              onChanged: (value) {
                setState(() {
                  _isLegalVerificationEnabled = value;
                });
              },
              icon: Icons.gavel,
              description: 'Vérification automatique des aspects juridiques',
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingLarge),
          
          // Card 3: Business Sub-body
          ModernCard(
            child: _buildSwitchTile(
              title: 'Activer le sous-régime de surveillance',
              value: _isBusinessSubBodyEnabled,
              onChanged: (value) {
                setState(() {
                  _isBusinessSubBodyEnabled = value;
                });
              },
              icon: Icons.business_center,
              description: 'Active les sous-structures de surveillance spécifiques',
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingLarge),
          
          // Card 4: Date Range
          ModernCard(
            child: _buildNumericTile(
              title: 'Plage de dates par défaut des filtres',
              value: _defaultDateRange,
              onChanged: (newValue) {
                setState(() {
                  _defaultDateRange = newValue;
                });
              },
              icon: Icons.calendar_today,
            ),
          ),
          
         
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddVisitFlow()),
            );
          },
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 34),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Reusable Switch Tile Widget
  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    String? description,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.all(12),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: description != null
          ? Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            )
          : null,
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryBlue,
      activeTrackColor: AppTheme.primaryBlue.withOpacity(0.3),
      inactiveThumbColor: AppTheme.textMuted,
      inactiveTrackColor: AppTheme.border,
      secondary: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryBlue,
          size: 24,
        ),
      ),
    );
  }

  // Numeric Tile with modern styling
  Widget _buildNumericTile({
    required String title,
    required int value,
    required Function(int) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMedium),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLarge),
          
          // Numeric input with modern style
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.primaryBlue,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
            ),
            child: Row(
              children: [
                // Number on the left
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      value.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
                
                // Vertical divider
                Container(
                  width: 1,
                  height: 32,
                  color: AppTheme.primaryBlue.withOpacity(0.3),
                ),
                
                // Up/Down arrows
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        if (value < 999) {
                          onChanged(value + 1);
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 22,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: 20,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (value > 0) {
                          onChanged(value - 1);
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 22,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: 20,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
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
}
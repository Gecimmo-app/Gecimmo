// configurations_page.dart
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Paramètres de configuration',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card 1: Production Mode
          _buildSwitchCard(
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
          
          const SizedBox(height: 16),
          
          // Card 2: Legal Verification
          _buildSwitchCard(
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
          
          const SizedBox(height: 16),
          
          // Card 3: Business Sub-body
          _buildSwitchCard(
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
          
          const SizedBox(height: 16),
          
          // Card 4: Date Range - Same style as other cards
          _buildNumericCardSameStyle(
            title: 'Plage de dates par défaut des filtres',
            value: _defaultDateRange,
            onChanged: (newValue) {
              setState(() {
                _defaultDateRange = newValue;
              });
            },
            icon: Icons.calendar_today,
          ),
          
         
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Empty - nothing happens
        },
        child: const Icon(Icons.add, size: 28),
        backgroundColor: const Color(0xFF1E40AF),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Reusable Switch Card Widget
  Widget _buildSwitchCard({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    String? description,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: SwitchListTile(
          contentPadding: const EdgeInsets.all(12),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          subtitle: description != null
              ? Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                )
              : null,
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF1E40AF),
          activeTrackColor: const Color(0xFF1E40AF).withOpacity(0.3),
          inactiveThumbColor: Colors.grey[400],
          inactiveTrackColor: Colors.grey[200],
          secondary: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1E40AF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF1E40AF),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  // Numeric Card with SAME STYLE as switch cards
  Widget _buildNumericCardSameStyle({
    required String title,
    required int value,
    required Function(int) onChanged,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title (same as switch cards)
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E40AF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF1E40AF),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Numeric input with web style
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF1E40AF),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
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
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  
                  // Vertical divider
                  Container(
                    width: 1,
                    height: 32,
                    color: const Color(0xFF1E40AF).withOpacity(0.3),
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
                            color: Color(0xFF1E40AF),
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
                            color: Color(0xFF1E40AF),
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
      ),
    );
  }
}
import 'package:flutter/material.dart';

class AjouterPrestataireScreen extends StatefulWidget {
  final Map<String, String>? prestataire;

  const AjouterPrestataireScreen({Key? key, this.prestataire}) : super(key: key);

  @override
  State<AjouterPrestataireScreen> createState() => _AjouterPrestataireScreenState();
}

class _AjouterPrestataireScreenState extends State<AjouterPrestataireScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _sendEmail = true;

  @override
  Widget build(BuildContext context) {
    final bool isEditMode = widget.prestataire != null;

    if (isEditMode) {
      return _buildEditView(context);
    }
    return _buildAddView(context);
  }

  // ==========================================
  // VUE 1 : MODIFICATION (Style Unique Vercel/Stripe - Sans Carte)
  // ==========================================
  Widget _buildEditView(BuildContext context) {
    const Color bgColor = Color(0xFFEFF6FF); // Bleu très clair standard
    return Scaffold(
      backgroundColor: bgColor, 
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Modifier le prestataire',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800 ? MediaQuery.of(context).size.width * 0.15 : 24.0,
            vertical: 24.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔵 Header Page Edit (Responsive)
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isCompact = constraints.maxWidth < 600;
                    
                    Widget profileInfo = Row(
                      children: [
                        CircleAvatar(
                          radius: isCompact ? 28 : 36,
                          backgroundColor: const Color(0xFFEFF6FF),
                          child: Text(
                            widget.prestataire!['nom']!.substring(0, 1).toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.w800, color: const Color(0xFF2563EB), fontSize: isCompact ? 24 : 28),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Paramètres du profil',
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.prestataire!['nom']!,
                                style: TextStyle(
                                  fontSize: isCompact ? 22 : 28, // Taille adaptée
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );

                    if (isCompact) {
                      return profileInfo;
                    } else {
                      return profileInfo;
                    }
                  },
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFE2E8F0), thickness: 1, height: 1),
                const SizedBox(height: 24),

                // 🔵 Section : Informations Générales (Split Layout)
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 700;
                    Widget textInfo = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Informations générales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                        SizedBox(height: 8),
                        Text('Mettez à jour l\'identité et les coordonnées de ce prestataire.', style: TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.5)),
                      ],
                    );

                    Widget formFields = Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildFlatField('Nom de l\'entreprise', widget.prestataire!['nom'])),
                            const SizedBox(width: 24),
                            Expanded(child: _buildFlatField('ICE', widget.prestataire!['ice'])),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(child: _buildFlatField('Raison Sociale', widget.prestataire!['raisonSociale'])),
                            const SizedBox(width: 24),
                            Expanded(child: _buildFlatField('Adresse Email', widget.prestataire!['email'])),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildFlatField('Adresse complète', widget.prestataire!['adresse']),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                               // Action enregistrer
                               Navigator.pop(context);
                            },
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text('Enregistrer les modifications'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E40AF), // Couleur principale
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    );

                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 1, child: textInfo),
                          const SizedBox(width: 64),
                          Expanded(flex: 2, child: formFields),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textInfo,
                          const SizedBox(height: 32),
                          formFields,
                        ],
                      );
                    }
                  },
                ),


                const SizedBox(height: 100), // padding bas
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // VUE 2 : AJOUT (Même style élégant que la modification)
  // ==========================================
  Widget _buildAddView(BuildContext context) {
    const Color bgColor = Color(0xFFEFF6FF); // Bleu très clair standard

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Ajouter un prestataire',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 800 ? MediaQuery.of(context).size.width * 0.15 : 24.0,
            vertical: 40.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔵 Header Page Add
                const Text(
                  'Nouveau prestataire',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ajoutez une nouvelle agence ou un nouveau prestataire à votre réseau.',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
                ),
                
                const SizedBox(height: 32),
                const Divider(color: Color(0xFFE2E8F0), thickness: 1, height: 1),
                const SizedBox(height: 24),

                // 🔵 Section : Informations Générales (Split Layout)
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 700;
                    Widget textInfo = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Informations générales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                        SizedBox(height: 8),
                        Text('Renseignez l\'identité et les coordonnées complètes.', style: TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.5)),
                      ],
                    );

                    Widget formFields = Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildFlatField('Nom de l\'entreprise', null)),
                            const SizedBox(width: 24),
                            Expanded(child: _buildFlatField('ICE', null)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(child: _buildFlatField('Raison Sociale', null)),
                            const SizedBox(width: 24),
                            Expanded(child: _buildFlatField('Adresse Email', null)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildFlatField('Adresse complète', null),
                      ],
                    );

                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 1, child: textInfo),
                          const SizedBox(width: 64),
                          Expanded(flex: 2, child: formFields),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textInfo,
                          const SizedBox(height: 32),
                          formFields,
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 24),
                const Divider(color: Color(0xFFE2E8F0), thickness: 1, height: 1),
                const SizedBox(height: 24),

                // 🔵 Section : Accès & Sécurité
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 700;
                    Widget textInfo = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Accès & Sécurité', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                        SizedBox(height: 8),
                        Text('Définissez comment ce prestataire accèdera à la plateforme.', style: TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.5)),
                      ],
                    );

                    Widget actions = Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFEFF6FF)), 
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.mail_outline_rounded, color: Color(0xFF2563EB), size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Envoyer un email de réinitialisation', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A), fontSize: 15)),
                                const SizedBox(height: 6),
                                const Text(
                                  'Si activé, un lien sécurisé sera envoyé pour qu\'il définisse son premier mot de passe.',
                                  style: TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.4),
                                ),
                                const SizedBox(height: 16),
                                Switch(
                                  value: _sendEmail,
                                  activeColor: Colors.white,
                                  activeTrackColor: const Color(0xFF2563EB),
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: const Color(0xFFCBD5E1),
                                  onChanged: (val) => setState(() => _sendEmail = val),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );

                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 1, child: textInfo),
                          const SizedBox(width: 64),
                          Expanded(flex: 2, child: actions),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textInfo,
                          const SizedBox(height: 32),
                          actions,
                        ],
                      );
                    }
                  },
                ),

                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Enregistrer le prestataire'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Composant de champ HORS CARTE (Design Flat Pro Modification)
  Widget _buildFlatField(String label, String? initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          style: const TextStyle(fontSize: 15, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
            filled: true,
            fillColor: const Color(0xFFEFF6FF), // Fond gris très subtil
          ),
        ),
      ],
    );
  }
}

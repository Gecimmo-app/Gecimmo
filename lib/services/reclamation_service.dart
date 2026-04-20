// lib/services/reclamation_service.dart
import 'package:flutter/material.dart';
import 'api_service.dart';

// ─────────────────────────────────────────────
//  Modèle Reclamation
// ─────────────────────────────────────────────
class Reclamation {
  final String id;
  final String nom;
  final String tel;
  final String description;
  final String priorite;
  final String statut;
  final String type;
  final String sousType;
  final String observation;
  final String date;
  final String? projetId;
  final String? projetNom;

  Reclamation({
    required this.id,
    required this.nom,
    required this.tel,
    required this.description,
    required this.priorite,
    required this.statut,
    required this.type,
    required this.sousType,
    required this.observation,
    required this.date,
    this.projetId,
    this.projetNom,
  });

  /// Convertit la priorité API → couleur Flutter
  Color get prioriteColor {
    switch (priorite.toLowerCase()) {
      case 'haute':
      case 'high':
        return const Color(0xFFEF4444);
      case 'moyenne':
      case 'medium':
        return const Color(0xFFF97316);
      case 'basse':
      case 'low':
        return const Color(0xFF22C55E);
      default:
        return const Color(0xFF9CA3AF);
    }
  }

  /// Convertit le statut API → couleur de badge
  Color get statutColor {
    switch (statut.toLowerCase()) {
      case 'nouveau':
      case 'new':
        return const Color(0xFFBFDBFE);
      case 'en cours':
      case 'inprogress':
        return const Color(0xFFFDE68A);
      case 'résolu':
      case 'resolved':
        return const Color(0xFFBBF7D0);
      case 'rejeté':
      case 'rejected':
        return const Color(0xFFFECACA);
      default:
        return const Color(0xFFE5E7EB);
    }
  }

  Color get statutTextColor {
    switch (statut.toLowerCase()) {
      case 'nouveau':
      case 'new':
        return const Color(0xFF1D4ED8);
      case 'en cours':
      case 'inprogress':
        return const Color(0xFF92400E);
      case 'résolu':
      case 'resolved':
        return const Color(0xFF166534);
      case 'rejeté':
      case 'rejected':
        return const Color(0xFF991B1B);
      default:
        return const Color(0xFF374151);
    }
  }

  /// Convertit en Map pour l'UI (rétro-compatible avec l'ancienne page)
  Map<String, dynamic> toUiMap() => {
        'id': id,
        'nom': nom,
        'tel': tel,
        'description': description,
        'priorite': priorite,
        'prioriteColor': prioriteColor,
        'date': date,
        'statut': statut,
        'statutColor': statutColor,
        'statutTextColor': statutTextColor,
        'type': type,
        'sousType': sousType,
        'observation': observation,
        'projetId': projetId,
        'projetNom': projetNom,
      };

  /// Depuis la réponse JSON de l'API
  factory Reclamation.fromJson(Map<String, dynamic> json) {
    return Reclamation(
      id: (json['id'] ?? '').toString(),
      nom: json['clientName'] ??
          json['nom'] ??
          '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(),
      tel: json['clientPhone'] ?? json['tel'] ?? json['phone'] ?? '',
      description: json['description'] ?? json['subject'] ?? '',
      priorite: _mapPriorite(json['priority'] ?? json['priorite'] ?? ''),
      statut: _mapStatut(json['state'] ?? json['statut'] ?? json['status'] ?? ''),
      type: json['type'] ?? json['category'] ?? '',
      sousType: json['subType'] ?? json['sousType'] ?? json['subCategory'] ?? '',
      observation: json['observation'] ?? json['notes'] ?? json['description'] ?? '',
      date: _parseDate(json['createdAt'] ?? json['date'] ?? ''),
      projetId: (json['projectId'] ?? json['projetId'])?.toString(),
      projetNom: json['projectName'] ?? json['projetNom'],
    );
  }

  /// Corps JSON pour la création/modification
  Map<String, dynamic> toJson() => {
        'clientName': nom,
        'clientPhone': tel,
        'description': description,
        'priority': priorite,
        'state': statut,
        'type': type,
        'subType': sousType,
        'observation': observation,
        if (projetId != null) 'projectId': projetId,
      };

  // ── helpers privés ──────────────────────────
  static String _mapPriorite(dynamic raw) {
    final s = raw.toString().toLowerCase();
    if (s == 'high' || s == '3') return 'Haute';
    if (s == 'medium' || s == '2') return 'Moyenne';
    if (s == 'low' || s == '1') return 'Basse';
    return raw.toString();
  }

  static String _mapStatut(dynamic raw) {
    final s = raw.toString().toLowerCase();
    if (s == 'new' || s == '0') return 'Nouveau';
    if (s == 'inprogress' || s == '1') return 'En cours';
    if (s == 'resolved' || s == '2') return 'Résolu';
    if (s == 'rejected' || s == '3') return 'Rejeté';
    return raw.toString();
  }

  static String _parseDate(dynamic raw) {
    if (raw == null || raw.toString().isEmpty) return '';
    try {
      final dt = DateTime.parse(raw.toString());
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return raw.toString();
    }
  }
}

// ─────────────────────────────────────────────
//  ReclamationService
// ─────────────────────────────────────────────
class ReclamationService {
  // ── Endpoints ─────────────────────────────
  static const String _base = '/api/Reclamations';

  // ──────────────────────────────────────────
  // GET /api/Reclamations/list
  // Récupère la liste paginée des réclamations
  // ──────────────────────────────────────────
  static Future<List<Reclamation>> getList({
    int page = 1,
    int pageSize = 20,
    String? statut,
    String? type,
    String? search,
    DateTime? dateDebut,
    DateTime? dateFin,
  }) async {
    final params = <String, String>{
      'Page': page.toString(),
      'PageSize': pageSize.toString(),
      if (statut != null && statut != 'Tous') 'State': statut,
      if (type != null && type != 'Tous') 'Type': type,
      if (search != null && search.isNotEmpty) 'Search': search,
      if (dateDebut != null) 'StartDate': dateDebut.toIso8601String(),
      if (dateFin != null) 'EndDate': dateFin.toIso8601String(),
    };

    final query = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    final endpoint = '$_base/list?$query';

    final data = await ApiService.get(endpoint);

    // L'API peut renvoyer { items: [...] } ou directement [...]
    final List<dynamic> items = data is List
        ? data
        : (data['items'] ?? data['data'] ?? data['reclamations'] ?? []);

    return items
        .map((e) => Reclamation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ──────────────────────────────────────────
  // GET /api/Reclamations/{id}
  // Récupère le détail d'une réclamation
  // ──────────────────────────────────────────
  static Future<Reclamation> getById(String id) async {
    final data = await ApiService.get('$_base/$id');
    return Reclamation.fromJson(data as Map<String, dynamic>);
  }

  // ──────────────────────────────────────────
  // POST /api/Reclamations/create
  // Crée une nouvelle réclamation
  // ──────────────────────────────────────────
  static Future<Reclamation> create({
    required String nom,
    required String tel,
    required String description,
    required String priorite,
    required String type,
    String sousType = '',
    String observation = '',
    String? projetId,
  }) async {
    final body = {
      'clientName': nom,
      'clientPhone': tel,
      'description': description,
      'priority': priorite,
      'type': type,
      'subType': sousType,
      'observation': observation,
      if (projetId != null) 'projectId': projetId,
    };

    final data = await ApiService.post('$_base/create', body);
    return Reclamation.fromJson(data as Map<String, dynamic>);
  }

  // ──────────────────────────────────────────
  // PUT /api/Reclamations/{id}
  // Modifie une réclamation existante
  // ──────────────────────────────────────────
  static Future<Reclamation> update(String id, Map<String, dynamic> fields) async {
    final data = await ApiService.put('$_base/$id', fields);
    return Reclamation.fromJson(data as Map<String, dynamic>);
  }

  // ──────────────────────────────────────────
  // DELETE /api/Reclamations/{id}
  // Supprime une réclamation
  // ──────────────────────────────────────────
  static Future<void> delete(String id) async {
    await ApiService.delete('$_base/$id');
  }

  // ──────────────────────────────────────────
  // PATCH /api/Reclamations/{id}/state
  // Change uniquement l'état d'une réclamation
  // ──────────────────────────────────────────
  static Future<void> updateState(String id, String newState) async {
    await ApiService.patch('$_base/$id/state', {'state': newState});
  }

  // ──────────────────────────────────────────
  // POST /api/Reclamations/{id}/notes
  // Ajoute une note à une réclamation
  // ──────────────────────────────────────────
  static Future<void> addNote(String id, String note) async {
    await ApiService.post('$_base/$id/notes', {'content': note});
  }

  // ──────────────────────────────────────────
  // GET /api/Reclamations/{id}/attachments
  // Récupère les pièces jointes
  // ──────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getAttachments(String id) async {
    final data = await ApiService.get('$_base/$id/attachments');
    final List<dynamic> items = data is List ? data : (data['items'] ?? []);
    return items.cast<Map<String, dynamic>>();
  }

  // ──────────────────────────────────────────
  // GET /api/Reclamations/{id}/attachments/{attachmentId}
  // Récupère une pièce jointe spécifique
  // ──────────────────────────────────────────
  static Future<Map<String, dynamic>> getAttachment(
      String id, String attachmentId) async {
    final data =
        await ApiService.get('$_base/$id/attachments/$attachmentId');
    return data as Map<String, dynamic>;
  }

  // ──────────────────────────────────────────
  // GET /api/Reclamations/lead-by-phone
  // Cherche un lead par numéro de téléphone
  // ──────────────────────────────────────────
  static Future<Map<String, dynamic>?> getLeadByPhone(String phone) async {
    try {
      final data = await ApiService.get(
          '$_base/lead-by-phone?phone=${Uri.encodeComponent(phone)}');
      return data as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  // ──────────────────────────────────────────
  // GET /api/Reclamations/reserved-biens-by-type
  // Récupère les biens réservés par type
  // ──────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getReservedBiensByType(
      String type) async {
    final data = await ApiService.get(
        '$_base/reserved-biens-by-type?type=${Uri.encodeComponent(type)}');
    final List<dynamic> items = data is List ? data : (data['items'] ?? []);
    return items.cast<Map<String, dynamic>>();
  }
}

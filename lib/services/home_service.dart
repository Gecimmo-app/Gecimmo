// lib/services/home_service.dart
import 'api_service.dart';

class HomeAction {
  final String title;
  final String date;

  HomeAction({required this.title, required this.date});

  factory HomeAction.fromJson(Map<String, dynamic> json) {
    return HomeAction(
      title: json['title'] ?? json['subject'] ?? '',
      date: _parseDate(json['date'] ?? json['dueDate'] ?? ''),
    );
  }

  static String _parseDate(String raw) {
    if (raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw).toLocal();
      final dateStr = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
      final timeStr = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      return '$dateStr à $timeStr';
    } catch (_) {
      return raw;
    }
  }
}

class HomeData {
  final int rdvAujourdhui;
  final int aRappeler;
  final int nouveauxLeads;
  final List<HomeAction> actionsDepassees;

  HomeData({
    required this.rdvAujourdhui,
    required this.aRappeler,
    required this.nouveauxLeads,
    required this.actionsDepassees,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    final actions =
        (json['actionsDepassees'] as List? ?? json['actions'] as List? ?? [])
            .map((e) => HomeAction.fromJson(e as Map<String, dynamic>))
            .toList();

    return HomeData(
      rdvAujourdhui:
          json['rdvAujourdhui'] ?? json['rdvCount'] ?? json['rdv'] ?? 0,
      aRappeler:
          json['aRappeler'] ?? json['recallCount'] ?? json['recalls'] ?? 0,
      nouveauxLeads:
          json['nouveauxLeads'] ?? json['newLeadsCount'] ?? json['leads'] ?? 0,
      actionsDepassees: actions,
    );
  }

  // Données vides en cas d'erreur réseau
  factory HomeData.empty() {
    return HomeData(
      rdvAujourdhui: 0,
      aRappeler: 0,
      nouveauxLeads: 0,
      actionsDepassees: [],
    );
  }
}

class HomeService {
  static const String _endpoint = '/api/Home';

  static Future<HomeData> getHomeData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Paramètres en minuscules pour correspondre à l'API
    final startStr = startDate.toIso8601String().split('T')[0];
    final endStr = endDate.toIso8601String().split('T')[0];

    try {
      final data = await ApiService.get(
        '$_endpoint?startDate=$startStr&endDate=$endStr',
      );
      return HomeData.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      final errorStr = e.toString();

      // Erreur CORS / réseau sur Flutter Web
      if (errorStr.contains('Failed to fetch') ||
          errorStr.contains('ClientException') ||
          errorStr.contains('XMLHttpRequest')) {
        throw Exception(
          'Impossible de contacter le serveur.\n'
          'Vérifiez votre connexion ou lancez avec :\n'
          'flutter run -d chrome --web-browser-flag "--disable-web-security"',
        );
      }

      rethrow;
    }
  }
}
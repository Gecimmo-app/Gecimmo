import 'package:flutter/material.dart';

class AppTheme {
  // ── Green primary palette ──────────────────────
  static const Color primary       = Color(0xFF16A34A); // green-600
  static const Color primaryLight  = Color(0xFFDCFCE7); // green-100
  static const Color primaryDark   = Color(0xFF15803D); // green-700
  static const Color primaryMid    = Color(0xFF22C55E); // green-500
  static const Color green = Colors.green;

  // ── Accent colors (kept minimal) ──────────────
  static const Color purple        = Color(0xFF7C3AED);
  static const Color purpleLight   = Color(0xFFF5F3FF);
  static const Color orange        = Color(0xFFEA580C);
  static const Color orangeLight   = Color(0xFFFFF7ED);
  static const Color red           = Color(0xFFDC2626);
  static const Color redLight      = Color(0xFFFEF2F2);
  static const Color teal          = Color(0xFF0D9488);
  static const Color slate         = Color(0xFF64748B);

  // ── Neutrals ──────────────────────────────────
  static const Color background    = Color(0xFFF0FDF4); // green tinted bg
  static const Color cardBorder    = Color(0xFFD1FAE5); // green-100 border
  static const Color textPrimary   = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint      = Color(0xFF9CA3AF);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Color(0x0F000000),
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: textPrimary, fontWeight: FontWeight.w700,
        fontSize: 20, fontFamily: 'Roboto',
      ),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    cardTheme: const CardThemeData(
      elevation: 0, color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: cardBorder),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: Color(0xFFF9FAFB),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: cardBorder)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: cardBorder)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: primary, width: 1.5)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary, foregroundColor: Colors.white,
        elevation: 0, padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimary, padding: EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: cardBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
    ),
  );
}
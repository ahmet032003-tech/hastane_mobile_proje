import 'package:flutter/material.dart';

/// MedAuto uygulaması için koyu tema renk paleti
class AppColors {
  AppColors._();

  // Arka Plan Renkleri (Medical Dark Palette)
  static const Color background = Color(0xFF0A0F1D);
  static const Color surface = Color(0xFF162032);
  static const Color surfaceSecondary = Color(0xFF1E293B);
  static const Color card = Color(0xFF1E293B);
  static const Color border = Color(0xFF334155);
  static const Color borderFocused = Color(0xFF0EA5E9);

  // Vurgu ve Medikal Marka Renkleri
  static const Color primary = Color(0xFF0EA5E9); // Medikal Camgöbeği
  static const Color primaryLight = Color(0xFF38BDF8);
  static const Color primaryDark = Color(0xFF0284C7);
  static const Color secondary = Color(0xFF06B6D4);
  static const Color accentTeal = Color(0xFF10B981);

  // Acil Şifa Hastanesi Kızıl Haç Renkleri
  static const Color redCross = Color(0xFFE11D48); // Kızıl Haç Kırmızısı
  static const Color redCrossLight = Color(0xFFFB7185);
  static const Color redCrossBg = Color(0x20E11D48);
  static const Color trustNavy = Color(0xFF0F2B48); // Güven Verici Hastane Mavisi

  // Metin Renkleri
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Durum Renkleri
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0x20EF4444);
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0x2010B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF0EA5E9);

  // Gradientler
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0EA5E9),
      Color(0xFF06B6D4),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E293B),
      Color(0xFF162032),
    ],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF0EA5E9),
      Color(0xFF14B8A6),
    ],
  );
}

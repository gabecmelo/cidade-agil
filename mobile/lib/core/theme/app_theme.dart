import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Extensão com tokens fora do ColorScheme padrão (status, neutros, accent)
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.accent,
    required this.n50,
    required this.n100,
    required this.n300,
    required this.n500,
    required this.n700,
    required this.n900,
    required this.success,
    required this.successTint,
    required this.warning,
    required this.warningTint,
    required this.info,
    required this.infoTint,
    required this.statusRecebidaFg,
    required this.statusRecebidaBg,
    required this.statusAnalFg,
    required this.statusAnalBg,
    required this.statusAtendFg,
    required this.statusAtendBg,
    required this.statusResolFg,
    required this.statusResolBg,
  });

  final Color accent;
  final Color n50;
  final Color n100;
  final Color n300;
  final Color n500;
  final Color n700;
  final Color n900;
  final Color success;
  final Color successTint;
  final Color warning;
  final Color warningTint;
  final Color info;
  final Color infoTint;
  final Color statusRecebidaFg;
  final Color statusRecebidaBg;
  final Color statusAnalFg;
  final Color statusAnalBg;
  final Color statusAtendFg;
  final Color statusAtendBg;
  final Color statusResolFg;
  final Color statusResolBg;

  @override
  AppColors copyWith({
    Color? accent,
    Color? n50,
    Color? n100,
    Color? n300,
    Color? n500,
    Color? n700,
    Color? n900,
    Color? success,
    Color? successTint,
    Color? warning,
    Color? warningTint,
    Color? info,
    Color? infoTint,
    Color? statusRecebidaFg,
    Color? statusRecebidaBg,
    Color? statusAnalFg,
    Color? statusAnalBg,
    Color? statusAtendFg,
    Color? statusAtendBg,
    Color? statusResolFg,
    Color? statusResolBg,
  }) =>
      AppColors(
        accent: accent ?? this.accent,
        n50: n50 ?? this.n50,
        n100: n100 ?? this.n100,
        n300: n300 ?? this.n300,
        n500: n500 ?? this.n500,
        n700: n700 ?? this.n700,
        n900: n900 ?? this.n900,
        success: success ?? this.success,
        successTint: successTint ?? this.successTint,
        warning: warning ?? this.warning,
        warningTint: warningTint ?? this.warningTint,
        info: info ?? this.info,
        infoTint: infoTint ?? this.infoTint,
        statusRecebidaFg: statusRecebidaFg ?? this.statusRecebidaFg,
        statusRecebidaBg: statusRecebidaBg ?? this.statusRecebidaBg,
        statusAnalFg: statusAnalFg ?? this.statusAnalFg,
        statusAnalBg: statusAnalBg ?? this.statusAnalBg,
        statusAtendFg: statusAtendFg ?? this.statusAtendFg,
        statusAtendBg: statusAtendBg ?? this.statusAtendBg,
        statusResolFg: statusResolFg ?? this.statusResolFg,
        statusResolBg: statusResolBg ?? this.statusResolBg,
      );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      accent: Color.lerp(accent, other.accent, t)!,
      n50: Color.lerp(n50, other.n50, t)!,
      n100: Color.lerp(n100, other.n100, t)!,
      n300: Color.lerp(n300, other.n300, t)!,
      n500: Color.lerp(n500, other.n500, t)!,
      n700: Color.lerp(n700, other.n700, t)!,
      n900: Color.lerp(n900, other.n900, t)!,
      success: Color.lerp(success, other.success, t)!,
      successTint: Color.lerp(successTint, other.successTint, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningTint: Color.lerp(warningTint, other.warningTint, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoTint: Color.lerp(infoTint, other.infoTint, t)!,
      statusRecebidaFg: Color.lerp(statusRecebidaFg, other.statusRecebidaFg, t)!,
      statusRecebidaBg: Color.lerp(statusRecebidaBg, other.statusRecebidaBg, t)!,
      statusAnalFg: Color.lerp(statusAnalFg, other.statusAnalFg, t)!,
      statusAnalBg: Color.lerp(statusAnalBg, other.statusAnalBg, t)!,
      statusAtendFg: Color.lerp(statusAtendFg, other.statusAtendFg, t)!,
      statusAtendBg: Color.lerp(statusAtendBg, other.statusAtendBg, t)!,
      statusResolFg: Color.lerp(statusResolFg, other.statusResolFg, t)!,
      statusResolBg: Color.lerp(statusResolBg, other.statusResolBg, t)!,
    );
  }

  // Tokens diretos do CSS hi-fi (hifi-styles.css)
  static const AppColors light = AppColors(
    accent: Color(0xFF3B82F6),        // --a-600
    n50: Color(0xFFF7F8FB),           // --n-50
    n100: Color(0xFFEEF1F5),          // --n-100
    n300: Color(0xFFCBD2DC),          // --n-300
    n500: Color(0xFF6B7383),          // --n-500
    n700: Color(0xFF384151),          // --n-700
    n900: Color(0xFF0E1726),          // --n-900
    success: Color(0xFF16A34A),       // --suc
    successTint: Color(0xFFDCFCE7),   // --suc-t
    warning: Color(0xFFB45309),       // --war
    warningTint: Color(0xFFFEF3C7),   // --war-t
    info: Color(0xFF0369A1),          // --inf
    infoTint: Color(0xFFE0F2FE),      // --inf-t
    statusRecebidaFg: Color(0xFF4B5563),  // --st-receb
    statusRecebidaBg: Color(0xFFE5E7EB),  // --st-receb-t
    statusAnalFg: Color(0xFFB45309),      // --st-anal
    statusAnalBg: Color(0xFFFEF3C7),      // --st-anal-t
    statusAtendFg: Color(0xFF1D4ED8),     // --st-atend
    statusAtendBg: Color(0xFFDBEAFE),     // --st-atend-t
    statusResolFg: Color(0xFF15803D),     // --st-resol
    statusResolBg: Color(0xFFDCFCE7),     // --st-resol-t
  );
}

class AppTheme {
  static const Color _primary = Color(0xFF1E3A8A);    // --p-600
  static const Color _primary700 = Color(0xFF13306E); // --p-700
  static const Color _primary50 = Color(0xFFEEF2FB);  // --p-50

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primary,
        primary: _primary,
        onPrimary: Colors.white,
        secondary: const Color(0xFF3B82F6),
        error: const Color(0xFFB91C1C),
        surface: Colors.white,
        onSurface: const Color(0xFF0E1726),
      ),
      extensions: const [AppColors.light],
    );

    return base.copyWith(
      textTheme: GoogleFonts.robotoTextTheme(base.textTheme).copyWith(
        // Display — usado no logo, protocolo
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 28, fontWeight: FontWeight.w800, height: 1.0,
          color: const Color(0xFF0E1726),
        ),
        // Title — AppBar, card title
        titleLarge: GoogleFonts.roboto(
          fontSize: 18, fontWeight: FontWeight.w700, height: 1.1,
          color: const Color(0xFF0E1726),
        ),
        titleMedium: GoogleFonts.roboto(
          fontSize: 16, fontWeight: FontWeight.w700, height: 1.2,
          color: const Color(0xFF0E1726),
        ),
        // Body
        bodyLarge: GoogleFonts.roboto(
          fontSize: 15, fontWeight: FontWeight.w400, height: 1.5,
          color: const Color(0xFF384151),
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14, fontWeight: FontWeight.w400, height: 1.5,
          color: const Color(0xFF384151),
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 13, fontWeight: FontWeight.w400, height: 1.4,
          color: const Color(0xFF6B7383),
        ),
        // Caption / overline
        labelSmall: GoogleFonts.roboto(
          fontSize: 11, fontWeight: FontWeight.w600, height: 1.0,
          letterSpacing: 0.08,
          color: const Color(0xFF6B7383),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0E1726),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 18, fontWeight: FontWeight.w700,
          color: const Color(0xFF0E1726),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFEEF1F5)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primary700,
          side: const BorderSide(color: Color(0xFFDCE5F8)),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primary,
          textStyle: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCBD2DC), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCBD2DC), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB91C1C), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFB91C1C), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        labelStyle: GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF384151)),
        hintStyle: GoogleFonts.roboto(fontSize: 15, color: const Color(0xFF6B7383)),
      ),
      scaffoldBackgroundColor: Colors.white,
      dividerColor: const Color(0xFFEEF1F5),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  // Atalho para pegar a extensão no contexto
  static AppColors colors(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  static const Color primary = _primary;
  static const Color primary50 = _primary50;
  static const Color primary700 = _primary700;
}

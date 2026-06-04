import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Web dashboard theme — the shared blue palette (same as the resident app)
/// tuned for a desktop browser: compact buttons and standard visual density.
/// Used by both the admin and owner panels so they look identical.
class DashboardTheme {
  const DashboardTheme._();

  static ThemeData get theme {
    final base = AppTheme.lightTheme;
    return base.copyWith(
      visualDensity: VisualDensity.standard,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

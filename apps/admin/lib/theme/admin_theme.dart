import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:society_core/society_core.dart';

/// Admin web dashboard theme.
///
/// Reuses the shared blue palette from `society_core` (so the resident app and
/// the admin panel look identical) but tuned for a desktop browser: compact
/// buttons and standard visual density instead of mobile touch sizing.
class AdminTheme {
  const AdminTheme._();

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

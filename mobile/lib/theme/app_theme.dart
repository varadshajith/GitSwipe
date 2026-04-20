/// GitSwipe Design System — Theme & Color Tokens
///
/// Extracted from the Stitch "Kinetic Developer Persona" design system.
/// Dark theme, glassmorphism, tonal layering, no-line rule.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Color Tokens ────────────────────────────────────────────────────────────

class AppColors {
  AppColors._();

  // Surfaces – "stacked sheets of obsidian glass"
  static const Color background = Color(0xFF10141a);
  static const Color surfaceDim = Color(0xFF10141a);
  static const Color surfaceContainerLowest = Color(0xFF0a0e14);
  static const Color surfaceContainerLow = Color(0xFF181c22);
  static const Color surfaceContainer = Color(0xFF1c2026);
  static const Color surfaceContainerHigh = Color(0xFF262a31);
  static const Color surfaceContainerHighest = Color(0xFF31353c);
  static const Color surfaceBright = Color(0xFF353940);
  static const Color surfaceVariant = Color(0xFF31353c);

  // Primary (Blue accent)
  static const Color primary = Color(0xFFafc6ff);
  static const Color primaryContainer = Color(0xFF1f6feb);
  static const Color primaryFixed = Color(0xFFd9e2ff);
  static const Color primaryFixedDim = Color(0xFFafc6ff);
  static const Color onPrimary = Color(0xFF002d6d);
  static const Color onPrimaryContainer = Color(0xFFfffcff);

  // Secondary (Green – action/success)
  static const Color secondary = Color(0xFF7bdb80);
  static const Color secondaryContainer = Color(0xFF007124);
  static const Color onSecondary = Color(0xFF00390e);
  static const Color onSecondaryContainer = Color(0xFF91f294);

  // Tertiary (Neutral cool)
  static const Color tertiary = Color(0xFFbec7d2);
  static const Color tertiaryContainer = Color(0xFF6d7680);

  // Text
  static const Color onSurface = Color(0xFFdfe2eb);
  static const Color onSurfaceVariant = Color(0xFFc2c6d6);
  static const Color inverseSurface = Color(0xFFdfe2eb);
  static const Color inverseOnSurface = Color(0xFF2d3137);

  // Outline
  static const Color outline = Color(0xFF8c90a0);
  static const Color outlineVariant = Color(0xFF424754);

  // Error
  static const Color error = Color(0xFFffb4ab);
  static const Color errorContainer = Color(0xFF93000a);
  static const Color onError = Color(0xFF690005);
}

// ─── Typography ──────────────────────────────────────────────────────────────

class AppTypography {
  AppTypography._();

  /// Display Large – repo names in swipe cards
  static TextStyle displayLarge(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02 * 56,
        color: AppColors.onSurface,
        height: 1.1,
      );

  /// Headline Large – hero text
  static TextStyle headlineLarge(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.02 * 32,
        color: AppColors.onSurface,
        height: 1.2,
      );

  /// Headline Medium
  static TextStyle headlineMedium(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.3,
      );

  /// Headline Small – section titles
  static TextStyle headlineSmall(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurface,
        height: 1.4,
      );

  /// Title Medium
  static TextStyle titleMedium(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
        height: 1.4,
      );

  /// Body Large
  static TextStyle bodyLarge(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
        height: 1.6,
      );

  /// Body Medium – standard reading text
  static TextStyle bodyMedium(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
        height: 1.6,
      );

  /// Body Small
  static TextStyle bodySmall(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
        height: 1.5,
      );

  /// Label Large – Space Grotesk for technical metadata
  static TextStyle labelLarge(BuildContext context) =>
      GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceVariant,
        letterSpacing: 0.05 * 14,
        height: 1.4,
      );

  /// Label Medium – monospace accents (forks, stars, commit hashes)
  static TextStyle labelMedium(BuildContext context) =>
      GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceVariant,
        letterSpacing: 0.05 * 12,
        height: 1.0,
      );

  /// Label Small
  static TextStyle labelSmall(BuildContext context) =>
      GoogleFonts.spaceGrotesk(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.outline,
        letterSpacing: 0.05 * 11,
        height: 1.0,
      );
}

// ─── Theme Data ──────────────────────────────────────────────────────────────

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryContainer,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryContainer,
      surface: AppColors.surfaceContainerLow,
      error: AppColors.error,
      errorContainer: AppColors.errorContainer,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurface,
      onError: AppColors.onError,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceContainerHigh,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceContainerHigh,
      labelStyle: GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurfaceVariant,
      ),
      shape: const StadiumBorder(),
      side: BorderSide.none,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.outline,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    appBarTheme: const AppBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: AppColors.onSurfaceVariant,
      size: 24,
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.transparent,
      thickness: 0,
    ),
  );
}

// ─── Glassmorphism Helpers ───────────────────────────────────────────────────

/// A frosted-glass container matching the design system.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 24,
    this.opacity = 0.7,
    this.blurSigma = 20,
    this.padding,
    this.border,
    this.color,
  });

  final Widget child;
  final double borderRadius;
  final double opacity;
  final double blurSigma;
  final EdgeInsetsGeometry? padding;
  final Border? border;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: (color ?? AppColors.surfaceContainer).withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: border ??
                Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
            // Ambient glow shadow tinted with primary at 5%
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.05),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ─── Spacing Constants ───────────────────────────────────────────────────────

class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

// ─── Animation Constants ─────────────────────────────────────────────────────

class AppAnimation {
  AppAnimation._();
  static const Duration fast = Duration(milliseconds: 100);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration entrance = Duration(milliseconds: 600);
  static const Curve defaultCurve = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve springCurve = Curves.elasticOut;
}

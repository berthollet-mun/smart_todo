import 'package:flutter/material.dart';

class ResponsiveHelper {
  ResponsiveHelper._();

  // ═══════════════════════════════════════════════════════
  // BREAKPOINTS
  // ═══════════════════════════════════════════════════════
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletBreakpoint;

  // ═══════════════════════════════════════════════════════
  // DIMENSIONS
  // ═══════════════════════════════════════════════════════
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double statusBarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static double bottomPadding(BuildContext context) =>
      MediaQuery.of(context).padding.bottom;

  static double keyboardHeight(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom;

  static bool isKeyboardOpen(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom > 0;

  // ═══════════════════════════════════════════════════════
  // PADDINGS ADAPTATIFS
  // ═══════════════════════════════════════════════════════
  static double horizontalPadding(BuildContext context) {
    if (isMobile(context)) return 16.0;
    if (isTablet(context)) return 24.0;
    return 32.0;
  }

  static EdgeInsets screenPadding(BuildContext context) {
    final h = horizontalPadding(context);
    return EdgeInsets.symmetric(horizontal: h, vertical: 16);
  }

  static EdgeInsets pagePadding(BuildContext context) {
    return EdgeInsets.only(
      left: horizontalPadding(context),
      right: horizontalPadding(context),
      top: 16,
      bottom: bottomPadding(context) + 16,
    );
  }

  // ═══════════════════════════════════════════════════════
  // GRILLE
  // ═══════════════════════════════════════════════════════
  static int gridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }

  static double gridChildAspectRatio(BuildContext context) {
    if (isMobile(context)) return 2.5;
    if (isTablet(context)) return 2.0;
    return 1.8;
  }

  // ═══════════════════════════════════════════════════════
  // TAILLES DE TEXTE ADAPTATIVES
  // ═══════════════════════════════════════════════════════
  static double titleSize(BuildContext context) {
    if (isMobile(context)) return 20.0;
    if (isTablet(context)) return 24.0;
    return 28.0;
  }

  static double subtitleSize(BuildContext context) {
    if (isMobile(context)) return 16.0;
    return 18.0;
  }

  static double bodySize(BuildContext context) {
    if (isMobile(context)) return 14.0;
    return 16.0;
  }

  static double captionSize(BuildContext context) {
    if (isMobile(context)) return 12.0;
    return 13.0;
  }

  // ═══════════════════════════════════════════════════════
  // DIMENSIONS COMPOSANTS
  // ═══════════════════════════════════════════════════════
  static double dialogWidth(BuildContext context) {
    final width = screenWidth(context);
    if (isMobile(context)) return width * 0.9;
    if (isTablet(context)) return width * 0.6;
    return 500;
  }

  static double bottomSheetMaxHeight(BuildContext context) {
    return screenHeight(context) * 0.85;
  }

  static double cardWidth(BuildContext context) {
    if (isMobile(context)) return screenWidth(context) - 32;
    if (isTablet(context)) return (screenWidth(context) - 48) / 2;
    return (screenWidth(context) - 64) / 3;
  }

  static double iconSize(BuildContext context) {
    if (isMobile(context)) return 24.0;
    return 28.0;
  }

  static double avatarRadius(BuildContext context) {
    if (isMobile(context)) return 20.0;
    if (isTablet(context)) return 24.0;
    return 28.0;
  }

  // ═══════════════════════════════════════════════════════
  // BUILDER ADAPTATIF
  // ═══════════════════════════════════════════════════════

  /// Widget builder adaptatif selon la taille d'écran
  static Widget adaptive(
    BuildContext context, {
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }
}
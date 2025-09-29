import 'package:flutter/material.dart';

class AppColors {
  // Primary colors with high contrast ratios
  static const Color primary = Color(0xFF1976D2); // Blue 700
  static const Color primaryLight = Color(0xFF42A5F5); // Blue 400
  static const Color primaryDark = Color(0xFF0D47A1); // Blue 900
  
  // Secondary colors
  static const Color secondary = Color(0xFF388E3C); // Green 700
  static const Color secondaryLight = Color(0xFF66BB6A); // Green 400
  static const Color secondaryDark = Color(0xFF1B5E20); // Green 900
  
  // Neutral colors with proper contrast
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color surface = Color(0xFFF5F5F5); // Grey 100
  static const Color surfaceVariant = Color(0xFFE0E0E0); // Grey 300
  
  // Text colors with WCAG AA compliance
  static const Color onPrimary = Color(0xFFFFFFFF); // White
  static const Color onSecondary = Color(0xFFFFFFFF); // White
  static const Color onBackground = Color(0xFF212121); // Grey 900
  static const Color onSurface = Color(0xFF424242); // Grey 800
  static const Color onSurfaceVariant = Color(0xFF616161); // Grey 700
  
  // Status colors
  static const Color success = Color(0xFF2E7D32); // Green 800
  static const Color warning = Color(0xFFF57C00); // Orange 700
  static const Color error = Color(0xFFD32F2F); // Red 700
  static const Color info = Color(0xFF1976D2); // Blue 700
  
  // Tab colors
  static const Color tabSelected = primary;
  static const Color tabUnselected = Color(0xFF757575); // Grey 600
  static const Color tabBackground = Color(0xFFFAFAFA); // Grey 50
  
  // Border colors
  static const Color border = Color(0xFFBDBDBD); // Grey 400
  static const Color borderLight = Color(0xFFE0E0E0); // Grey 300
  
  // Shadow colors
  static const Color shadow = Color(0x1A000000); // 10% black
  static const Color shadowLight = Color(0x0D000000); // 5% black

  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212); // Dark surface
  static const Color darkSurface = Color(0xFF1E1E1E); // Dark card background
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C); // Dark variant surface
  
  // Dark text colors
  static const Color onDarkBackground = Color(0xFFFFFFFF); // White on dark
  static const Color onDarkSurface = Color(0xFFE0E0E0); // Light grey on dark
  static const Color onDarkSurfaceVariant = Color(0xFFB0B0B0); // Medium grey on dark
  
  // Dark tab colors
  static const Color darkTabBackground = Color(0xFF1E1E1E); // Dark tab background
  static const Color darkTabUnselected = Color(0xFF757575); // Grey 600
  
  // Dark border colors
  static const Color darkBorder = Color(0xFF424242); // Grey 800
  static const Color darkBorderLight = Color(0xFF2C2C2C); // Dark variant surface
}



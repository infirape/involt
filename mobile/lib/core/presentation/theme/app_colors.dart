import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color magenta = Color(0xFFFF00FF);
  static const Color cyan = Color(0xFF00FFFF);
  static const Color green = Color(0xFF00FF88);
  
  // Backgrounds
  static const Color onyx = Color(0xFF050505);
  static const Color deepPurple = Color(0xFF1A001A);
  
  // Surfaces & Glass
  static const Color surface = Color(0xFF121212);
  static Color glass = Colors.white.withOpacity(0.08);
  static Color glassBorder = Colors.white.withOpacity(0.12);
  
  // Text
  static const Color textPrimary = Colors.white;
  static Color textSecondary = Colors.white.withOpacity(0.7);
  static Color textMuted = Colors.white.withOpacity(0.4);

  // Gradient
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepPurple, onyx],
  );
}

import 'package:flutter/material.dart';

/// App Color Palette
/// Menggunakan Teal-Cream gradient theme dengan glass morphism effect
class AppColors {
  // Gradients untuk background
  static const gradientStart = Color(0xFFE0F2F1); // Very Light Teal
  static const gradientEnd = Color(0xFFFFF8E1);   // Light Cream
  
  // Primary colors
  static const primary = Color(0xFF26A69A);       // Medium Teal
  static const secondary = Color(0xFFFFB74D);     // Warm Orange
  
  // Glass morphism effect
  static const glassWhite = Color(0xB3FFFFFF);    // 70% opacity white
  static const glassBorder = Color(0xE6FFFFFF);   // 90% opacity white
  
  // Status colors
  static const success = Color(0xFF66BB6A);       // Soft Green
  static const warning = Color(0xFFFFA726);       // Orange
  static const danger = Color(0xFFEF5350);        // Soft Red
  static const info = Color(0xFF42A5F5);          // Blue
  
  // Text colors
  static const textPrimary = Color(0xFF2C3E50);   // Dark Blue Grey
  static const textSecondary = Color(0xFF607D8B); // Medium Grey
  static const textHint = Color(0xFFB0BEC5);      // Light Grey
  
  // Category specific tints (untuk glass cards)
  static const category01Tint = Color(0x2681D4FA); // Baby Blue tint (15% opacity)
  static const category12Tint = Color(0x26A5D6A7); // Soft Green tint (15% opacity)
  static const category25Tint = Color(0x26FFB74D); // Soft Orange tint (15% opacity)
  
  // Background colors
  static const background = Color(0xFFFAFAFA);    // Off white
  static const surface = Color(0xFFFFFFFF);       // Pure white
  
  // Disabled state
  static const disabled = Color(0xFFE0E0E0);      // Light grey
  static const disabledText = Color(0xFF9E9E9E);  // Medium grey
}

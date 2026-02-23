import 'package:flutter/material.dart';

/// App Color Palette
/// Tema: Coral & Sunshine — Warm, Friendly, Colorful
class AppColors {
  // ── PRIMARY ─────────────────────────────────────────
  static const primary = Color(0xFFFF6B6B); // Coral
  static const primaryDark = Color(0xFFE05555); // Deep Coral (pressed state)
  static const primaryLight = Color(
    0xFFFFEDED,
  ); // Light Coral (background tint)

  // ── SECONDARY ───────────────────────────────────────
  static const secondary = Color(0xFFFF8E53); // Sunny Orange
  static const secondaryLight = Color(0xFFFFF0E6); // Light Orange tint

  // ── ACCENT COLORS (untuk variasi antar section) ─────
  static const accentTeal = Color(0xFF4ECDC4); // Sky Teal  → kategori 0-1 tahun
  static const accentYellow = Color(
    0xFFFFD93D,
  ); // Sunshine  → kategori 1-2 tahun
  static const accentPurple = Color(
    0xFFA78BFA,
  ); // Soft Purple → kategori 2-5 tahun

  // ── GRADIENT ────────────────────────────────────────
  static const gradientStart = Color(0xFFFF6B6B); // Coral
  static const gradientEnd = Color(0xFFFF8E53); // Orange
  static const gradientBg = Color(0xFFFFF5F0); // Warm white bg

  // ── CATEGORY TINTS (background card per usia) ───────
  static const category01Tint = Color(0xFFE0FAF9); // Teal tint  → 0-1 tahun
  static const category12Tint = Color(0xFFFFFBE6); // Yellow tint → 1-2 tahun
  static const category25Tint = Color(0xFFF3EEFF); // Purple tint → 2-5 tahun

  // ── STATUS COLORS ───────────────────────────────────
  static const success = Color(0xFF6BCB77); // Fresh Green
  static const successLight = Color(0xFFE8F8EA); // Green tint
  static const warning = Color(0xFFFFA726); // Amber
  static const warningLight = Color(0xFFFFF3E0); // Amber tint
  static const danger = Color(0xFFFF5252); // Soft Red
  static const dangerLight = Color(0xFFFFEBEB); // Red tint
  static const info = Color(0xFF4ECDC4); // Sky Teal (sama dgn accentTeal)
  static const infoLight = Color(0xFFE0FAF9); // Teal tint

  // ── TEXT ────────────────────────────────────────────
  static const textPrimary = Color(0xFF2C3E50); // Dark Slate
  static const textSecondary = Color(0xFF607D8B); // Medium Grey
  static const textHint = Color(0xFFB0BEC5); // Light Grey
  static const textOnPrimary = Color(0xFFFFFFFF); // White (di atas coral/teal)

  // ── BACKGROUND & SURFACE ────────────────────────────
  static const background = Color(0xFFFFF5F0); // Warm White (hint of peach)
  static const surface = Color(0xFFFFFFFF); // Pure White (cards)
  static const surfaceVariant = Color(0xFFFAFAFA); // Off White

  // ── BORDER & DIVIDER ────────────────────────────────
  static const border = Color(0xFFF0E6E6); // Soft warm border
  static const divider = Color(0xFFF5F0F0); // Subtle divider

  // ── DISABLED ────────────────────────────────────────
  static const disabled = Color(0xFFE0E0E0);
  static const disabledText = Color(0xFF9E9E9E);

  // ── GLASS (dipertahankan jika masih ada penggunaan) ──
  static const glassWhite = Color(0xB3FFFFFF);
  static const glassBorder = Color(0xE6FFFFFF);

  // ── HELPER: Gradient decoration ─────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentTeal, Color(0xFF38B2AC)],
  );

  static const LinearGradient yellowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentYellow, Color(0xFFF5A623)],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPurple, Color(0xFF7C3AED)],
  );
}

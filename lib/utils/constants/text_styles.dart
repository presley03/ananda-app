import 'package:flutter/material.dart';
import 'colors.dart';

/// App Text Styles
/// Display/Heading : Playfair Display (elegan, berkarakter)
/// Body/UI         : DM Sans (clean, modern, mudah dibaca)
class AppTextStyles {
  // ── HEADERS (Playfair Display) ───────────────────────

  static const h1 = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const h2 = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const h3 = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const h4 = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ── BODY (DM Sans) ───────────────────────────────────

  static const body1 = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const body2 = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ── CAPTION & LABEL ─────────────────────────────────

  static const caption = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
    height: 1.4,
  );

  static const label = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const labelSmall = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // ── BUTTON ──────────────────────────────────────────

  static const button = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
    letterSpacing: 0.3,
  );

  static const buttonSmall = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.2,
  );

  // ── SUBTITLE ────────────────────────────────────────

  static const subtitle1 = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const subtitle2 = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ── OVERLINE / BADGE ────────────────────────────────

  static const overline = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.0,
    height: 1.2,
  );

  // ── SPECIAL ─────────────────────────────────────────

  /// Angka besar — skor, hasil kuesioner
  static const scoreNumber = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.0,
  );

  /// Hasil skrining — "Normal", "Meragukan"
  static const resultTitle = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Greeting name — "Bunda Sari"
  static const greetingName = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.2,
  );

  /// Greeting subtitle
  static const greetingSub = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.3,
  );
}

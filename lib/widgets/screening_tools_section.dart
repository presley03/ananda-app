import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/dimensions.dart';
import 'screening_tool_card.dart';

/// Screening Tools Section Widget
/// Section dengan 4 screening tools (KPSP, Gizi, TDD, M-CHAT)
///
/// Usage:
/// ```dart
/// ScreeningToolsSection(
///   title: 'Tools Skrining',
///   onKPSPTap: () => print('KPSP'),
///   onGiziTap: () => print('Gizi'),
///   onTDDTap: () => print('TDD'),
///   onMCHATTap: () => print('M-CHAT'),
/// )
/// ```
class ScreeningToolsSection extends StatelessWidget {
  final String title;
  final VoidCallback? onKPSPTap;
  final VoidCallback? onGiziTap;
  final VoidCallback? onTDDTap;
  final VoidCallback? onMCHATTap;

  const ScreeningToolsSection({
    super.key,
    this.title = 'Tools Skrining',
    this.onKPSPTap,
    this.onGiziTap,
    this.onTDDTap,
    this.onMCHATTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
          ),
          child: Text(
            title,
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
          ),
        ),

        const SizedBox(height: AppDimensions.spacingM),

        // KPSP Card
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
          ),
          child: ScreeningToolCard(
            icon: Icons.assignment,
            iconColor: AppColors.primary,
            title: 'KPSP',
            subtitle: 'Skrining Perkembangan',
            description: 'Deteksi dini perkembangan anak',
            onTap: onKPSPTap,
          ),
        ),

        const SizedBox(height: AppDimensions.spacingM),

        // Kalkulator Gizi Card
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
          ),
          child: ScreeningToolCard(
            icon: Icons.restaurant,
            iconColor: AppColors.success,
            title: 'Kalkulator Gizi',
            subtitle: 'Nutrisi & Antropometri',
            description: 'Hitung status gizi anak',
            onTap: onGiziTap,
          ),
        ),

        const SizedBox(height: AppDimensions.spacingM),

        // TDD Card
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
          ),
          child: ScreeningToolCard(
            icon: Icons.hearing,
            iconColor: AppColors.info,
            title: 'TDD',
            subtitle: 'Tes Daya Dengar',
            description: 'Deteksi gangguan pendengaran',
            onTap: onTDDTap,
          ),
        ),

        const SizedBox(height: AppDimensions.spacingM),

        // M-CHAT-R Card
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
          ),
          child: ScreeningToolCard(
            icon: Icons.psychology,
            iconColor: AppColors.secondary,
            title: 'M-CHAT-R',
            subtitle: 'Skrining Autisme',
            description: 'Deteksi risiko autisme dini',
            onTap: onMCHATTap,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/dimensions.dart';
import 'glass_card.dart';

/// Screening Tool Card Widget
/// Card untuk tools skrining (KPSP, Gizi, TDD, M-CHAT)
///
/// Usage:
/// ```dart
/// ScreeningToolCard(
///   icon: Icons.assignment,
///   iconColor: AppColors.primary,
///   title: 'KPSP',
///   subtitle: 'Skrining Perkembangan',
///   description: 'Deteksi dini perkembangan anak',
///   onTap: () => print('KPSP tapped'),
/// )
/// ```
class ScreeningToolCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String description;
  final VoidCallback? onTap;

  const ScreeningToolCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(icon, color: Colors.white, size: AppDimensions.iconL),
          ),

          const SizedBox(width: AppDimensions.spacingM),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: AppDimensions.spacingXS),

                // Subtitle
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: iconColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: AppDimensions.spacingXS),

                // Description
                Text(
                  description,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: AppDimensions.spacingS),

          // Arrow Icon
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textHint,
            size: AppDimensions.iconS,
          ),
        ],
      ),
    );
  }
}

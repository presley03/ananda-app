import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/dimensions.dart';
import 'glass_card.dart';

/// Category Card Widget
/// Card untuk kategori materi edukatif dengan icon dan description
///
/// Usage:
/// ```dart
/// CategoryCard(
///   icon: Icons.child_care,
///   iconColor: AppColors.primary,
///   title: '0-1 Tahun',
///   description: 'Materi untuk bayi',
///   tintColor: AppColors.category01Tint,
///   onTap: () => print('Tapped'),
/// )
/// ```
class CategoryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final Color? tintColor;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    this.tintColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      tintColor: tintColor,
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
                Text(
                  title,
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                Text(
                  description,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

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

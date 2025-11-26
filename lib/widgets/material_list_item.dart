/// File: material_list_item.dart
/// Path: lib/widgets/material_list_item.dart
/// Description: Reusable card widget untuk display satu materi edukatif
///
/// Features:
/// - Glass morphism card design
/// - Category badge dengan tint color
/// - Subcategory dengan emoji
/// - Title dan content preview
/// - Reading time badge
/// - Tap callback untuk navigation

import 'package:flutter/material.dart';
import '../models/material.dart' as model;
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/dimensions.dart';
import 'glass_card.dart';

class MaterialListItem extends StatelessWidget {
  /// Material data object
  final model.Material material;

  /// Callback saat card di-tap
  final VoidCallback onTap;

  /// Optional: Show bookmark icon
  final bool showBookmark;

  /// Optional: Bookmark state
  final bool isBookmarked;

  /// Optional: Bookmark tap callback
  final VoidCallback? onBookmarkTap;

  const MaterialListItem({
    Key? key,
    required this.material,
    required this.onTap,
    this.showBookmark = false,
    this.isBookmarked = false,
    this.onBookmarkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      tintColor: _getCategoryTintColor(),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Category badge + Bookmark icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category badge
                _buildCategoryBadge(),

                // Bookmark icon (optional)
                if (showBookmark) _buildBookmarkIcon(),
              ],
            ),

            const SizedBox(height: AppDimensions.spacingS),

            // Subcategory dengan emoji
            Text(
              material.subcategoryDisplay,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingXS),

            // Title
            Text(
              material.title,
              style: AppTextStyles.h4,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppDimensions.spacingS),

            // Content preview
            Text(
              material.contentPreview,
              style: AppTextStyles.body2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: AppDimensions.spacingM),

            // Footer: Reading time
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: AppDimensions.iconS,
                  color: AppColors.textHint,
                ),
                const SizedBox(width: AppDimensions.spacingXS),
                Text(
                  '${material.estimatedReadingTime} menit baca',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build category badge
  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: AppDimensions.spacingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Text(
        material.categoryDisplay,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Build bookmark icon
  Widget _buildBookmarkIcon() {
    return GestureDetector(
      onTap: onBookmarkTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingXS),
        child: Icon(
          isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
          size: AppDimensions.iconM,
          color: isBookmarked ? AppColors.secondary : AppColors.textHint,
        ),
      ),
    );
  }

  /// Get category tint color based on material category
  Color _getCategoryTintColor() {
    switch (material.category) {
      case '0-1':
        return AppColors.category01Tint;
      case '1-2':
        return AppColors.category12Tint;
      case '2-5':
        return AppColors.category25Tint;
      default:
        return AppColors.glassWhite;
    }
  }
}

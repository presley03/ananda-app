import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';

/// Custom Search Bar
/// Search bar dengan glassmorphism effect
///
/// Usage:
/// ```dart
/// CustomSearchBar(
///   onTap: () => Navigator.push(...),
/// )
/// ```
class CustomSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final String hintText;

  const CustomSearchBar({
    super.key,
    this.onTap,
    this.hintText = 'Cari materi, skrining...',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: AppColors.glassBorder.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: AppDimensions.spacingM),

            // Search Icon
            Icon(
              Icons.search,
              color: AppColors.textHint,
              size: AppDimensions.iconM,
            ),

            const SizedBox(width: AppDimensions.spacingM),

            // Hint Text
            Expanded(
              child: Text(
                hintText,
                style: TextStyle(fontSize: 14, color: AppColors.textHint),
              ),
            ),

            const SizedBox(width: AppDimensions.spacingM),
          ],
        ),
      ),
    );
  }
}

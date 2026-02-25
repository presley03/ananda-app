import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';
import 'custom_search_bar.dart';

/// Top Bar Widget
/// Bar atas dengan user icon dan search bar
///
/// Usage:
/// ```dart
/// TopBar(
///   onUserTap: () => print('User tapped'),
///   onSearchTap: () => print('Search tapped'),
/// )
/// ```
class TopBar extends StatelessWidget {
  final VoidCallback? onUserTap;
  final VoidCallback? onSearchTap;

  const TopBar({super.key, this.onUserTap, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          // User Icon
          _buildIconButton(icon: Icons.account_circle, onTap: onUserTap),

          const SizedBox(width: AppDimensions.spacingM),

          // Search Bar (Expanded - takes all remaining space)
          Expanded(child: CustomSearchBar(onTap: onSearchTap)),
        ],
      ),
    );
  }

  /// Build icon button
  Widget _buildIconButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
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
        child: Center(
          child: Icon(
            icon,
            color: AppColors.primary,
            size: AppDimensions.iconM,
          ),
        ),
      ),
    );
  }
}
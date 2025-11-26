import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';
import 'custom_search_bar.dart';

/// Top Bar Widget
/// Bar atas dengan user icon, search bar, dan notification icon
///
/// Usage:
/// ```dart
/// TopBar(
///   onUserTap: () => print('User tapped'),
///   onSearchTap: () => print('Search tapped'),
///   onNotificationTap: () => print('Notification tapped'),
/// )
/// ```
class TopBar extends StatelessWidget {
  final VoidCallback? onUserTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final bool hasNotification;

  const TopBar({
    super.key,
    this.onUserTap,
    this.onSearchTap,
    this.onNotificationTap,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          // User Icon
          _buildIconButton(icon: Icons.account_circle, onTap: onUserTap),

          const SizedBox(width: AppDimensions.spacingM),

          // Search Bar (Expanded - takes remaining space)
          Expanded(child: CustomSearchBar(onTap: onSearchTap)),

          const SizedBox(width: AppDimensions.spacingM),

          // Notification Icon with badge
          _buildIconButton(
            icon: Icons.notifications_outlined,
            onTap: onNotificationTap,
            showBadge: hasNotification,
          ),
        ],
      ),
    );
  }

  /// Build icon button with optional badge
  Widget _buildIconButton({
    required IconData icon,
    VoidCallback? onTap,
    bool showBadge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: AppColors.glassBorder.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Icon
            Center(
              child: Icon(
                icon,
                color: AppColors.primary,
                size: AppDimensions.iconM,
              ),
            ),

            // Badge (notification dot)
            if (showBadge)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

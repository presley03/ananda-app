import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/dimensions.dart';

/// Greeting Section Widget
/// Section sambutan dengan nama user dan subtitle motivasi
///
/// Usage:
/// ```dart
/// GreetingSection(
///   userName: 'Bunda',
///   subtitle: 'Mari pantau tumbuh kembang si kecil!',
/// )
/// ```
class GreetingSection extends StatelessWidget {
  final String userName;
  final String? subtitle;

  const GreetingSection({super.key, this.userName = 'Bunda', this.subtitle});

  /// Get greeting based on time of day
  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      return 'Selamat Pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  /// Get emoji based on time of day
  String _getEmoji() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      return '☀️'; // Morning
    } else if (hour >= 11 && hour < 15) {
      return '🌤️'; // Afternoon
    } else if (hour >= 15 && hour < 18) {
      return '🌅'; // Evening
    } else {
      return '🌙'; // Night
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting with emoji
          Row(
            children: [
              Text(
                '${_getGreeting()}, ',
                style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
              ),
              Text(_getEmoji(), style: const TextStyle(fontSize: 28)),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingXS),

          // User name
          Text(
            userName,
            style: AppTextStyles.h1.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: AppDimensions.spacingS),

          // Subtitle
          Text(
            subtitle ?? 'Mari pantau tumbuh kembang si kecil hari ini! 👶',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

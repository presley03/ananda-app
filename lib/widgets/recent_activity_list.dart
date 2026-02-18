import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';

/// Simple Activity List Item
class ActivityListItem {
  final String title;
  final String timeAgo;
  final IconData icon;
  final Color color;

  ActivityListItem({
    required this.title,
    required this.timeAgo,
    required this.icon,
    required this.color,
  });
}

/// Recent Activity Simple List
/// List aktivitas minimalis tanpa heavy card
class RecentActivityList extends StatelessWidget {
  final List<ActivityListItem> activities;

  const RecentActivityList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children:
            activities.take(3).map((activity) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: activity.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        activity.icon,
                        size: 16,
                        color: activity.color,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Content
                    Expanded(
                      child: Text(
                        activity.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    // Time
                    Text(
                      activity.timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
}

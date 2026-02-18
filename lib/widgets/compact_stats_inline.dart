import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';

/// Compact Stats Inline
/// Stats minimalis inline di bawah greeting
class CompactStatsInline extends StatelessWidget {
  final int screeningCount;
  final int materialsReadCount;
  final int childProfilesCount;

  const CompactStatsInline({
    super.key,
    required this.screeningCount,
    required this.materialsReadCount,
    required this.childProfilesCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatItem(
          icon: Icons.fact_check_rounded,
          count: screeningCount,
          label: 'Skrining',
        ),
        _buildDivider(),
        _buildStatItem(
          icon: Icons.menu_book_rounded,
          count: materialsReadCount,
          label: 'Materi',
        ),
        _buildDivider(),
        _buildStatItem(
          icon: Icons.child_care_rounded,
          count: childProfilesCount,
          label: 'Anak',
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required int count,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary.withValues(alpha: 0.7)),
        const SizedBox(width: 4),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.textHint.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

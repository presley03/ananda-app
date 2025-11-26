import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/dimensions.dart';
import 'category_card.dart';

/// Category Section Widget
/// Section dengan horizontal scroll untuk category cards
///
/// Usage:
/// ```dart
/// CategorySection(
///   title: 'Materi Edukatif',
///   onCategory01Tap: () => print('0-1 Tahun'),
///   onCategory12Tap: () => print('1-2 Tahun'),
///   onCategory25Tap: () => print('2-5 Tahun'),
/// )
/// ```
class CategorySection extends StatelessWidget {
  final String title;
  final VoidCallback? onCategory01Tap;
  final VoidCallback? onCategory12Tap;
  final VoidCallback? onCategory25Tap;

  const CategorySection({
    super.key,
    this.title = 'Materi Edukatif',
    this.onCategory01Tap,
    this.onCategory12Tap,
    this.onCategory25Tap,
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

        // Horizontal Scrollable Cards
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingM,
            ),
            children: [
              // 0-1 Tahun Card
              SizedBox(
                width: 280,
                child: CategoryCard(
                  icon: Icons.child_care,
                  iconColor: AppColors.primary,
                  title: '0-1 Tahun',
                  description: 'Materi untuk bayi',
                  tintColor: AppColors.category01Tint,
                  onTap: onCategory01Tap,
                ),
              ),

              const SizedBox(width: AppDimensions.spacingM),

              // 1-2 Tahun Card
              SizedBox(
                width: 280,
                child: CategoryCard(
                  icon: Icons.face,
                  iconColor: AppColors.success,
                  title: '1-2 Tahun',
                  description: 'Materi untuk batita',
                  tintColor: AppColors.category12Tint,
                  onTap: onCategory12Tap,
                ),
              ),

              const SizedBox(width: AppDimensions.spacingM),

              // 2-5 Tahun Card
              SizedBox(
                width: 280,
                child: CategoryCard(
                  icon: Icons.boy,
                  iconColor: AppColors.secondary,
                  title: '2-5 Tahun',
                  description: 'Materi untuk balita',
                  tintColor: AppColors.category25Tint,
                  onTap: onCategory25Tap,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

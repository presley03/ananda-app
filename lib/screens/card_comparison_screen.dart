import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';
import '../utils/constants/text_styles.dart';
import '../widgets/simple_card_option_a.dart';
import '../widgets/simple_card_option_b.dart';
import '../widgets/simple_card_option_c.dart';

/// Card Comparison Screen
/// 
/// Screen untuk membandingkan 3 design options:
/// - Option A: Material 3 (white + soft shadow)
/// - Option B: Flat Minimal (border only)
/// - Option C: Soft Tinted (soft color + small shadow)
/// 
/// Test semua cards dengan:
/// - Default white
/// - Tinted colors (category colors)
/// - Different content types
class CardComparisonScreen extends StatelessWidget {
  const CardComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Card Design Comparison',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable comparison
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Instructions
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Scroll dan bandingkan ketiga design. '
                          'Perhatikan shadow, border, dan readability. '
                          'Test di HP kentang untuk cek performance!',
                          style: TextStyle(fontSize: 13, height: 1.4),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // OPTION A
                      _buildSectionTitle('Option A - Material 3 Clean'),
                      const SizedBox(height: 12),
                      _buildOptionACards(),

                      const SizedBox(height: 32),

                      // OPTION B
                      _buildSectionTitle('Option B - Flat Minimal'),
                      const SizedBox(height: 12),
                      _buildOptionBCards(),

                      const SizedBox(height: 32),

                      // OPTION C
                      _buildSectionTitle('Option C - Soft Tinted'),
                      const SizedBox(height: 12),
                      _buildOptionCCards(),

                      const SizedBox(height: 32),

                      // Performance notes
                      _buildPerformanceNotes(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  // OPTION A CARDS
  Widget _buildOptionACards() {
    return Column(
      children: [
        // White card
        SimpleCardOptionA(
          child: _buildCardContent(
            icon: Icons.child_care,
            iconColor: AppColors.primary,
            title: '0-1 Tahun',
            subtitle: 'Materi untuk bayi',
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Tinted card (category 0-1)
        SimpleCardOptionA(
          tintColor: AppColors.category01Tint,
          child: _buildCardContent(
            icon: Icons.favorite,
            iconColor: Colors.red,
            title: 'Perawatan',
            subtitle: 'Imunisasi merupakan upaya pencegahan...',
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Screening card
        SimpleCardOptionA(
          child: _buildScreeningCardContent(),
        ),
      ],
    );
  }

  // OPTION B CARDS
  Widget _buildOptionBCards() {
    return Column(
      children: [
        // White card
        SimpleCardOptionB(
          child: _buildCardContent(
            icon: Icons.child_care,
            iconColor: AppColors.primary,
            title: '0-1 Tahun',
            subtitle: 'Materi untuk bayi',
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Tinted card (category 0-1)
        SimpleCardOptionB(
          tintColor: AppColors.category01Tint,
          child: _buildCardContent(
            icon: Icons.favorite,
            iconColor: Colors.red,
            title: 'Perawatan',
            subtitle: 'Imunisasi merupakan upaya pencegahan...',
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Screening card
        SimpleCardOptionB(
          child: _buildScreeningCardContent(),
        ),
      ],
    );
  }

  // OPTION C CARDS
  Widget _buildOptionCCards() {
    return Column(
      children: [
        // White card
        SimpleCardOptionC(
          child: _buildCardContent(
            icon: Icons.child_care,
            iconColor: AppColors.primary,
            title: '0-1 Tahun',
            subtitle: 'Materi untuk bayi',
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Tinted card (category 0-1)
        SimpleCardOptionC(
          tintColor: AppColors.category01Tint,
          child: _buildCardContent(
            icon: Icons.favorite,
            iconColor: Colors.red,
            title: 'Perawatan',
            subtitle: 'Imunisasi merupakan upaya pencegahan...',
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Screening card
        SimpleCardOptionC(
          child: _buildScreeningCardContent(),
        ),
      ],
    );
  }

  // Reusable card content (category/material style)
  Widget _buildCardContent({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        // Icon
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
        
        // Text
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
                subtitle,
                style: AppTextStyles.body2.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        // Arrow
        const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textHint,
          size: AppDimensions.iconS,
        ),
      ],
    );
  }

  // Screening card content
  Widget _buildScreeningCardContent() {
    return Row(
      children: [
        // Icon
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF42A5F5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          child: const Icon(
            Icons.fact_check_rounded,
            color: Colors.white,
            size: AppDimensions.iconL,
          ),
        ),
        
        const SizedBox(width: AppDimensions.spacingM),
        
        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KPSP',
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXS),
              Text(
                'Skrining Perkembangan',
                style: AppTextStyles.caption.copyWith(
                  color: const Color(0xFF42A5F5),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXS),
              Text(
                'Deteksi dini perkembangan anak',
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
        
        // Arrow
        const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textHint,
          size: AppDimensions.iconS,
        ),
      ],
    );
  }

  Widget _buildPerformanceNotes() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textHint.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 Performance Comparison',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildPerformanceItem(
            'Option A',
            'Good - Soft shadow (2 layers)',
            Colors.green,
          ),
          const SizedBox(height: 8),
          _buildPerformanceItem(
            'Option B',
            'Excellent - No shadow, lightest',
            Colors.blue,
          ),
          const SizedBox(height: 8),
          _buildPerformanceItem(
            'Option C',
            'Good - Small shadow (1 layer)',
            Colors.green,
          ),
          const SizedBox(height: 12),
          const Text(
            '💡 Recommendation: Test di HP kentang (2-4GB RAM) '
            'untuk feel the difference!',
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceItem(String option, String note, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              children: [
                TextSpan(
                  text: '$option: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: note),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

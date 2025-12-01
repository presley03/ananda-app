import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/helpers/tdd_data_loader.dart';

/// Screen untuk menampilkan hasil TDD
/// Menampilkan: Pass/Fail, interpretasi, rekomendasi
class TddResultScreen extends StatelessWidget {
  final String ageRange;
  final int totalQuestions;
  final int yesCount;
  final bool isPassed;

  const TddResultScreen({
    super.key,
    required this.ageRange,
    required this.totalQuestions,
    required this.yesCount,
    required this.isPassed,
  });

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
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildResultCard(),
                      const SizedBox(height: AppDimensions.spacingL),
                      _buildScoreCard(),
                      const SizedBox(height: AppDimensions.spacingL),
                      _buildInterpretationCard(),
                      const SizedBox(height: AppDimensions.spacingL),
                      _buildRecommendationCard(),
                      const SizedBox(height: AppDimensions.spacingXL),
                      _buildActionButtons(context),
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

  /// Header
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hasil Tes Daya Dengar',
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                ),
                Text(
                  TddDataLoader.getAgeRangeDisplayName(ageRange),
                  style: AppTextStyles.body2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Result card (Pass/Fail)
  Widget _buildResultCard() {
    final statusColor = isPassed ? AppColors.success : AppColors.danger;
    final statusIcon = isPassed ? Icons.check_circle : Icons.error;
    final statusText = isPassed ? 'Normal' : 'Kemungkinan Ada Gangguan';

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.glassBorder, width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, size: 48, color: statusColor),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'Status Pendengaran',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.spacingXS),
          Text(
            statusText,
            style: AppTextStyles.h1.copyWith(color: statusColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Score card
  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.glassBorder, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreItem(
            'Jawaban "Ya"',
            '$yesCount',
            AppColors.success,
            Icons.check_circle,
          ),
          Container(width: 1, height: 40, color: AppColors.glassBorder),
          _buildScoreItem(
            'Total Pertanyaan',
            '$totalQuestions',
            AppColors.primary,
            Icons.quiz,
          ),
        ],
      ),
    );
  }

  /// Score item
  Widget _buildScoreItem(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: AppDimensions.iconM),
        const SizedBox(height: AppDimensions.spacingS),
        Text(value, style: AppTextStyles.h1.copyWith(color: color)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  /// Interpretation card
  Widget _buildInterpretationCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.glassBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interpretasi Hasil',
            style: AppTextStyles.h4.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildInterpretationItem(
            'Semua jawaban "Ya"',
            'Tidak ada masalah pendengaran',
            AppColors.success,
          ),
          const SizedBox(height: AppDimensions.spacingS),
          _buildInterpretationItem(
            'Ada 1 atau lebih jawaban "Tidak"',
            'Kemungkinan ada gangguan pendengaran',
            AppColors.danger,
          ),
        ],
      ),
    );
  }

  /// Interpretation item
  Widget _buildInterpretationItem(
    String condition,
    String meaning,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppDimensions.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                condition,
                style: AppTextStyles.body2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(meaning, style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }

  /// Recommendation card
  Widget _buildRecommendationCard() {
    final recommendation =
        isPassed
            ? 'Hasil tes menunjukkan tidak ada masalah pendengaran. Lanjutkan pemantauan perkembangan anak secara berkala sesuai jadwal.'
            : 'Hasil tes menunjukkan kemungkinan adanya gangguan pendengaran. Segera konsultasi dengan dokter atau ahli THT untuk pemeriksaan lebih lanjut.';

    final cardColor = isPassed ? AppColors.info : AppColors.danger;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: cardColor.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPassed ? Icons.lightbulb_outline : Icons.warning_amber,
                color: cardColor,
                size: AppDimensions.iconM,
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                'Rekomendasi',
                style: AppTextStyles.h4.copyWith(color: cardColor),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(recommendation, style: AppTextStyles.body1),
          if (!isPassed) ...[
            const SizedBox(height: AppDimensions.spacingM),
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.priority_high,
                    color: AppColors.danger,
                    size: AppDimensions.iconS,
                  ),
                  const SizedBox(width: AppDimensions.spacingS),
                  Expanded(
                    child: Text(
                      'Penting: Segera rujuk ke Rumah Sakit untuk pemeriksaan lebih lanjut',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.danger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Action buttons
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Tombol Simpan
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Fitur simpan akan ditambahkan di fase berikutnya',
                ),
                backgroundColor: AppColors.info,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.spacingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.save, size: AppDimensions.iconM),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                'Simpan Hasil',
                style: AppTextStyles.h4.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        // Tombol Kembali
        OutlinedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 2),
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.spacingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
          child: Text(
            'Kembali ke Beranda',
            style: AppTextStyles.h4.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

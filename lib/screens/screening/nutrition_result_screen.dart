import 'package:flutter/material.dart';
import '../../models/nutrition_measurement.dart';
import '../../models/nutrition_result.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';

/// Screen untuk menampilkan hasil perhitungan status gizi
/// Menampilkan: Z-Score, Status, Rekomendasi
class NutritionResultScreen extends StatelessWidget {
  final NutritionMeasurement measurement;
  final NutritionResult result;

  const NutritionResultScreen({
    super.key,
    required this.measurement,
    required this.result,
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
                      _buildMeasurementSummary(),
                      const SizedBox(height: AppDimensions.spacingL),
                      _buildOverallStatusCard(),
                      const SizedBox(height: AppDimensions.spacingL),
                      _buildDetailedResults(),
                      const SizedBox(height: AppDimensions.spacingL),
                      _buildRecommendationCard(),
                      const SizedBox(height: AppDimensions.spacingL),
                      _buildInterpretationGuide(),
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

  /// Header dengan info anak
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
                  'Hasil Status Gizi',
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                ),
                Text(
                  '${measurement.genderDisplay} â€¢ ${measurement.ageDisplay}',
                  style: AppTextStyles.body2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Ringkasan data pengukuran
  Widget _buildMeasurementSummary() {
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
            'Data Pengukuran',
            style: AppTextStyles.h4.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Row(
            children: [
              Expanded(
                child: _buildMeasurementItem(
                  'Berat Badan',
                  '${measurement.weight} kg',
                  Icons.monitor_weight_outlined,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: _buildMeasurementItem(
                  measurement.measurementType,
                  '${measurement.height} cm',
                  Icons.height,
                  AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildMeasurementItem(
            'IMT (Indeks Massa Tubuh)',
            result.bmi.toStringAsFixed(2),
            Icons.assessment,
            AppColors.info,
          ),
        ],
      ),
    );
  }

  /// Item pengukuran individual
  Widget _buildMeasurementItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingXS),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Icon(icon, color: color, size: AppDimensions.iconS),
        ),
        const SizedBox(width: AppDimensions.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.h4.copyWith(color: color)),
            ],
          ),
        ),
      ],
    );
  }

  /// Card status keseluruhan (yang paling penting)
  Widget _buildOverallStatusCard() {
    final statusColor = _getStatusColor(result.statusColor);
    final statusIcon = _getStatusIcon(result.overallStatus);

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
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, size: 48, color: statusColor),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'Status Gizi',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.spacingXS),
          Text(
            result.overallStatus,
            style: AppTextStyles.h1.copyWith(color: statusColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Hasil detail semua Z-Score
  Widget _buildDetailedResults() {
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
            'Detail Hasil Perhitungan',
            style: AppTextStyles.h4.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildZScoreRow(
            'BB/U (Berat menurut Umur)',
            result.zScoreWeightForAge,
            result.weightForAgeStatus,
          ),
          const Divider(height: AppDimensions.spacingL),
          _buildZScoreRow(
            '${measurement.measurementType}/U (Tinggi menurut Umur)',
            result.zScoreHeightForAge,
            result.heightForAgeStatus,
          ),
          const Divider(height: AppDimensions.spacingL),
          _buildZScoreRow(
            'BB/${measurement.measurementType} (Berat menurut Tinggi)',
            result.zScoreWeightForHeight,
            result.weightForHeightStatus,
          ),
          const Divider(height: AppDimensions.spacingL),
          _buildZScoreRow(
            'IMT/U (IMT menurut Umur)',
            result.zScoreBMIForAge,
            result.bmiForAgeStatus,
          ),
        ],
      ),
    );
  }

  /// Row untuk satu Z-Score
  Widget _buildZScoreRow(String label, double zScore, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.body2),
        const SizedBox(height: AppDimensions.spacingS),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Z-Score: ${result.formatZScore(zScore)}',
              style: AppTextStyles.h4.copyWith(color: AppColors.primary),
            ),
            Flexible(
              child: Text(
                status,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Card rekomendasi
  Widget _buildRecommendationCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: AppColors.info,
                size: AppDimensions.iconM,
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                'Rekomendasi',
                style: AppTextStyles.h4.copyWith(color: AppColors.info),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(result.recommendation, style: AppTextStyles.body1),
        ],
      ),
    );
  }

  /// Panduan interpretasi Z-Score
  Widget _buildInterpretationGuide() {
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
            'Panduan Interpretasi Z-Score',
            style: AppTextStyles.h4.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildGuideItem('< -3 SD', 'Sangat kurang / Buruk', AppColors.danger),
          _buildGuideItem('-3 SD s.d. < -2 SD', 'Kurang', AppColors.warning),
          _buildGuideItem(
            '-2 SD s.d. +1 SD',
            'Normal / Baik',
            AppColors.success,
          ),
          _buildGuideItem(
            '> +1 SD',
            'Berisiko lebih / Lebih',
            AppColors.warning,
          ),
          _buildGuideItem('> +3 SD', 'Obesitas', AppColors.danger),
        ],
      ),
    );
  }

  /// Item panduan
  Widget _buildGuideItem(String range, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(child: Text('$range: $label', style: AppTextStyles.body2)),
        ],
      ),
    );
  }

  /// Tombol aksi
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Tombol Simpan (placeholder)
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
        // Tombol Kembali ke Home
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

  /// Helper: Get color dari status string
  Color _getStatusColor(String statusColorString) {
    switch (statusColorString) {
      case 'success':
        return AppColors.success;
      case 'warning':
        return AppColors.warning;
      case 'danger':
        return AppColors.danger;
      default:
        return AppColors.info;
    }
  }

  /// Helper: Get icon dari status
  IconData _getStatusIcon(String status) {
    final statusLower = status.toLowerCase();
    if (statusLower.contains('normal') || statusLower.contains('baik')) {
      return Icons.check_circle;
    } else if (statusLower.contains('buruk') ||
        statusLower.contains('sangat')) {
      return Icons.error;
    } else if (statusLower.contains('obesitas')) {
      return Icons.error;
    } else {
      return Icons.warning;
    }
  }
}

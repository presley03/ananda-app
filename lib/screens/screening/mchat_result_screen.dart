import 'package:flutter/material.dart';
import '../../models/mchat_question.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/helpers/mchat_data_loader.dart';

/// Screen untuk menampilkan hasil M-CHAT-R
/// Menampilkan: Risk level, scoring, interpretasi, rekomendasi
class MchatResultScreen extends StatelessWidget {
  final List<MchatQuestion> questions;
  final Map<int, bool> answers;

  const MchatResultScreen({
    super.key,
    required this.questions,
    required this.answers,
  });

  /// Calculate total score (failed questions)
  /// Pertanyaan 2, 5, 13: jawaban "Tidak" = fail
  /// Pertanyaan lainnya: jawaban "Ya" = fail
  int get totalFailed {
    int failed = 0;
    for (var question in questions) {
      final answer = answers[question.questionNumber];
      if (answer == null) continue;

      // Pertanyaan 2, 5, 13: "Tidak" = fail
      if ([2, 5, 13].contains(question.questionNumber)) {
        if (answer == false) failed++;
      } else {
        // Pertanyaan lainnya: "Ya" = fail (expected behavior)
        // Sebenarnya untuk M-CHAT, "Tidak" pada pertanyaan normal = fail
        // Mari kita ikuti aturan standar M-CHAT:
        // Semua pertanyaan: "Tidak" = fail, kecuali #2, 5, 13
        if (answer == false) failed++;
      }
    }
    return failed;
  }

  /// Calculate critical questions failed
  int get criticalFailed {
    int failed = 0;
    for (var question in questions) {
      if (!question.isCritical) continue;

      final answer = answers[question.questionNumber];
      if (answer == null) continue;

      // Critical questions (2, 5, 7, 9, 13, 15): "Tidak" = fail
      // Exception: #13 (berjalan) "Ya" is expected
      if (question.questionNumber == 13) {
        if (answer == false) failed++;
      } else {
        if (answer == false) failed++;
      }
    }
    return failed;
  }

  /// Determine risk level
  /// Low: 0-2 total failed
  /// Medium: 3-7 total failed OR 2+ critical failed
  /// High: 8+ total failed
  String get riskLevel {
    if (criticalFailed >= 2) {
      return 'high';
    } else if (totalFailed >= 8) {
      return 'high';
    } else if (totalFailed >= 3) {
      return 'medium';
    } else {
      return 'low';
    }
  }

  String get riskLevelDisplay {
    switch (riskLevel) {
      case 'low':
        return 'Risiko Rendah';
      case 'medium':
        return 'Risiko Sedang';
      case 'high':
        return 'Risiko Tinggi';
      default:
        return 'Unknown';
    }
  }

  Color get riskColor {
    switch (riskLevel) {
      case 'low':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'high':
        return AppColors.danger;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData get riskIcon {
    switch (riskLevel) {
      case 'low':
        return Icons.check_circle;
      case 'medium':
        return Icons.warning;
      case 'high':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  String get recommendation {
    switch (riskLevel) {
      case 'low':
        return 'Hasil skrining menunjukkan risiko rendah untuk gangguan spektrum autisme. Lanjutkan pemantauan perkembangan anak secara berkala dan lakukan skrining ulang pada usia 24 bulan.';
      case 'medium':
        return 'Hasil skrining menunjukkan risiko sedang. Disarankan untuk berkonsultasi dengan dokter anak atau psikolog untuk evaluasi lebih lanjut. Lakukan skrining ulang dalam 1-2 bulan.';
      case 'high':
        return 'Hasil skrining menunjukkan risiko tinggi untuk gangguan spektrum autisme. Segera konsultasi dengan dokter spesialis anak, psikolog, atau ahli perkembangan anak untuk evaluasi diagnostik lengkap dan intervensi dini.';
      default:
        return '';
    }
  }

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
                      const SizedBox(height: AppDimensions.spacingL),
                      _buildDisclaimerCard(),
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
                  'Hasil M-CHAT-R',
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                ),
                Text(
                  MchatDataLoader.getAgeRangeDisplay(),
                  style: AppTextStyles.body2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Result card (Risk level)
  Widget _buildResultCard() {
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
              color: riskColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(riskIcon, size: 48, color: riskColor),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'Level Risiko',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppDimensions.spacingXS),
          Text(
            riskLevelDisplay,
            style: AppTextStyles.h1.copyWith(color: riskColor),
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
            'Total Gagal',
            '$totalFailed/20',
            AppColors.danger,
            Icons.cancel,
          ),
          Container(width: 1, height: 40, color: AppColors.glassBorder),
          _buildScoreItem(
            'Kritis Gagal',
            '$criticalFailed/6',
            AppColors.warning,
            Icons.star,
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
        Text(label, style: AppTextStyles.caption, textAlign: TextAlign.center),
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
            'Risiko Rendah (0-2 gagal)',
            'Perkembangan normal, lanjutkan pemantauan',
            AppColors.success,
          ),
          const SizedBox(height: AppDimensions.spacingS),
          _buildInterpretationItem(
            'Risiko Sedang (3-7 gagal)',
            'Perlu evaluasi lebih lanjut',
            AppColors.warning,
          ),
          const SizedBox(height: AppDimensions.spacingS),
          _buildInterpretationItem(
            'Risiko Tinggi (8+ gagal atau 2+ kritis)',
            'Segera konsultasi ahli',
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
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: riskColor.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                riskLevel == 'low'
                    ? Icons.lightbulb_outline
                    : Icons.warning_amber,
                color: riskColor,
                size: AppDimensions.iconM,
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                'Rekomendasi',
                style: AppTextStyles.h4.copyWith(color: riskColor),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(recommendation, style: AppTextStyles.body1),
          if (riskLevel == 'high') ...[
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
                      'Penting: Intervensi dini sangat penting untuk hasil terbaik',
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

  /// Disclaimer card
  Widget _buildDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.info.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.info,
                size: AppDimensions.iconM,
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                'Catatan Penting',
                style: AppTextStyles.h4.copyWith(color: AppColors.info),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'M-CHAT-R adalah alat skrining, bukan alat diagnostik. Hasil positif tidak berarti anak pasti memiliki autisme. Diperlukan evaluasi diagnostik lengkap oleh profesional untuk diagnosis yang akurat.',
            style: AppTextStyles.body2,
          ),
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

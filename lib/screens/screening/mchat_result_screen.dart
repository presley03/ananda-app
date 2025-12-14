import 'package:flutter/material.dart';
import '../../models/mchat_question.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/helpers/mchat_data_loader.dart';

/// Screen untuk menampilkan hasil M-CHAT-R
/// Menampilkan: Risk level, scoring, interpretasi, rekomendasi
///
/// SCORING RULES (berdasarkan materi):
/// - Untuk pertanyaan 2, 5, 12: Jawaban "YA" = risiko (reverse scoring)
/// - Untuk pertanyaan lainnya: Jawaban "TIDAK" = risiko
///
/// RISK LEVELS:
/// - LOW: Skor 0-2
/// - MEDIUM: Skor 3-7
/// - HIGH: Skor 8-20
class MchatResultScreen extends StatelessWidget {
  final List<MchatQuestion> questions;
  final Map<int, bool> answers;

  const MchatResultScreen({
    super.key,
    required this.questions,
    required this.answers,
  });

  /// Calculate total score (at-risk answers)
  ///
  /// SCORING:
  /// - Q2, Q5, Q12: "YA" = risiko (reverse scoring)
  /// - Other questions: "TIDAK" = risiko
  int get totalScore {
    int score = 0;
    for (var question in questions) {
      final answer = answers[question.questionNumber];
      if (answer == null) continue;

      // Q2, Q5, Q12: "YA" indicates risk (reverse scoring)
      if ([2, 5, 12].contains(question.questionNumber)) {
        if (answer == true) score++; // YA = at risk
      } else {
        // All other questions: "TIDAK" indicates risk
        if (answer == false) score++; // TIDAK = at risk
      }
    }
    return score;
  }

  /// Calculate critical questions at-risk count
  /// Critical items: Q2, Q5, Q7, Q9, Q12, Q13, Q15
  int get criticalScore {
    int score = 0;
    for (var question in questions) {
      if (!question.isCritical) continue;

      final answer = answers[question.questionNumber];
      if (answer == null) continue;

      // Q2, Q5, Q12: "YA" = risk (reverse scoring)
      if ([2, 5, 12].contains(question.questionNumber)) {
        if (answer == true) score++;
      } else {
        // Q7, Q9, Q13, Q15: "TIDAK" = risk
        if (answer == false) score++;
      }
    }
    return score;
  }

  /// Determine risk level based on total score
  ///
  /// Algorithm dari materi:
  /// - 0-2: Risiko Rendah
  /// - 3-7: Risiko Sedang
  /// - 8-20: Risiko Tinggi
  String get riskLevel {
    if (totalScore >= 8) {
      return 'high';
    } else if (totalScore >= 3) {
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
        return 'Hasil skrining menunjukkan risiko rendah untuk gangguan spektrum autisme. Tidak perlu tindakan lanjutan, kecuali surveilans rutin. Jika anak berusia kurang dari 24 bulan, lakukan skrining ulang setelah ulang tahun kedua.';
      case 'medium':
        return 'Hasil skrining menunjukkan risiko sedang. Disarankan untuk melakukan follow-up (M-CHAT-R/F tahap kedua) untuk mendapat informasi tambahan. Konsultasikan dengan dokter anak atau psikolog untuk evaluasi lebih lanjut.';
      case 'high':
        return 'Hasil skrining menunjukkan risiko tinggi untuk gangguan spektrum autisme. Segera rujuk ke dokter spesialis anak, psikolog, atau ahli perkembangan anak untuk evaluasi diagnostik lengkap dan eligibilitas intervensi awal.';
      default:
        return '';
    }
  }

  String get interpretationText {
    switch (riskLevel) {
      case 'low':
        return 'Skor total 0-2 menunjukkan risiko rendah. Lanjutkan pemantauan perkembangan anak secara berkala.';
      case 'medium':
        return 'Skor total 3-7 menunjukkan risiko sedang. Follow-up diperlukan untuk menentukan apakah rujukan diagnostik diperlukan.';
      case 'high':
        return 'Skor total 8 atau lebih menunjukkan risiko tinggi. Rujukan untuk evaluasi diagnostik sangat direkomendasikan.';
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
            riskLevelDisplay,
            style: AppTextStyles.h2.copyWith(color: riskColor),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Gangguan Spektrum Autisme',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skor Skrining',
            style: AppTextStyles.h4.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildScoreItem(
                'Total Skor',
                '$totalScore',
                riskColor,
                Icons.assessment,
              ),
              Container(height: 60, width: 1, color: AppColors.glassBorder),
              _buildScoreItem(
                'Dari 20',
                '20',
                AppColors.textSecondary,
                Icons.list_alt,
              ),
              Container(height: 60, width: 1, color: AppColors.glassBorder),
              _buildScoreItem(
                'Item Kritis',
                '$criticalScore',
                AppColors.warning,
                Icons.priority_high,
              ),
            ],
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
          Text(interpretationText, style: AppTextStyles.body2),
          const SizedBox(height: AppDimensions.spacingM),
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingS),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              border: Border.all(
                color: AppColors.info.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.info,
                  size: AppDimensions.iconS,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Expanded(
                  child: Text(
                    'Scoring: Q2, 5, 12: "YA" = risiko | Lainnya: "TIDAK" = risiko',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Recommendation card
  Widget _buildRecommendationCard() {
    final cardColor =
        riskLevel == 'low'
            ? AppColors.info
            : riskLevel == 'medium'
            ? AppColors.warning
            : AppColors.danger;

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
                riskLevel == 'low'
                    ? Icons.lightbulb_outline
                    : Icons.warning_amber,
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
          Text(recommendation, style: AppTextStyles.body2),
        ],
      ),
    );
  }

  /// Disclaimer card
  Widget _buildDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.warning,
                size: AppDimensions.iconM,
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Text(
                'Perhatian',
                style: AppTextStyles.h4.copyWith(color: AppColors.warning),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'M-CHAT-R adalah alat skrining, bukan alat diagnostik. Hasil skrining positif tidak berarti anak pasti memiliki gangguan spektrum autisme. Diperlukan evaluasi diagnostik komprehensif oleh profesional yang berkualifikasi untuk diagnosis yang akurat.',
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
        // Save result button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Save result to database
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hasil telah disimpan'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            child: const Text(
              'Simpan Hasil',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
        // Back to home button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 2),
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            child: const Text(
              'Kembali ke Beranda',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

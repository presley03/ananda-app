import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';

/// KPSP Result Screen
/// Screen untuk menampilkan hasil KPSP
/// - Skor (jumlah jawaban "Ya")
/// - Interpretasi (Normal, Meragukan, Penyimpangan)
/// - Rekomendasi tindakan
class KpspResultScreen extends StatelessWidget {
  final int ageMonths;
  final int score;
  final int totalQuestions;

  const KpspResultScreen({
    super.key,
    required this.ageMonths,
    required this.score,
    this.totalQuestions = 10,
  });

  // Get age display
  String get _ageDisplay {
    if (ageMonths < 12) {
      return '$ageMonths Bulan';
    } else {
      final years = ageMonths ~/ 12;
      final remainingMonths = ageMonths % 12;
      if (remainingMonths == 0) {
        return '$years Tahun';
      } else {
        return '$years Tahun $remainingMonths Bulan';
      }
    }
  }

  // Get result interpretation
  // Berdasarkan pedoman KPSP:
  // - 9-10 jawaban "Ya" = Normal
  // - 7-8 jawaban "Ya" = Meragukan
  // - ≤6 jawaban "Ya" = Penyimpangan
  String get _resultStatus {
    if (score >= 9) {
      return 'Normal';
    } else if (score >= 7) {
      return 'Meragukan';
    } else {
      return 'Penyimpangan';
    }
  }

  // Get result color
  Color get _resultColor {
    if (score >= 9) {
      return AppColors.success;
    } else if (score >= 7) {
      return AppColors.warning;
    } else {
      return AppColors.danger;
    }
  }

  // Get result icon
  IconData get _resultIcon {
    if (score >= 9) {
      return Icons.check_circle;
    } else if (score >= 7) {
      return Icons.warning;
    } else {
      return Icons.error;
    }
  }

  // Get recommendation text
  String get _recommendation {
    if (score >= 9) {
      return 'Perkembangan anak sesuai dengan tahap usianya. Teruskan stimulasi perkembangan anak secara rutin dan lakukan pemeriksaan KPSP kembali setiap 3 bulan.';
    } else if (score >= 7) {
      return 'Kemungkinan ada penyimpangan. Lakukan pemeriksaan KPSP ulang 2 minggu kemudian dengan menggunakan daftar pertanyaan yang sama. Jika hasil masih meragukan, segera rujuk ke tenaga kesehatan untuk evaluasi lebih lanjut.';
    } else {
      return 'Terdapat penyimpangan perkembangan. Segera rujuk ke Rumah Sakit atau konsultasikan dengan dokter spesialis anak untuk pemeriksaan dan penanganan lebih lanjut.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
              _buildHeader(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.spacingM),
                    child: Column(
                      children: [
                        SizedBox(height: AppDimensions.spacingL),

                        // Result card
                        _buildResultCard(),

                        SizedBox(height: AppDimensions.spacingL),

                        // Score card
                        _buildScoreCard(),

                        SizedBox(height: AppDimensions.spacingL),

                        // Recommendation card
                        _buildRecommendationCard(),

                        SizedBox(height: AppDimensions.spacingXL),
                      ],
                    ),
                  ),
                ),
              ),

              // Action buttons
              _buildActionButtons(context),

              SizedBox(height: AppDimensions.spacingM),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
            color: AppColors.textPrimary,
          ),
          SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hasil KPSP', style: AppTextStyles.h2),
                SizedBox(height: AppDimensions.spacingXS),
                Text(
                  'Usia $_ageDisplay',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingXL),
      decoration: BoxDecoration(
        color: _resultColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: _resultColor, width: 2),
      ),
      child: Column(
        children: [
          // Icon
          Icon(_resultIcon, size: 64, color: _resultColor),

          SizedBox(height: AppDimensions.spacingM),

          // Status text
          Text(
            _resultStatus,
            style: AppTextStyles.h1.copyWith(
              color: _resultColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: AppDimensions.spacingS),

          // Subtitle
          Text(
            'Hasil Skrining Perkembangan',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.glassBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Skor KPSP', style: AppTextStyles.h4),
          SizedBox(height: AppDimensions.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$score',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 48,
                  color: _resultColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' / $totalQuestions',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingS),
          Center(
            child: Text(
              'jawaban "Ya"',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacingL),

          // Score interpretation guide
          _buildScoreGuide(),
        ],
      ),
    );
  }

  Widget _buildScoreGuide() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interpretasi Skor:',
            style: AppTextStyles.label.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppDimensions.spacingS),
          _buildGuideItem('9-10', 'Normal', AppColors.success),
          _buildGuideItem('7-8', 'Meragukan', AppColors.warning),
          _buildGuideItem('≤6', 'Penyimpangan', AppColors.danger),
        ],
      ),
    );
  }

  Widget _buildGuideItem(String score, String status, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingXS),
      child: Row(
        children: [
          Container(
            width: 40,
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingS,
              vertical: AppDimensions.spacingXS,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Center(
              child: Text(
                score,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: AppDimensions.spacingS),
          Text('= $status', style: AppTextStyles.body2),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.glassBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.secondary,
                size: AppDimensions.iconM,
              ),
              SizedBox(width: AppDimensions.spacingS),
              Text('Rekomendasi', style: AppTextStyles.h4),
            ],
          ),
          SizedBox(height: AppDimensions.spacingM),
          Text(
            _recommendation,
            style: AppTextStyles.body1,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
      child: Column(
        children: [
          // Save result button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Save result to database
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Hasil tersimpan!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              icon: Icon(Icons.save),
              label: Text('Simpan Hasil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spacingS),
          // Done button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Go back to home
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: Icon(Icons.home),
              label: Text('Kembali ke Beranda'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

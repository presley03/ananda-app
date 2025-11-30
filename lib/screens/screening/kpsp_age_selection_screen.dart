import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';
import 'kpsp_questions_screen.dart';
import '../../models/kpsp_question.dart';
import '../../data/kpsp_questions_3months.dart';

/// KPSP Age Selection Screen
/// Screen untuk memilih umur anak sebelum mulai KPSP
/// 16 pilihan umur: 3, 6, 9, 12, 15, 18, 21, 24, 30, 36, 42, 48, 54, 60, 66, 72 bulan
class KpspAgeSelectionScreen extends StatelessWidget {
  const KpspAgeSelectionScreen({super.key});

  // List umur yang tersedia (dalam bulan)
  static const List<int> availableAges = [
    3,
    6,
    9,
    12,
    15,
    18,
    21,
    24,
    30,
    36,
    42,
    48,
    54,
    60,
    66,
    72,
  ];

  // Convert bulan ke display text
  String _getAgeDisplay(int months) {
    if (months < 12) {
      return '$months Bulan';
    } else if (months == 12) {
      return '1 Tahun';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years Tahun';
      } else {
        return '$years Tahun $remainingMonths Bulan';
      }
    }
  }

  // Get questions for specific age
  // NOTE: Saat ini hanya ada data untuk 3 bulan (contoh)
  // Nanti tambahkan data untuk umur lain
  List<KpspQuestion>? _getQuestionsForAge(int ageMonths) {
    switch (ageMonths) {
      case 3:
        return KpspQuestions3Months.getQuestions();
      // TODO: Tambahkan case untuk umur lain
      // case 6:
      //   return KpspQuestions6Months.getQuestions();
      // case 9:
      //   return KpspQuestions9Months.getQuestions();
      // dst...
      default:
        return null; // Belum ada data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient background
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
              Padding(
                padding: EdgeInsets.all(AppDimensions.spacingM),
                child: Row(
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back),
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(width: AppDimensions.spacingS),
                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('KPSP Screening', style: AppTextStyles.h2),
                          SizedBox(height: AppDimensions.spacingXS),
                          Text(
                            'Pilih umur anak Anda',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.spacingL),

              // Info card
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                ),
                child: Container(
                  padding: EdgeInsets.all(AppDimensions.spacingM),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.info,
                        size: AppDimensions.iconM,
                      ),
                      SizedBox(width: AppDimensions.spacingM),
                      Expanded(
                        child: Text(
                          'Pilih umur yang paling mendekati umur anak Anda saat ini',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppDimensions.spacingL),

              // Grid umur
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 kolom
                    childAspectRatio: 2.5, // Lebar lebih panjang dari tinggi
                    crossAxisSpacing: AppDimensions.spacingM,
                    mainAxisSpacing: AppDimensions.spacingM,
                  ),
                  itemCount: availableAges.length,
                  itemBuilder: (context, index) {
                    final ageMonths = availableAges[index];
                    final questions = _getQuestionsForAge(ageMonths);
                    final hasData = questions != null;

                    return _AgeCard(
                      ageMonths: ageMonths,
                      ageDisplay: _getAgeDisplay(ageMonths),
                      hasData: hasData,
                      onTap: () {
                        if (hasData) {
                          // Navigate to questions screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => KpspQuestionsScreen(
                                    ageMonths: ageMonths,
                                    questions: questions,
                                  ),
                            ),
                          );
                        } else {
                          // Show message: data belum tersedia
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Data KPSP untuk ${_getAgeDisplay(ageMonths)} belum tersedia',
                              ),
                              backgroundColor: AppColors.warning,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),

              SizedBox(height: AppDimensions.spacingM),
            ],
          ),
        ),
      ),
    );
  }
}

/// Age Card Widget
/// Card untuk satu pilihan umur
class _AgeCard extends StatelessWidget {
  final int ageMonths;
  final String ageDisplay;
  final bool hasData;
  final VoidCallback onTap;

  const _AgeCard({
    required this.ageMonths,
    required this.ageDisplay,
    required this.hasData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Container(
          decoration: BoxDecoration(
            color:
                hasData
                    ? AppColors.glassWhite
                    : AppColors.glassWhite.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color:
                  hasData
                      ? AppColors.glassBorder
                      : AppColors.glassBorder.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Icon(
                      Icons.child_care,
                      color: hasData ? AppColors.primary : AppColors.textHint,
                      size: AppDimensions.iconM,
                    ),
                    SizedBox(height: AppDimensions.spacingS),
                    // Age text
                    Text(
                      ageDisplay,
                      style: AppTextStyles.h4.copyWith(
                        color:
                            hasData
                                ? AppColors.textPrimary
                                : AppColors.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Badge "Belum Tersedia" jika belum ada data
              if (!hasData)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingXS,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusS,
                      ),
                    ),
                    child: Text(
                      'Soon',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

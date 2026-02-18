import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/legal_texts.dart';
import '../../widgets/simple_card.dart';

/// Disclaimer Screen
/// Menampilkan disclaimer aplikasi
class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

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
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: AppColors.primary,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: AppDimensions.spacingS),
                    Text(
                      'Disclaimer',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingL),
                  child: Column(
                    children: [
                      // Warning Card
                      SimpleCard(
                        padding: const EdgeInsets.all(AppDimensions.spacingL),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: AppDimensions.iconL,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: AppDimensions.spacingM),
                            Expanded(
                              child: Text(
                                'Penting untuk Dibaca',
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.warning,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Disclaimer Content
                      SimpleCard(
                        padding: const EdgeInsets.all(AppDimensions.spacingL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LegalTexts.disclaimerTitle,
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingM),
                            Text(
                              LegalTexts.disclaimerContent,
                              style: AppTextStyles.body2.copyWith(height: 1.6),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Important Points
                      SimpleCard(
                        padding: const EdgeInsets.all(AppDimensions.spacingL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Harap Diperhatikan',
                              style: AppTextStyles.h4.copyWith(
                                color: AppColors.danger,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingM),
                            _buildPoint(
                              '❌ Bukan pengganti konsultasi medis profesional',
                            ),
                            _buildPoint(
                              '❌ Tidak untuk diagnosis pasti kondisi kesehatan',
                            ),
                            _buildPoint(
                              '✅ Hanya sebagai panduan edukasi dan skrining awal',
                            ),
                            _buildPoint(
                              '✅ Konsultasikan dengan dokter/tenaga kesehatan',
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: Text(text, style: AppTextStyles.body2.copyWith(height: 1.5)),
    );
  }
}

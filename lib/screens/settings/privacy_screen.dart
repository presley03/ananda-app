import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/legal_texts.dart';
import '../../widgets/simple_card.dart';

/// Privacy Screen
/// Menampilkan kebijakan privasi aplikasi
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
                      'Kebijakan Privasi',
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
                      // Privacy Icon Card
                      SimpleCard(
                        padding: const EdgeInsets.all(AppDimensions.spacingL),
                        child: Row(
                          children: [
                            Icon(
                              Icons.shield_outlined,
                              size: AppDimensions.iconL,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: AppDimensions.spacingM),
                            Expanded(
                              child: Text(
                                'Data Anda Aman',
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Privacy Content
                      SimpleCard(
                        padding: const EdgeInsets.all(AppDimensions.spacingL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LegalTexts.privacyTitle,
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingM),
                            Text(
                              LegalTexts.privacyContent,
                              style: AppTextStyles.body2.copyWith(height: 1.6),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Key Points
                      SimpleCard(
                        padding: const EdgeInsets.all(AppDimensions.spacingL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Poin Penting',
                              style: AppTextStyles.h4.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingM),
                            _buildPoint(
                              'ðŸ”’ Data tersimpan lokal di perangkat Anda',
                            ),
                            _buildPoint('✅ Tidak ada transmisi data ke server'),
                            _buildPoint('✅ Tidak ada tracking atau analitik'),
                            _buildPoint('✅ 100% offline, privasi terjaga'),
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

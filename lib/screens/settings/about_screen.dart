import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/app_info.dart';
import '../../widgets/glass_card.dart';

/// About Screen
/// Menampilkan informasi tentang aplikasi Ananda
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                      'Tentang Aplikasi',
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
                      // App Logo & Name
                      GlassCard(
                        padding: const EdgeInsets.all(AppDimensions.spacingL),
                        child: Column(
                          children: [
                            Icon(
                              Icons.child_care,
                              size: AppDimensions.iconXXL,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: AppDimensions.spacingM),
                            Text(
                              AppInfo.appName,
                              style: AppTextStyles.h1.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingS),
                            Text(
                              'Versi ${AppInfo.appVersion}',
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingM),
                            Text(
                              AppInfo.appDescription,
                              style: AppTextStyles.body2,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spacingL),

                      // App Info
                      GlassCard(
                        padding: const EdgeInsets.all(AppDimensions.spacingL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tentang Ananda',
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingM),
                            _buildInfoRow(
                              icon: Icons.info_outline,
                              label: 'Versi',
                              value: AppInfo.appVersion,
                            ),
                            const SizedBox(height: AppDimensions.spacingM),
                            _buildInfoRow(
                              icon: Icons.calendar_today,
                              label: 'Rilis',
                              value: AppInfo.releaseYear,
                            ),
                            const SizedBox(height: AppDimensions.spacingM),
                            _buildInfoRow(
                              icon: Icons.person_outline,
                              label: 'Pengembang',
                              value: AppInfo.developerName,
                            ),
                            const SizedBox(height: AppDimensions.spacingM),
                            _buildInfoRow(
                              icon: Icons.email_outlined,
                              label: 'Kontak',
                              value: AppInfo.developerEmail,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Features
                      GlassCard(
                        padding: const EdgeInsets.all(AppDimensions.spacingL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fitur Utama',
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingM),
                            _buildFeatureItem(
                              '📚 Materi Edukasi Tumbuh Kembang',
                            ),
                            _buildFeatureItem('✅ Skrining KPSP'),
                            _buildFeatureItem('⚖️ Kalkulator Status Gizi'),
                            _buildFeatureItem('👂 Tes Daya Dengar (TDD)'),
                            _buildFeatureItem('🧩 M-CHAT-R (Deteksi Autisme)'),
                            _buildFeatureItem('👶 Profil & Tracking Anak'),
                            _buildFeatureItem('📱 100% Offline'),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: AppDimensions.iconS, color: AppColors.primary),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXS),
              Text(
                value,
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            size: AppDimensions.iconS,
            color: AppColors.success,
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(child: Text(feature, style: AppTextStyles.body2)),
        ],
      ),
    );
  }
}

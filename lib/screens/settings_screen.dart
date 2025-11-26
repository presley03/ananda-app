import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/dimensions.dart';
import '../utils/constants/app_info.dart';
import '../widgets/glass_card.dart';

/// Settings Screen
/// Screen pengaturan dengan menu list untuk:
/// - Tentang Aplikasi
/// - Disclaimer
/// - Kebijakan Privasi
/// - Syarat & Ketentuan
/// - Sumber Referensi
/// - Pembuat
/// - Bantuan
///
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                    const Icon(
                      Icons.settings,
                      size: AppDimensions.iconL,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppDimensions.spacingM),
                    Text(
                      'Pengaturan',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu List
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                  ),
                  child: Column(
                    children: [
                      // About App
                      _buildMenuItem(
                        context: context,
                        icon: Icons.info_outline,
                        title: 'Tentang Aplikasi',
                        subtitle: 'Informasi ${AppInfo.appName}',
                        onTap: () {
                          _showComingSoon(context, 'Tentang Aplikasi');
                        },
                      ),

                      const SizedBox(height: AppDimensions.spacingM),

                      // Disclaimer
                      _buildMenuItem(
                        context: context,
                        icon: Icons.warning_amber_outlined,
                        title: 'Disclaimer',
                        subtitle: 'Ketentuan penggunaan aplikasi',
                        onTap: () {
                          _showComingSoon(context, 'Disclaimer');
                        },
                      ),

                      const SizedBox(height: AppDimensions.spacingM),

                      // Privacy Policy
                      _buildMenuItem(
                        context: context,
                        icon: Icons.privacy_tip_outlined,
                        title: 'Kebijakan Privasi',
                        subtitle: 'Perlindungan data pengguna',
                        onTap: () {
                          _showComingSoon(context, 'Kebijakan Privasi');
                        },
                      ),

                      const SizedBox(height: AppDimensions.spacingM),

                      // Terms & Conditions
                      _buildMenuItem(
                        context: context,
                        icon: Icons.description_outlined,
                        title: 'Syarat & Ketentuan',
                        subtitle: 'Ketentuan layanan aplikasi',
                        onTap: () {
                          _showComingSoon(context, 'Syarat & Ketentuan');
                        },
                      ),

                      const SizedBox(height: AppDimensions.spacingM),

                      // References
                      _buildMenuItem(
                        context: context,
                        icon: Icons.library_books_outlined,
                        title: 'Sumber Referensi',
                        subtitle: 'IDAI, WHO, Permenkes',
                        onTap: () {
                          _showComingSoon(context, 'Sumber Referensi');
                        },
                      ),

                      const SizedBox(height: AppDimensions.spacingM),

                      // Credits
                      _buildMenuItem(
                        context: context,
                        icon: Icons.groups_outlined,
                        title: 'Pembuat',
                        subtitle: AppInfo.developerName,
                        onTap: () {
                          _showComingSoon(context, 'Pembuat');
                        },
                      ),

                      const SizedBox(height: AppDimensions.spacingM),

                      // Help
                      _buildMenuItem(
                        context: context,
                        icon: Icons.help_outline,
                        title: 'Bantuan',
                        subtitle: 'Panduan penggunaan aplikasi',
                        onTap: () {
                          _showComingSoon(context, 'Bantuan');
                        },
                      ),

                      const SizedBox(height: AppDimensions.spacingXL),

                      // App Version
                      GlassCard(
                        padding: const EdgeInsets.all(AppDimensions.spacingM),
                        child: Column(
                          children: [
                            Icon(
                              Icons.child_care,
                              size: AppDimensions.iconL,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: AppDimensions.spacingS),
                            Text(
                              AppInfo.appName,
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingXS),
                            Text(
                              'Versi ${AppInfo.appVersion}',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingXS),
                            Text(
                              AppInfo.appDescription,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textHint,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spacingXL),
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

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: AppDimensions.iconM,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),
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
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textHint,
            size: AppDimensions.iconS,
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming soon! 📝'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

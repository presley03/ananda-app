import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/app_info.dart';
import 'settings/about_screen.dart';
import 'settings/disclaimer_screen.dart';
import 'settings/privacy_screen.dart';
import 'settings/terms_screen.dart';
import 'settings/references_screen.dart';
import 'settings/credits_screen.dart';
import 'settings/help_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel('INFORMASI'),
                  const SizedBox(height: 8),
                  _buildItem(
                    context,
                    icon: Icons.info_outline_rounded,
                    color: AppColors.primary,
                    bg: const Color(0xFFFFF0ED),
                    title: 'Tentang Aplikasi',
                    subtitle: 'Informasi ${AppInfo.appName}',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AboutScreen(),
                          ),
                        ),
                  ),
                  _buildItem(
                    context,
                    icon: Icons.library_books_outlined,
                    color: AppColors.accentTeal,
                    bg: const Color(0xFFEDFAFF),
                    title: 'Sumber Referensi',
                    subtitle: 'IDAI, WHO, Permenkes',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ReferencesScreen(),
                          ),
                        ),
                  ),
                  _buildItem(
                    context,
                    icon: Icons.groups_outlined,
                    color: AppColors.accentPurple,
                    bg: const Color(0xFFF3EDFF),
                    title: 'Pembuat',
                    subtitle: AppInfo.developerName,
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreditsScreen(),
                          ),
                        ),
                  ),

                  const SizedBox(height: 24),
                  _sectionLabel('LEGAL'),
                  const SizedBox(height: 8),
                  _buildItem(
                    context,
                    icon: Icons.warning_amber_rounded,
                    color: const Color(0xFFD4AC0D),
                    bg: const Color(0xFFFFFBED),
                    title: 'Disclaimer',
                    subtitle: 'Ketentuan penggunaan aplikasi',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DisclaimerScreen(),
                          ),
                        ),
                  ),
                  _buildItem(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    color: AppColors.success,
                    bg: const Color(0xFFEDFFF5),
                    title: 'Kebijakan Privasi',
                    subtitle: 'Perlindungan data pengguna',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacyScreen(),
                          ),
                        ),
                  ),
                  _buildItem(
                    context,
                    icon: Icons.description_outlined,
                    color: AppColors.accentTeal,
                    bg: const Color(0xFFEDFAFF),
                    title: 'Syarat & Ketentuan',
                    subtitle: 'Ketentuan layanan aplikasi',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TermsScreen(),
                          ),
                        ),
                  ),

                  const SizedBox(height: 24),
                  _sectionLabel('DUKUNGAN'),
                  const SizedBox(height: 8),
                  _buildItem(
                    context,
                    icon: Icons.help_outline_rounded,
                    color: AppColors.accentPurple,
                    bg: const Color(0xFFF3EDFF),
                    title: 'Bantuan',
                    subtitle: 'Panduan penggunaan aplikasi',
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HelpScreen()),
                        ),
                  ),

                  const SizedBox(height: 32),

                  // App version footer
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0ED),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.face_retouching_natural,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppInfo.appName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Versi ${AppInfo.appVersion}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
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
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.settings_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pengaturan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Informasi & preferensi aplikasi',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
      letterSpacing: 1.2,
    ),
  );

  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required Color bg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF0F0F0), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

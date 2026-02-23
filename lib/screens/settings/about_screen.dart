import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/app_info.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App identity card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0ED),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.child_care_rounded,
                            color: AppColors.primary,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppInfo.appName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Versi ${AppInfo.appVersion}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppInfo.appDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  _sectionLabel('DETAIL APLIKASI'),
                  const SizedBox(height: 8),
                  _infoCard(
                    children: [
                      _infoRow(Icons.tag_rounded, 'Versi', AppInfo.appVersion),
                      _divider(),
                      _infoRow(
                        Icons.calendar_month_rounded,
                        'Rilis',
                        AppInfo.releaseYear,
                      ),
                      _divider(),
                      _infoRow(
                        Icons.person_outline_rounded,
                        'Pengembang',
                        AppInfo.developerName,
                      ),
                      _divider(),
                      _infoRow(
                        Icons.mail_outline_rounded,
                        'Kontak',
                        AppInfo.developerEmail,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  _sectionLabel('FITUR UTAMA'),
                  const SizedBox(height: 8),
                  _infoCard(
                    children: [
                      _featureRow(
                        Icons.menu_book_rounded,
                        AppColors.primary,
                        'Materi Edukasi Tumbuh Kembang',
                      ),
                      _divider(),
                      _featureRow(
                        Icons.fact_check_rounded,
                        AppColors.primary,
                        'Skrining KPSP',
                      ),
                      _divider(),
                      _featureRow(
                        Icons.restaurant_rounded,
                        AppColors.success,
                        'Kalkulator Status Gizi',
                      ),
                      _divider(),
                      _featureRow(
                        Icons.hearing_rounded,
                        AppColors.accentTeal,
                        'Tes Daya Dengar (TDD)',
                      ),
                      _divider(),
                      _featureRow(
                        Icons.psychology_rounded,
                        AppColors.accentPurple,
                        'M-CHAT-R (Deteksi Autisme)',
                      ),
                      _divider(),
                      _featureRow(
                        Icons.child_care_rounded,
                        const Color(0xFFE0679A),
                        'Profil & Tracking Anak',
                      ),
                      _divider(),
                      _featureRow(
                        Icons.wifi_off_rounded,
                        AppColors.textSecondary,
                        '100% Offline',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
          padding: const EdgeInsets.fromLTRB(8, 12, 20, 24),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tentang Aplikasi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Informasi Ananda',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String t) => Text(
    t,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
      letterSpacing: 1.2,
    ),
  );

  Widget _infoCard({required List<Widget> children}) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFF0F0F0)),
    ),
    child: Column(children: children),
  );

  Widget _divider() =>
      const Divider(height: 1, indent: 56, color: Color(0xFFF0F0F0));

  Widget _infoRow(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textHint),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _featureRow(IconData icon, Color color, String label) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/constants/dimensions.dart';
import '../../widgets/simple_card.dart';

/// Help Screen
/// Menampilkan panduan penggunaan aplikasi
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
                      'Bantuan',
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
                      // Help Icon Card
                      SimpleCard(
                        padding: const EdgeInsets.all(AppDimensions.spacingL),
                        child: Row(
                          children: [
                            Icon(
                              Icons.help_outline,
                              size: AppDimensions.iconL,
                              color: AppColors.info,
                            ),
                            const SizedBox(width: AppDimensions.spacingM),
                            Expanded(
                              child: Text(
                                'Panduan Penggunaan',
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.info,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Materi Section
                      _buildHelpSection(
                        title: '📚 Materi Edukasi',
                        items: [
                          'Pilih kategori usia anak (0-1, 1-2, 2-5 tahun)',
                          'Browse materi sesuai topik',
                          'Gunakan search untuk cari materi spesifik',
                          'Bookmark materi favorit untuk akses cepat',
                        ],
                      ),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Profil Section
                      _buildHelpSection(
                        title: '👶 Profil Anak',
                        items: [
                          'Tambah profil anak dengan data lengkap',
                          'Edit profil jika ada perubahan',
                          'Lihat riwayat skrining di detail profil',
                          'Tracking otomatis usia anak',
                        ],
                      ),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Screening Section
                      _buildHelpSection(
                        title: '✅ Skrining',
                        items: [
                          'KPSP: Pilih usia, jawab pertanyaan',
                          'Gizi: Input BB, TB/PB, umur untuk hitung status gizi',
                          'TDD: Tes daya dengar sesuai usia',
                          'M-CHAT: Deteksi dini autisme (18-30 bulan)',
                        ],
                      ),

                      const SizedBox(height: AppDimensions.spacingL),

                      // FAQ Card
                      SimpleCard(
                        padding: const EdgeInsets.all(AppDimensions.spacingL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FAQ',
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacingM),
                            _buildFAQ(
                              'Apakah perlu internet?',
                              'Tidak, aplikasi 100% offline.',
                            ),
                            _buildFAQ(
                              'Apakah data aman?',
                              'Ya, semua data tersimpan lokal di perangkat Anda.',
                            ),
                            _buildFAQ(
                              'Hasil skrining akurat?',
                              'Hasil hanya skrining awal, konsultasi dengan dokter untuk diagnosis pasti.',
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

  Widget _buildHelpSection({
    required String title,
    required List<String> items,
  }) {
    return SimpleCard(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h4.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(fontSize: 16, color: AppColors.primary),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTextStyles.body2.copyWith(height: 1.5),
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

  Widget _buildFAQ(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q: $question',
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXS),
          Text(
            'A: $answer',
            style: AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

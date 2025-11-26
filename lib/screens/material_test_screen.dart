/// File: material_test_screen.dart
/// Path: lib/screens/material_test_screen.dart
/// Description: Test screen untuk preview MaterialListItem widget
///
/// Purpose:
/// - Test MaterialListItem design dengan dummy data
/// - Verify layout, spacing, colors
/// - Test tap interactions
///
/// Note: File ini temporary untuk testing, akan dihapus setelah MaterialListScreen selesai

import 'package:flutter/material.dart';
import '../models/material.dart' as model;
import '../widgets/material_list_item.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/dimensions.dart';

class MaterialTestScreen extends StatefulWidget {
  const MaterialTestScreen({super.key});

  @override
  State<MaterialTestScreen> createState() => _MaterialTestScreenState();
}

class _MaterialTestScreenState extends State<MaterialTestScreen> {
  // Dummy bookmarked items
  final Set<int> _bookmarkedIds = {2, 4};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // List of materials
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  itemCount: _dummyMaterials.length,
                  separatorBuilder:
                      (context, index) =>
                          const SizedBox(height: AppDimensions.spacingM),
                  itemBuilder: (context, index) {
                    final material = _dummyMaterials[index];
                    return MaterialListItem(
                      material: material,
                      onTap: () => _onMaterialTap(material),
                      showBookmark: true,
                      isBookmarked: _bookmarkedIds.contains(material.id),
                      onBookmarkTap: () => _onBookmarkTap(material),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              const Expanded(
                child: Text('Test MaterialListItem', style: AppTextStyles.h3),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingXS),
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.spacingL + AppDimensions.spacingXL,
            ),
            child: Text(
              '${_dummyMaterials.length} materi dummy',
              style: AppTextStyles.body2,
            ),
          ),
        ],
      ),
    );
  }

  /// Handle material tap
  void _onMaterialTap(model.Material material) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tap: ${material.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// Handle bookmark tap
  void _onBookmarkTap(model.Material material) {
    setState(() {
      if (_bookmarkedIds.contains(material.id)) {
        _bookmarkedIds.remove(material.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bookmark dihapus: ${material.title}'),
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        _bookmarkedIds.add(material.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bookmark ditambahkan: ${material.title}'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  /// Dummy materials data untuk testing
  static final List<model.Material> _dummyMaterials = [
    // 0-1 Tahun - Pertumbuhan
    model.Material(
      id: 1,
      category: '0-1',
      subcategory: 'Pertumbuhan',
      title: 'Berat Badan Ideal Bayi 0-6 Bulan',
      content:
          'Berat badan bayi yang ideal adalah salah satu indikator kesehatan yang penting. Pada usia 0-6 bulan, bayi idealnya mengalami penambahan berat badan sekitar 150-200 gram per minggu. Pertumbuhan berat badan yang optimal menunjukkan bahwa bayi mendapatkan nutrisi yang cukup dari ASI atau susu formula. Faktor yang mempengaruhi berat badan bayi antara lain: kualitas dan kuantitas ASI, frekuensi menyusui, kesehatan bayi, dan faktor genetik dari orang tua.',
      tags: 'berat badan, pertumbuhan, bayi, 0-6 bulan, ideal',
    ),

    // 0-1 Tahun - Perkembangan
    model.Material(
      id: 2,
      category: '0-1',
      subcategory: 'Perkembangan',
      title: 'Milestone Perkembangan Bayi 3 Bulan',
      content:
          'Pada usia 3 bulan, bayi mulai menunjukkan perkembangan yang signifikan. Bayi sudah bisa mengangkat kepala saat tengkurap, tersenyum sebagai respons sosial, mengikuti objek bergerak dengan matanya, dan mulai mengeluarkan suara seperti "aah" atau "ooh". Ini adalah fase penting di mana bayi mulai berinteraksi lebih aktif dengan lingkungan sekitarnya. Orang tua perlu memberikan stimulasi yang tepat seperti mengajak bicara, menunjukkan mainan warna-warni, dan memberikan tummy time yang cukup.',
      tags: 'milestone, perkembangan, 3 bulan, motorik, sosial',
    ),

    // 1-2 Tahun - Nutrisi
    model.Material(
      id: 3,
      category: '1-2',
      subcategory: 'Nutrisi',
      title: 'Menu MPASI 12-18 Bulan yang Bergizi',
      content:
          'Pada usia 12-18 bulan, anak sudah bisa mengonsumsi makanan keluarga yang dimodifikasi teksturnya. Menu ideal harus mengandung karbohidrat, protein hewani, protein nabati, sayur, dan buah. Contoh menu: nasi tim dengan ayam, tahu, wortel, dan bayam. Berikan 3 kali makanan utama dan 2-3 kali snack sehat. Pastikan anak mendapat cukup zat besi, zinc, dan kalsium untuk pertumbuhan optimal. Hindari gula berlebih, makanan tinggi garam, dan junk food.',
      tags: 'MPASI, nutrisi, menu, 12-18 bulan, makanan',
    ),

    // 1-2 Tahun - Stimulasi
    model.Material(
      id: 4,
      category: '1-2',
      subcategory: 'Stimulasi',
      title: 'Permainan Edukatif untuk Anak 18 Bulan',
      content:
          'Anak usia 18 bulan sangat aktif dan ingin tahu. Permainan edukatif yang cocok antara lain: menyusun balok, bermain puzzle sederhana, menggambar dengan crayon, bermain dengan boneka atau mobil-mobilan, serta aktivitas sensorik seperti bermain dengan pasir atau air. Permainan ini membantu mengembangkan motorik halus, kognitif, bahasa, dan sosial-emosional. Dampingi anak saat bermain, berikan pujian, dan biarkan anak bereksplorasi dengan aman.',
      tags: 'stimulasi, permainan, edukatif, 18 bulan, aktivitas',
    ),

    // 2-5 Tahun - Perawatan
    model.Material(
      id: 5,
      category: '2-5',
      subcategory: 'Perawatan',
      title: 'Cara Merawat Gigi Anak Balita',
      content:
          'Kesehatan gigi anak perlu dijaga sejak dini. Sikat gigi anak 2 kali sehari menggunakan pasta gigi berfluoride seukuran biji beras (untuk anak di bawah 3 tahun) atau seukuran kacang polong (anak 3-6 tahun). Ajarkan teknik menyikat yang benar, bersihkan semua permukaan gigi dengan gerakan memutar. Batasi konsumsi makanan dan minuman manis. Kunjungi dokter gigi setiap 6 bulan sekali untuk pemeriksaan rutin dan aplikasi fluoride.',
      tags: 'gigi, perawatan, kesehatan, sikat gigi, balita',
    ),

    // 2-5 Tahun - Perkembangan
    model.Material(
      id: 6,
      category: '2-5',
      subcategory: 'Perkembangan',
      title: 'Kesiapan Anak Masuk Sekolah TK',
      content:
          'Kesiapan anak masuk TK bukan hanya soal usia, tapi juga kematangan fisik, emosional, sosial, dan kognitif. Anak sebaiknya sudah bisa: toilet training mandiri, mengikuti instruksi sederhana, berinteraksi dengan teman sebaya, mengungkapkan kebutuhan dengan kata-kata, memegang pensil dengan benar, dan berpisah dengan orang tua tanpa menangis lama. Tidak semua anak siap di usia yang sama, orang tua perlu memperhatikan tanda-tanda kesiapan individual anak.',
      tags: 'sekolah, TK, kesiapan, perkembangan, anak',
    ),
  ];
}

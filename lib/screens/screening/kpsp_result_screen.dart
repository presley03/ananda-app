import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../services/database_service.dart';
import '../../models/child_profile.dart';

class KpspResultScreen extends StatefulWidget {
  final int ageMonths;
  final int score;
  final int totalQuestions;
  final ChildProfile? child;

  const KpspResultScreen({
    super.key,
    required this.ageMonths,
    required this.score,
    this.totalQuestions = 10,
    this.child,
  });

  @override
  State<KpspResultScreen> createState() => _KpspResultScreenState();
}

class _KpspResultScreenState extends State<KpspResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  bool _isSaving = false;
  bool _isSaved = false;

  String get _ageDisplay {
    if (widget.ageMonths < 12) return '${widget.ageMonths} Bulan';
    final y = widget.ageMonths ~/ 12;
    final m = widget.ageMonths % 12;
    return m == 0 ? '$y Tahun' : '$y Tahun $m Bulan';
  }

  String get _status {
    if (widget.score >= 9) return 'Sesuai';
    if (widget.score >= 7) return 'Meragukan';
    return 'Penyimpangan';
  }

  Color get _statusColor {
    if (widget.score >= 9) return AppColors.success;
    if (widget.score >= 7) return AppColors.warning;
    return AppColors.danger;
  }

  IconData get _statusIcon {
    if (widget.score >= 9) return Icons.check_circle_rounded;
    if (widget.score >= 7) return Icons.warning_rounded;
    return Icons.error_rounded;
  }

  String get _statusTitle {
    if (widget.score >= 9) return 'Perkembangan Normal 🎉';
    if (widget.score >= 7) return 'Perlu Perhatian ⚠️';
    return 'Segera Konsultasi ❗';
  }

  String get _recommendation {
    if (widget.score >= 9) {
      return 'Perkembangan anak sesuai usianya. Teruskan stimulasi rutin dan lakukan KPSP kembali 3 bulan kemudian.';
    } else if (widget.score >= 7) {
      return 'Lakukan KPSP ulang 2 minggu kemudian. Tingkatkan stimulasi di rumah. Jika hasil masih meragukan, konsultasikan ke tenaga kesehatan.';
    } else {
      return 'Segera konsultasikan ke dokter spesialis anak atau tenaga kesehatan profesional untuk evaluasi lebih lanjut.';
    }
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    Future.delayed(
      const Duration(milliseconds: 200),
      () => _animController.forward(),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _saveResult() async {
    if (_isSaved || widget.child == null) return;
    setState(() => _isSaving = true);
    try {
      final db = DatabaseService();
      await db.insertScreeningResult({
        'child_id': widget.child!.id,
        'screening_type': 'kpsp',
        'age_months': widget.ageMonths,
        'score': widget.score,
        'result': _status,
        'details': 'Skor ${widget.score}/${widget.totalQuestions}',
        'notes': _recommendation,
        'created_at': DateTime.now().toIso8601String(),
      });
      setState(() {
        _isSaved = true;
        _isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Hasil disimpan! Lihat riwayat di profil anak.',
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Lihat Profil',
              textColor: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hasil KPSP',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Skrining Perkembangan',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Kartu hasil utama
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _statusColor.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Ikon
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: _statusColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _statusIcon,
                              color: _statusColor,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text(
                            _statusTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'KPSP Usia $_ageDisplay',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Skor
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${widget.score}',
                                style: TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w800,
                                  color: _statusColor,
                                  height: 1,
                                ),
                              ),
                              Text(
                                ' / ${widget.totalQuestions}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'jawaban "Ya"',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Interpretasi cepat
                  Row(
                    children: [
                      _buildInterpretBadge('9-10', 'Normal', AppColors.success),
                      const SizedBox(width: 8),
                      _buildInterpretBadge(
                        '7-8',
                        'Meragukan',
                        AppColors.warning,
                      ),
                      const SizedBox(width: 8),
                      _buildInterpretBadge(
                        '≤6',
                        'Penyimpangan',
                        AppColors.danger,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Rekomendasi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.lightbulb_rounded,
                              color: AppColors.accentYellow,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Rekomendasi',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _recommendation,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (widget.child == null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.warning,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Buat profil anak untuk menyimpan riwayat skrining.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Tombol simpan
                  if (widget.child != null)
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: (_isSaved || _isSaving) ? null : _saveResult,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient:
                                _isSaved
                                    ? null
                                    : const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.secondary,
                                      ],
                                    ),
                            color: _isSaved ? AppColors.success : null,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child:
                                _isSaving
                                    ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _isSaved
                                              ? Icons.check_rounded
                                              : Icons.save_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _isSaved
                                              ? 'Tersimpan'
                                              : 'Simpan Hasil',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),

                  // Kembali ke beranda
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'Kembali ke Beranda',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildInterpretBadge(String range, String label, Color color) {
    final isActive = label == _status;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color:
              isActive
                  ? color.withValues(alpha: 0.15)
                  : const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(
              range,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: isActive ? color : AppColors.textHint,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isActive ? color : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../models/mchat_question.dart';
import '../../models/child_profile.dart';
import '../../services/database_service.dart';

class MchatResultScreen extends StatefulWidget {
  final List<MchatQuestion> questions;
  final Map<int, bool> answers;
  final ChildProfile? child;

  const MchatResultScreen({
    super.key,
    required this.questions,
    required this.answers,
    this.child,
  });

  @override
  State<MchatResultScreen> createState() => _MchatResultScreenState();
}

class _MchatResultScreenState extends State<MchatResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  bool _isSaving = false;
  bool _isSaved = false;

  // ── SCORING ──────────────────────────────────────
  // Q2, Q5, Q12: "YA" = risiko (reverse scoring)
  // Lainnya: "TIDAK" = risiko
  int get _totalScore {
    int score = 0;
    for (var q in widget.questions) {
      final answer = widget.answers[q.questionNumber];
      if (answer == null) continue;
      // Q2, Q5 saja yang reverse: "Ya" = risiko
      // Semua lainnya: "Tidak" = risiko
      if ([2, 5].contains(q.questionNumber)) {
        if (answer == true) score++;
      } else {
        if (answer == false) score++;
      }
    }
    return score;
  }

  int get _criticalScore {
    int score = 0;
    for (var q in widget.questions) {
      if (!q.isCritical) continue;
      final answer = widget.answers[q.questionNumber];
      if (answer == null) continue;
      // Q2, Q5 saja yang reverse
      if ([2, 5].contains(q.questionNumber)) {
        if (answer == true) score++;
      } else {
        if (answer == false) score++;
      }
    }
    return score;
  }

  String get _riskLevel {
    if (_totalScore >= 8) return 'high';
    if (_totalScore >= 3) return 'medium';
    return 'low';
  }

  String get _riskDisplay {
    switch (_riskLevel) {
      case 'low':
        return 'Risiko Rendah 🎉';
      case 'medium':
        return 'Risiko Sedang ⚠️';
      case 'high':
        return 'Risiko Tinggi ❗';
      default:
        return '';
    }
  }

  Color get _riskColor {
    switch (_riskLevel) {
      case 'low':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'high':
        return AppColors.danger;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData get _riskIcon {
    switch (_riskLevel) {
      case 'low':
        return Icons.check_circle_rounded;
      case 'medium':
        return Icons.warning_rounded;
      case 'high':
        return Icons.error_rounded;
      default:
        return Icons.help_rounded;
    }
  }

  String get _recommendation {
    switch (_riskLevel) {
      case 'low':
        return 'Hasil skrining menunjukkan risiko rendah. Tidak perlu tindakan lanjutan, kecuali surveilans rutin. Jika anak berusia kurang dari 24 bulan, lakukan skrining ulang setelah ulang tahun kedua.';
      case 'medium':
        return 'Disarankan melakukan follow-up (M-CHAT-R/F tahap kedua) untuk informasi tambahan. Konsultasikan dengan dokter anak atau psikolog untuk evaluasi lebih lanjut.';
      case 'high':
        return 'Segera rujuk ke dokter spesialis anak, psikolog, atau ahli perkembangan anak untuk evaluasi diagnostik lengkap dan eligibilitas intervensi awal.';
      default:
        return '';
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
        'screening_type': 'mchat',
        'age_months': 0,
        'score': _totalScore,
        'result': _riskLevel,
        'details': 'Skor $_totalScore/20 | Kritis: $_criticalScore',
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
          // ── HEADER ──────────────────────────────
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
                          'Hasil M-CHAT-R',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Skrining Autisme (16–30 Bulan)',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── CONTENT ─────────────────────────────
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
                        color: _riskColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _riskColor.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: _riskColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(_riskIcon, color: _riskColor, size: 40),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _riskDisplay,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'M-CHAT-R • 16–30 Bulan',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Skor besar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '$_totalScore',
                                style: TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w800,
                                  color: _riskColor,
                                  height: 1,
                                ),
                              ),
                              const Text(
                                ' / 20',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            'item berisiko',
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

                  // Interpretasi badge (3 level)
                  Row(
                    children: [
                      _buildRiskBadge('0–2', 'Rendah', AppColors.success),
                      const SizedBox(width: 8),
                      _buildRiskBadge('3–7', 'Sedang', AppColors.warning),
                      const SizedBox(width: 8),
                      _buildRiskBadge('8–20', 'Tinggi', AppColors.danger),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Skor kritis
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Item kritis berisiko: $_criticalScore dari 7 item',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
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

                  // Info jika tidak ada profil anak
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

                  // Kembali
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

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskBadge(String range, String label, Color color) {
    final isActive =
        (label == 'Rendah' && _riskLevel == 'low') ||
        (label == 'Sedang' && _riskLevel == 'medium') ||
        (label == 'Tinggi' && _riskLevel == 'high');

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

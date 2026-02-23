import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../models/screening_result.dart';
import '../../services/database_service.dart';

class ScreeningResultDetailScreen extends StatelessWidget {
  final ScreeningResult result;

  const ScreeningResultDetailScreen({super.key, required this.result});

  Future<void> _deleteResult(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Hapus Hasil?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            content: const Text(
              'Hasil skrining ini akan dihapus permanen.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Hapus',
                  style: TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
    );
    if (confirm == true) {
      await DatabaseService().deleteScreeningResult(result.id!);
      if (context.mounted) Navigator.pop(context, true);
    }
  }

  String get _typeLabel {
    switch (result.screeningType) {
      case 'kpsp':
        return 'KPSP';
      case 'nutrition':
        return 'Kalkulator Gizi';
      case 'tdd':
        return 'TDD';
      case 'mchat':
        return 'M-CHAT-R';
      default:
        return 'Skrining';
    }
  }

  String get _typeSubtitle {
    switch (result.screeningType) {
      case 'kpsp':
        return 'Kuesioner Pra Skrining Perkembangan';
      case 'nutrition':
        return 'Nutrisi & Antropometri';
      case 'tdd':
        return 'Tes Daya Dengar';
      case 'mchat':
        return 'Modified Checklist for Autism';
      default:
        return '';
    }
  }

  Color get _resultColor {
    final r = result.result.toLowerCase();
    if (r == 'low' ||
        r.contains('sesuai') ||
        r.contains('normal') ||
        r.contains('baik') ||
        r.contains('rendah')) {
      return AppColors.success;
    } else if (r == 'medium' ||
        r.contains('meragukan') ||
        r.contains('kurang') ||
        r.contains('lebih') ||
        r.contains('sedang')) {
      return AppColors.warning;
    }
    return AppColors.danger;
  }

  IconData get _resultIcon {
    final r = result.result.toLowerCase();
    if (r == 'low' ||
        r.contains('sesuai') ||
        r.contains('normal') ||
        r.contains('baik') ||
        r.contains('rendah')) {
      return Icons.check_circle_rounded;
    } else if (r == 'medium' ||
        r.contains('meragukan') ||
        r.contains('kurang') ||
        r.contains('lebih') ||
        r.contains('sedang')) {
      return Icons.warning_rounded;
    }
    return Icons.error_rounded;
  }

  IconData get _typeIcon {
    switch (result.screeningType) {
      case 'kpsp':
        return Icons.fact_check_rounded;
      case 'nutrition':
        return Icons.restaurant_rounded;
      case 'tdd':
        return Icons.hearing_rounded;
      case 'mchat':
        return Icons.psychology_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  Color get _typeColor {
    switch (result.screeningType) {
      case 'kpsp':
        return AppColors.primary;
      case 'nutrition':
        return AppColors.success;
      case 'tdd':
        return AppColors.accentTeal;
      case 'mchat':
        return AppColors.accentPurple;
      default:
        return AppColors.primary;
    }
  }

  String get _ageDisplay {
    final months = result.ageMonths;
    if (months < 12) return '$months bulan';
    final y = months ~/ 12;
    final m = months % 12;
    return m == 0 ? '$y tahun' : '$y tahun $m bulan';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Kartu hasil
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _resultColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _resultColor.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: _resultColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _resultIcon,
                            color: _resultColor,
                            size: 38,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          result.result,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: _resultColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hasil $_typeLabel',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        if (result.score != null) ...[
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${result.score}',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w800,
                                  color: _resultColor,
                                  height: 1,
                                ),
                              ),
                              Text(
                                ' / ${result.screeningType == 'mchat' ? 20 : 10}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            result.screeningType == 'mchat'
                                ? 'item berisiko'
                                : 'jawaban "Ya"',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info detail
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          Icons.calendar_today_rounded,
                          'Tanggal',
                          result.formattedDate,
                        ),
                        const SizedBox(height: 10),
                        _buildInfoRow(
                          Icons.child_care_rounded,
                          'Usia saat skrining',
                          _ageDisplay,
                        ),
                        if (result.details != null &&
                            result.details!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _buildInfoRow(
                            Icons.info_outline_rounded,
                            'Detail',
                            result.details!,
                          ),
                        ],
                      ],
                    ),
                  ),

                  if (result.notes != null && result.notes!.isNotEmpty) ...[
                    const SizedBox(height: 16),
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
                            result.notes!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'Kembali',
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_typeColor, _typeColor.withValues(alpha: 0.7)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_typeIcon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _typeLabel,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _typeSubtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              // Tombol hapus
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                ),
                onPressed: () => _deleteResult(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

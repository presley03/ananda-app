import 'package:flutter/material.dart';
import '../../models/nutrition_measurement.dart';
import '../../models/nutrition_result.dart';
import '../../models/child_profile.dart';
import '../../services/database_service.dart';
import '../../utils/constants/colors.dart';

class NutritionResultScreen extends StatefulWidget {
  final NutritionMeasurement measurement;
  final NutritionResult result;
  final ChildProfile? child;

  const NutritionResultScreen({
    super.key,
    required this.measurement,
    required this.result,
    this.child,
  });

  @override
  State<NutritionResultScreen> createState() => _NutritionResultScreenState();
}

class _NutritionResultScreenState extends State<NutritionResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  bool _isSaving = false;
  bool _isSaved = false;

  static const Color _green = Color(0xFF27AE60);
  static const Color _greenLight = Color(0xFF2ECC71);

  Color get _statusColor {
    switch (widget.result.statusColor) {
      case 'success':
        return AppColors.success;
      case 'warning':
        return AppColors.warning;
      case 'danger':
        return AppColors.danger;
      default:
        return AppColors.info;
    }
  }

  IconData get _statusIcon {
    switch (widget.result.statusColor) {
      case 'success':
        return Icons.check_circle_rounded;
      case 'warning':
        return Icons.warning_rounded;
      case 'danger':
        return Icons.error_rounded;
      default:
        return Icons.info_rounded;
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

  Future<void> _save() async {
    if (_isSaved || widget.child == null) return;
    setState(() => _isSaving = true);
    try {
      await DatabaseService().insertScreeningResult({
        'child_id': widget.child!.id,
        'screening_type': 'nutrition',
        'age_months': widget.measurement.ageMonths,
        'score': (widget.measurement.weight * 10).round(),
        'result': widget.result.overallStatus,
        'details':
            'BB: ${widget.measurement.weight}kg, TB: ${widget.measurement.height}cm, IMT: ${widget.result.bmi.toStringAsFixed(1)}',
        'notes': widget.result.recommendation,
        'created_at': DateTime.now().toIso8601String(),
      });
      setState(() {
        _isSaved = true;
        _isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hasil disimpan ke profil ${widget.child!.name}'),
            backgroundColor: AppColors.success,
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan hasil'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_green, _greenLight],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 20, 28),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hasil Status Gizi',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${widget.measurement.genderDisplay}  |  ${widget.measurement.ageDisplay}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  // Status utama
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _statusColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(_statusIcon, color: _statusColor, size: 56),
                          const SizedBox(height: 12),
                          const Text(
                            'Status Gizi',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.result.overallStatus,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: _statusColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Data pengukuran
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('DATA PENGUKURAN'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _measureItem(
                                Icons.monitor_weight_outlined,
                                AppColors.primary,
                                'Berat Badan',
                                '${widget.measurement.weight} kg',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _measureItem(
                                Icons.height_rounded,
                                _green,
                                widget.measurement.measurementType == 'PB'
                                    ? 'Panjang Badan'
                                    : 'Tinggi Badan',
                                '${widget.measurement.height} cm',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _measureItem(
                          Icons.assessment_rounded,
                          AppColors.info,
                          'IMT (Indeks Massa Tubuh)',
                          widget.result.bmi.toStringAsFixed(2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Hasil detail Z-Score
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('DETAIL Z-SCORE'),
                        const SizedBox(height: 12),
                        _zScoreRow(
                          'BB/U  (Berat menurut Umur)',
                          widget.result.zScoreWeightForAge,
                          widget.result.weightForAgeStatus,
                        ),
                        _divider(),
                        _zScoreRow(
                          '${widget.measurement.measurementType}/U  (Tinggi menurut Umur)',
                          widget.result.zScoreHeightForAge,
                          widget.result.heightForAgeStatus,
                        ),
                        _divider(),
                        _zScoreRow(
                          'BB/${widget.measurement.measurementType}  (Berat menurut Tinggi)',
                          widget.result.zScoreWeightForHeight,
                          widget.result.weightForHeightStatus,
                        ),
                        _divider(),
                        _zScoreRow(
                          'IMT/U  (IMT menurut Umur)',
                          widget.result.zScoreBMIForAge,
                          widget.result.bmiForAgeStatus,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Rekomendasi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.info.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              color: AppColors.info,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Rekomendasi',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.info,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.result.recommendation,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Panduan Z-Score
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionLabel('PANDUAN INTERPRETASI Z-SCORE'),
                        const SizedBox(height: 12),
                        _guideItem(
                          '< -3 SD',
                          'Sangat kurang / Buruk',
                          AppColors.danger,
                        ),
                        _guideItem(
                          '-3 s.d. < -2 SD',
                          'Kurang',
                          AppColors.warning,
                        ),
                        _guideItem(
                          '-2 s.d. +1 SD',
                          'Normal / Baik',
                          AppColors.success,
                        ),
                        _guideItem(
                          '+1 s.d. +2 SD',
                          'Berisiko lebih',
                          AppColors.warning,
                        ),
                        _guideItem('> +3 SD', 'Obesitas', AppColors.danger),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // TOMBOL SIMPAN - fixed di bawah
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              children: [
                if (widget.child != null && !_isSaved)
                  GestureDetector(
                    onTap: _isSaving ? null : _save,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_green, _greenLight],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child:
                            _isSaving
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.save_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Simpan Hasil',
                                      style: TextStyle(
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
                if (_isSaved)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.success, width: 1.5),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Hasil Tersimpan',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.child == null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'Pilih profil anak untuk menyimpan hasil',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textHint,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Center(
                      child: Text(
                        'Kembali',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: AppColors.textSecondary,
      letterSpacing: 1.2,
    ),
  );

  Widget _measureItem(IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: AppColors.textHint),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _zScoreRow(String label, double zScore, String status) {
    final color = _zScoreColor(zScore);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.result.formatZScore(zScore),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _zScoreColor(double z) {
    if (z < -3 || z > 3) return AppColors.danger;
    if (z < -2 || z > 2) return AppColors.warning;
    return AppColors.success;
  }

  Widget _divider() => Divider(height: 1, color: Colors.grey.shade100);

  Widget _guideItem(String range, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$range: $label',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

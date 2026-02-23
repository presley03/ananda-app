import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../models/kpsp_question.dart';
import '../../models/child_profile.dart';
import 'kpsp_result_screen.dart';

class KpspQuestionsScreen extends StatefulWidget {
  final int ageMonths;
  final List<KpspQuestion> questions;
  final ChildProfile? child;

  const KpspQuestionsScreen({
    super.key,
    required this.ageMonths,
    required this.questions,
    this.child,
  });

  @override
  State<KpspQuestionsScreen> createState() => _KpspQuestionsScreenState();
}

class _KpspQuestionsScreenState extends State<KpspQuestionsScreen>
    with TickerProviderStateMixin {
  final List<bool?> _answers = List.filled(10, null);
  int _currentIndex = 0;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _isAnimating = false;

  KpspQuestion get _current => widget.questions[_currentIndex];
  int get _total => widget.questions.length;
  bool get _isLast => _currentIndex == _total - 1;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _answer(bool value) async {
    if (_isAnimating) return;
    setState(() {
      _answers[_currentIndex] = value;
      _isAnimating = true;
    });
    await Future.delayed(const Duration(milliseconds: 350));
    if (_isLast) {
      _goToResult();
      return;
    }
    _slideController.reset();
    setState(() {
      _currentIndex++;
      _isAnimating = false;
    });
    _slideController.forward();
  }

  void _goBack() {
    if (_currentIndex == 0) {
      Navigator.pop(context);
      return;
    }
    _slideController.reset();
    setState(() {
      _currentIndex--;
      _isAnimating = false;
    });
    _slideController.forward();
  }

  void _goToResult() {
    final score = _answers.where((a) => a == true).length;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => KpspResultScreen(
              ageMonths: widget.ageMonths,
              score: score,
              totalQuestions: _total,
              child: widget.child,
            ),
      ),
    );
  }

  Color _aspectColor(String aspect) {
    switch (aspect.toLowerCase()) {
      case 'motorik kasar':
        return const Color(0xFFFF6B6B);
      case 'motorik halus':
        return const Color(0xFF5B9BD5);
      case 'bicara & bahasa':
      case 'bicara dan bahasa':
        return AppColors.accentPurple;
      default:
        return AppColors.success;
    }
  }

  IconData _aspectIcon(String aspect) {
    switch (aspect.toLowerCase()) {
      case 'motorik kasar':
        return Icons.directions_run_rounded;
      case 'motorik halus':
        return Icons.pan_tool_rounded;
      case 'bicara & bahasa':
      case 'bicara dan bahasa':
        return Icons.record_voice_over_rounded;
      default:
        return Icons.people_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _aspectColor(_current.aspect);
    final progress = (_currentIndex + 1) / _total;
    final currentAnswer = _answers[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppColors.textPrimary,
                    onPressed: _goBack,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KPSP ${_current.ageDisplay}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Pertanyaan ${_currentIndex + 1} dari $_total',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '${_currentIndex + 1}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── PROGRESS BAR ─────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: const Color(0xFFEEEEEE),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_answers.where((a) => a != null).length} dijawab',
                        style: TextStyle(fontSize: 11, color: color),
                      ),
                      Text(
                        '${_total - _answers.where((a) => a != null).length} tersisa',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── PERTANYAAN (di tengah area) ──────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge aspek
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _aspectIcon(_current.aspect),
                              color: color,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _current.aspect,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Teks pertanyaan
                      Text(
                        _current.questionText,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          height: 1.55,
                        ),
                      ),

                      // Jawaban sebelumnya
                      if (currentAnswer != null) ...[
                        const SizedBox(height: 24),
                        Center(
                          child: AnimatedOpacity(
                            opacity: 1,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    currentAnswer == true
                                        ? AppColors.success.withValues(
                                          alpha: 0.1,
                                        )
                                        : AppColors.danger.withValues(
                                          alpha: 0.1,
                                        ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                currentAnswer == true
                                    ? '✓ Sudah dijawab: Ya'
                                    : '✗ Sudah dijawab: Tidak',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      currentAnswer == true
                                          ? AppColors.success
                                          : AppColors.danger,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // ── TOMBOL JAWABAN (tetap di bawah) ──────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _answer(false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color:
                              currentAnswer == false
                                  ? AppColors.danger.withValues(alpha: 0.12)
                                  : const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                currentAnswer == false
                                    ? AppColors.danger
                                    : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: const Column(
                          children: [
                            Text('✕', style: TextStyle(fontSize: 22)),
                            SizedBox(height: 4),
                            Text(
                              'Tidak',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.danger,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _answer(true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color:
                              currentAnswer == true
                                  ? AppColors.success.withValues(alpha: 0.12)
                                  : const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                currentAnswer == true
                                    ? AppColors.success
                                    : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: const Column(
                          children: [
                            Text('✓', style: TextStyle(fontSize: 22)),
                            SizedBox(height: 4),
                            Text(
                              'Ya',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Hint text
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: Text(
                  _isLast
                      ? 'Jawab untuk melihat hasil'
                      : 'Pilih jawaban untuk lanjut otomatis',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

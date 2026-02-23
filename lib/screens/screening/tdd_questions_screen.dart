import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../models/tdd_question.dart';
import '../../models/child_profile.dart';
import '../../utils/helpers/tdd_data_loader.dart';
import 'tdd_result_screen.dart';

class TddQuestionsScreen extends StatefulWidget {
  final String ageRange;
  final ChildProfile? child;

  const TddQuestionsScreen({super.key, required this.ageRange, this.child});

  @override
  State<TddQuestionsScreen> createState() => _TddQuestionsScreenState();
}

class _TddQuestionsScreenState extends State<TddQuestionsScreen>
    with TickerProviderStateMixin {
  List<TddQuestion> _questions = [];
  final Map<int, bool> _answers = {};
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isAnimating = false;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

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
    _loadQuestions();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    final questions = await TddDataLoader.loadQuestions(widget.ageRange);
    if (questions == null || questions.isEmpty) {
      if (mounted) Navigator.pop(context);
      return;
    }
    setState(() {
      _questions = questions;
      _isLoading = false;
    });
    _slideController.forward();
  }

  TddQuestion get _current => _questions[_currentIndex];
  int get _total => _questions.length;
  bool get _isLast => _currentIndex == _total - 1;

  Future<void> _answer(bool value) async {
    if (_isAnimating) return;
    setState(() {
      _answers[_current.questionNumber] = value;
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
    final yesCount = _answers.values.where((a) => a == true).length;
    final isPassed = yesCount == _total;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) => TddResultScreen(
              ageRange: widget.ageRange,
              totalQuestions: _total,
              yesCount: yesCount,
              isPassed: isPassed,
              child: widget.child,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    const accent = AppColors.accentTeal;
    final progress = (_currentIndex + 1) / _total;
    final currentAnswer = _answers[_current.questionNumber];

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
                          'TDD ${TddDataLoader.getAgeRangeDisplayName(widget.ageRange)}',
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
                      color: accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '${_currentIndex + 1}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: accent,
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
                      valueColor: const AlwaysStoppedAnimation<Color>(accent),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_answers.length} dijawab',
                        style: const TextStyle(fontSize: 11, color: accent),
                      ),
                      Text(
                        '${_total - _answers.length} tersisa',
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
                      // Badge Daya Dengar
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.hearing_rounded,
                              color: accent,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Daya Dengar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: accent,
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

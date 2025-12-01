import 'package:flutter/material.dart';
import '../../models/tdd_question.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/helpers/tdd_data_loader.dart';
import 'tdd_result_screen.dart';

/// Screen untuk menjawab pertanyaan TDD
/// Format: Ya/Tidak untuk setiap pertanyaan
class TddQuestionsScreen extends StatefulWidget {
  final String ageRange;

  const TddQuestionsScreen({super.key, required this.ageRange});

  @override
  State<TddQuestionsScreen> createState() => _TddQuestionsScreenState();
}

class _TddQuestionsScreenState extends State<TddQuestionsScreen> {
  List<TddQuestion> _questions = [];
  final Map<int, bool> _answers =
      {}; // questionNumber -> answer (true=Ya, false=Tidak)
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  /// Load pertanyaan dari JSON
  Future<void> _loadQuestions() async {
    final questions = await TddDataLoader.loadQuestions(widget.ageRange);

    if (questions == null || questions.isEmpty) {
      // Data tidak ditemukan
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal memuat data pertanyaan'),
            backgroundColor: AppColors.danger,
          ),
        );
        Navigator.pop(context);
      }
      return;
    }

    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  /// Answer current question
  void _answerQuestion(bool answer) {
    setState(() {
      _answers[_questions[_currentIndex].questionNumber] = answer;
    });
  }

  /// Navigate to next question
  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      // Check if current question answered
      if (_answers[_questions[_currentIndex].questionNumber] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Silakan jawab pertanyaan terlebih dahulu'),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }

      setState(() {
        _currentIndex++;
      });
    }
  }

  /// Navigate to previous question
  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  /// Finish test and show result
  void _finishTest() {
    // Validate all questions answered
    for (var question in _questions) {
      if (_answers[question.questionNumber] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap jawab semua pertanyaan terlebih dahulu'),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }
    }

    // Calculate result
    int yesCount = _answers.values.where((answer) => answer == true).length;
    bool isPassed = yesCount == _questions.length; // Semua harus "Ya"

    // Navigate to result screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TddResultScreen(
              ageRange: widget.ageRange,
              totalQuestions: _questions.length,
              yesCount: yesCount,
              isPassed: isPassed,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final currentQuestion = _questions[_currentIndex];
    final currentAnswer = _answers[currentQuestion.questionNumber];

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
              _buildHeader(),
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildQuestionCard(currentQuestion, currentAnswer),
                      const SizedBox(height: AppDimensions.spacingL),
                      _buildAnswerButtons(currentAnswer),
                      const SizedBox(height: AppDimensions.spacingL),
                      _buildNavigationButtons(),
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

  /// Header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tes Daya Dengar',
                  style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                ),
                Text(
                  TddDataLoader.getAgeRangeDisplayName(widget.ageRange),
                  style: AppTextStyles.body2,
                ),
              ],
            ),
          ),
          Text(
            '${_currentIndex + 1}/${_questions.length}',
            style: AppTextStyles.h4.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  /// Progress bar
  Widget _buildProgressBar() {
    final progress = (_currentIndex + 1) / _questions.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.glassBorder,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Pertanyaan ${_currentIndex + 1} dari ${_questions.length}',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  /// Question card
  Widget _buildQuestionCard(TddQuestion question, bool? answer) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.glassBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Text(
                  'Pertanyaan ${question.questionNumber}',
                  style: AppTextStyles.label.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              // Category badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Text(
                  question.categoryDisplay,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingL),
          // Question text
          Text(question.questionText, style: AppTextStyles.h4),
        ],
      ),
    );
  }

  /// Answer buttons (Ya/Tidak)
  Widget _buildAnswerButtons(bool? currentAnswer) {
    return Row(
      children: [
        // Tombol Ya
        Expanded(
          child: _buildAnswerButton(
            label: 'Ya',
            icon: Icons.check_circle,
            color: AppColors.success,
            isSelected: currentAnswer == true,
            onTap: () => _answerQuestion(true),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingM),
        // Tombol Tidak
        Expanded(
          child: _buildAnswerButton(
            label: 'Tidak',
            icon: Icons.cancel,
            color: AppColors.danger,
            isSelected: currentAnswer == false,
            onTap: () => _answerQuestion(false),
          ),
        ),
      ],
    );
  }

  /// Single answer button
  Widget _buildAnswerButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : AppColors.glassWhite,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: isSelected ? color : AppColors.glassBorder,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: AppDimensions.iconL,
              color: isSelected ? color : AppColors.textHint,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              label,
              style: AppTextStyles.h3.copyWith(
                color: isSelected ? color : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Navigation buttons
  Widget _buildNavigationButtons() {
    final isLastQuestion = _currentIndex == _questions.length - 1;

    return Row(
      children: [
        // Tombol Sebelumnya
        if (_currentIndex > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousQuestion,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 2),
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
              child: Text(
                'Sebelumnya',
                style: AppTextStyles.h4.copyWith(color: AppColors.primary),
              ),
            ),
          ),

        if (_currentIndex > 0) const SizedBox(width: AppDimensions.spacingM),

        // Tombol Selanjutnya/Selesai
        Expanded(
          flex: _currentIndex > 0 ? 1 : 2,
          child: ElevatedButton(
            onPressed: isLastQuestion ? _finishTest : _nextQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            child: Text(
              isLastQuestion ? 'Selesai' : 'Selanjutnya',
              style: AppTextStyles.h4.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

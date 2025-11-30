import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';
import '../../models/kpsp_question.dart';
import 'kpsp_result_screen.dart';

/// KPSP Questions Screen
/// Screen untuk menjawab 10 pertanyaan KPSP
/// Setiap pertanyaan dijawab dengan Ya (1 poin) atau Tidak (0 poin)
class KpspQuestionsScreen extends StatefulWidget {
  final int ageMonths;
  final List<KpspQuestion> questions;

  const KpspQuestionsScreen({
    super.key,
    required this.ageMonths,
    required this.questions,
  });

  @override
  State<KpspQuestionsScreen> createState() => _KpspQuestionsScreenState();
}

class _KpspQuestionsScreenState extends State<KpspQuestionsScreen> {
  // Menyimpan jawaban (null = belum dijawab, true = Ya, false = Tidak)
  final List<bool?> _answers = List.filled(10, null);

  // Index pertanyaan yang sedang ditampilkan
  int _currentQuestionIndex = 0;

  // Get current question
  KpspQuestion get _currentQuestion => widget.questions[_currentQuestionIndex];

  // Check if current question is answered
  bool get _isCurrentQuestionAnswered =>
      _answers[_currentQuestionIndex] != null;

  // Check if all questions are answered
  bool get _allQuestionsAnswered => !_answers.contains(null);

  // Calculate score (jumlah jawaban "Ya")
  int get _score {
    return _answers.where((answer) => answer == true).length;
  }

  // Answer current question
  void _answerQuestion(bool answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
    });
  }

  // Go to next question
  void _nextQuestion() {
    if (_currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  // Go to previous question
  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  // Finish and show result
  void _finish() {
    if (!_allQuestionsAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon jawab semua pertanyaan terlebih dahulu'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Navigate to result screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => KpspResultScreen(
              ageMonths: widget.ageMonths,
              score: _score,
              totalQuestions: widget.questions.length,
            ),
      ),
    );
  }

  // Get age display
  String _getAgeDisplay() {
    final months = widget.ageMonths;
    if (months < 12) {
      return '$months Bulan';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years Tahun';
      } else {
        return '$years Tahun $remainingMonths Bulan';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
              _buildHeader(),

              // Progress indicator
              _buildProgressIndicator(),

              SizedBox(height: AppDimensions.spacingL),

              // Question card
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingM,
                    ),
                    child: _buildQuestionCard(),
                  ),
                ),
              ),

              // Navigation buttons
              _buildNavigationButtons(),

              SizedBox(height: AppDimensions.spacingM),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back),
            color: AppColors.textPrimary,
          ),
          SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('KPSP ${_getAgeDisplay()}', style: AppTextStyles.h3),
                SizedBox(height: AppDimensions.spacingXS),
                Text(
                  'Pertanyaan ${_currentQuestionIndex + 1} dari ${widget.questions.length}',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${_answers.where((a) => a != null).length}/${widget.questions.length} dijawab',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spacingS),
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / widget.questions.length,
            backgroundColor: AppColors.glassWhite,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.glassBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number and aspect
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Text(
                  'No. ${_currentQuestion.questionNumber}',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                    vertical: AppDimensions.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Text(
                    _currentQuestion.aspectDisplay,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.spacingL),

          // Question text
          Text(_currentQuestion.questionText, style: AppTextStyles.h4),

          SizedBox(height: AppDimensions.spacingXL),

          // Answer buttons
          Row(
            children: [
              // Ya button
              Expanded(
                child: _AnswerButton(
                  label: 'Ya',
                  isSelected: _answers[_currentQuestionIndex] == true,
                  color: AppColors.success,
                  onTap: () => _answerQuestion(true),
                ),
              ),
              SizedBox(width: AppDimensions.spacingM),
              // Tidak button
              Expanded(
                child: _AnswerButton(
                  label: 'Tidak',
                  isSelected: _answers[_currentQuestionIndex] == false,
                  color: AppColors.danger,
                  onTap: () => _answerQuestion(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
      child: Row(
        children: [
          // Previous button
          if (_currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _previousQuestion,
                icon: Icon(Icons.arrow_back),
                label: Text('Sebelumnya'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.spacingM,
                  ),
                ),
              ),
            ),

          if (_currentQuestionIndex > 0)
            SizedBox(width: AppDimensions.spacingM),

          // Next/Finish button
          Expanded(
            flex: _currentQuestionIndex > 0 ? 1 : 1,
            child: ElevatedButton.icon(
              onPressed:
                  _isCurrentQuestionAnswered
                      ? (_currentQuestionIndex == widget.questions.length - 1
                          ? _finish
                          : _nextQuestion)
                      : null,
              icon: Icon(
                _currentQuestionIndex == widget.questions.length - 1
                    ? Icons.check
                    : Icons.arrow_forward,
              ),
              label: Text(
                _currentQuestionIndex == widget.questions.length - 1
                    ? 'Selesai'
                    : 'Selanjutnya',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.textHint,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Answer Button Widget
class _AnswerButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _AnswerButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppDimensions.spacingL),
          decoration: BoxDecoration(
            color: isSelected ? color : AppColors.glassWhite,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: isSelected ? color : AppColors.glassBorder,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.h3.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

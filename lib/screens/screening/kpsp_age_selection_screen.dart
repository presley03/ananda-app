import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/helpers/kpsp_data_loader.dart';
import 'kpsp_questions_screen.dart';

/// KPSP Age Selection Screen
/// Screen untuk memilih umur anak sebelum mulai KPSP
/// 16 pilihan umur: 3, 6, 9, 12, 15, 18, 21, 24, 30, 36, 42, 48, 54, 60, 66, 72 bulan
class KpspAgeSelectionScreen extends StatefulWidget {
  const KpspAgeSelectionScreen({super.key});

  @override
  State<KpspAgeSelectionScreen> createState() => _KpspAgeSelectionScreenState();
}

class _KpspAgeSelectionScreenState extends State<KpspAgeSelectionScreen> {
  // List umur yang tersedia (dalam bulan)
  static const List<int> availableAges = [
    3,
    6,
    9,
    12,
    15,
    18,
    21,
    24,
    30,
    36,
    42,
    48,
    54,
    60,
    66,
    72,
  ];

  // Track which ages have data available
  Map<int, bool> _dataAvailability = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkDataAvailability();
  }

  // Check data availability for all ages
  Future<void> _checkDataAvailability() async {
    final Map<int, bool> availability = {};

    for (int age in availableAges) {
      availability[age] = await KpspDataLoader.isDataAvailable(age);
    }

    if (mounted) {
      setState(() {
        _dataAvailability = availability;
        _isLoading = false;
      });
    }
  }

  // Convert bulan ke display text
  String _getAgeDisplay(int months) {
    if (months < 12) {
      return '$months Bulan';
    } else if (months == 12) {
      return '1 Tahun';
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

  // Handle age selection
  Future<void> _onAgeSelected(int ageMonths) async {
    final hasData = _dataAvailability[ageMonths] ?? false;

    if (!hasData) {
      // Show message: data belum tersedia
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Data KPSP untuk ${_getAgeDisplay(ageMonths)} belum tersedia',
          ),
          backgroundColor: AppColors.warning,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Show loading
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
    );

    // Load questions from JSON
    final questions = await KpspDataLoader.loadQuestions(ageMonths);

    // Hide loading
    if (!mounted) return;
    Navigator.pop(context);

    if (questions == null || questions.isEmpty) {
      // Error loading
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data KPSP'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    // Navigate to questions screen
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                KpspQuestionsScreen(ageMonths: ageMonths, questions: questions),
      ),
    );
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
              Padding(
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
                          Text('KPSP Screening', style: AppTextStyles.h2),
                          SizedBox(height: AppDimensions.spacingXS),
                          Text(
                            'Pilih umur anak Anda',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.spacingL),

              // Info card
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                ),
                child: Container(
                  padding: EdgeInsets.all(AppDimensions.spacingM),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.info,
                        size: AppDimensions.iconM,
                      ),
                      SizedBox(width: AppDimensions.spacingM),
                      Expanded(
                        child: Text(
                          'Pilih umur yang paling mendekati umur anak Anda saat ini',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppDimensions.spacingL),

              // Grid umur
              Expanded(
                child:
                    _isLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                        : GridView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacingM,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.5,
                                crossAxisSpacing: AppDimensions.spacingM,
                                mainAxisSpacing: AppDimensions.spacingM,
                              ),
                          itemCount: availableAges.length,
                          itemBuilder: (context, index) {
                            final ageMonths = availableAges[index];
                            final hasData =
                                _dataAvailability[ageMonths] ?? false;

                            return _AgeCard(
                              ageMonths: ageMonths,
                              ageDisplay: _getAgeDisplay(ageMonths),
                              hasData: hasData,
                              onTap: () => _onAgeSelected(ageMonths),
                            );
                          },
                        ),
              ),

              SizedBox(height: AppDimensions.spacingM),
            ],
          ),
        ),
      ),
    );
  }
}

/// Age Card Widget
class _AgeCard extends StatelessWidget {
  final int ageMonths;
  final String ageDisplay;
  final bool hasData;
  final VoidCallback onTap;

  const _AgeCard({
    required this.ageMonths,
    required this.ageDisplay,
    required this.hasData,
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
          decoration: BoxDecoration(
            color:
                hasData
                    ? AppColors.glassWhite
                    : AppColors.glassWhite.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color:
                  hasData
                      ? AppColors.glassBorder
                      : AppColors.glassBorder.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.child_care,
                      color: hasData ? AppColors.primary : AppColors.textHint,
                      size: AppDimensions.iconM,
                    ),
                    SizedBox(height: AppDimensions.spacingS),
                    Text(
                      ageDisplay,
                      style: AppTextStyles.h4.copyWith(
                        color:
                            hasData
                                ? AppColors.textPrimary
                                : AppColors.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (!hasData)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingXS,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusS,
                      ),
                    ),
                    child: Text(
                      'Soon',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

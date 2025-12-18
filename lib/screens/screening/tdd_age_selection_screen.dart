import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/helpers/tdd_data_loader.dart';
import 'tdd_questions_screen.dart';

/// Screen untuk memilih rentang usia TDD
/// 6 pilihan: <3, 3-6, 6-12, 12-24, 24-36, >36 bulan
class TddAgeSelectionScreen extends StatefulWidget {
  const TddAgeSelectionScreen({super.key});

  @override
  State<TddAgeSelectionScreen> createState() => _TddAgeSelectionScreenState();
}

class _TddAgeSelectionScreenState extends State<TddAgeSelectionScreen> {
  // List semua age ranges
  final List<String> _ageRanges = [
    '<3',
    '3-6',
    '6-12',
    '12-24',
    '24-36',
    '>36',
  ];

  // Map untuk track data availability
  Map<String, bool> _dataAvailability = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkDataAvailability();
  }

  /// Check data availability untuk semua age ranges
  Future<void> _checkDataAvailability() async {
    final Map<String, bool> availability = {};

    for (String ageRange in _ageRanges) {
      availability[ageRange] = await TddDataLoader.isDataAvailable(ageRange);
    }

    setState(() {
      _dataAvailability = availability;
      _isLoading = false;
    });
  }

  /// Navigate ke questions screen
  void _onAgeRangeSelected(String ageRange) async {
    // Check data availability
    if (_dataAvailability[ageRange] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Data untuk ${TddDataLoader.getAgeRangeDisplayName(ageRange)} belum tersedia',
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    // Navigate ke questions screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TddQuestionsScreen(ageRange: ageRange),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                          padding: const EdgeInsets.all(AppDimensions.spacingM),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildInfoCard(),
                              const SizedBox(height: AppDimensions.spacingL),
                              _buildAgeRangeGrid(),
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

  /// Header dengan back button
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
                  'Tes Daya Dengar (TDD)',
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                ),
                Text('Pilih rentang usia anak', style: AppTextStyles.body2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Info card dengan instruksi
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.glassBorder, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingS),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: const Icon(
              Icons.hearing,
              color: AppColors.info,
              size: AppDimensions.iconM,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tentang TDD',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                Text(
                  'Tes untuk menemukan gangguan pendengaran sejak dini. Semua pertanyaan harus dijawab "Ya" untuk hasil normal.',
                  style: AppTextStyles.body2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Grid pilihan age ranges
  Widget _buildAgeRangeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppDimensions.spacingM,
        mainAxisSpacing: AppDimensions.spacingM,
        childAspectRatio: 1.2, // Diperbesar dari 1.5 ke 1.2 (lebih tinggi)
      ),
      itemCount: _ageRanges.length,
      itemBuilder: (context, index) {
        final ageRange = _ageRanges[index];
        final isAvailable = _dataAvailability[ageRange] ?? false;

        return _buildAgeRangeCard(ageRange, isAvailable);
      },
    );
  }

  /// Card untuk satu age range
  Widget _buildAgeRangeCard(String ageRange, bool isAvailable) {
    return GestureDetector(
      onTap: () => _onAgeRangeSelected(ageRange),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: isAvailable ? AppColors.primary : AppColors.glassBorder,
            width: isAvailable ? 2 : 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              Icons.hearing,
              size: AppDimensions.iconL,
              color: isAvailable ? AppColors.primary : AppColors.textHint,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            // Age range text
            Text(
              TddDataLoader.getAgeRangeDisplayName(ageRange),
              style: AppTextStyles.body1.copyWith(
                fontSize: 13,
                color:
                    isAvailable ? AppColors.primary : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Badge "Soon" jika belum ada data
            if (!isAvailable) ...[
              const SizedBox(height: AppDimensions.spacingXS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingS,
                  vertical: AppDimensions.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Text(
                  'Soon',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

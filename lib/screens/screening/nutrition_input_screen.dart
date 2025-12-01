import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/nutrition_measurement.dart';
import '../../services/nutrition_calculator.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';
import 'nutrition_result_screen.dart';

/// Screen untuk input data pengukuran gizi anak
/// Input: Berat, Tinggi, Umur, Jenis Kelamin
class NutritionInputScreen extends StatefulWidget {
  const NutritionInputScreen({super.key});

  @override
  State<NutritionInputScreen> createState() => _NutritionInputScreenState();
}

class _NutritionInputScreenState extends State<NutritionInputScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk input
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageYearsController = TextEditingController();
  final _ageMonthsController = TextEditingController();

  // Pilihan gender
  String _selectedGender = 'L'; // Default: Laki-laki

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageYearsController.dispose();
    _ageMonthsController.dispose();
    super.dispose();
  }

  /// Validasi dan hitung status gizi
  void _calculateNutrition() {
    if (_formKey.currentState!.validate()) {
      // Parse input
      final weight = double.parse(_weightController.text);
      final height = double.parse(_heightController.text);
      final ageYears = int.parse(
        _ageYearsController.text.isEmpty ? '0' : _ageYearsController.text,
      );
      final ageMonths = int.parse(
        _ageMonthsController.text.isEmpty ? '0' : _ageMonthsController.text,
      );
      final totalAgeMonths = (ageYears * 12) + ageMonths;

      // Validasi umur (maksimal 5 tahun = 60 bulan)
      if (totalAgeMonths > 60) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Umur maksimal 5 tahun (60 bulan)'),
            backgroundColor: AppColors.danger,
          ),
        );
        return;
      }

      if (totalAgeMonths == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Umur harus diisi'),
            backgroundColor: AppColors.danger,
          ),
        );
        return;
      }

      // Buat object measurement
      final measurement = NutritionMeasurement(
        weight: weight,
        height: height,
        ageMonths: totalAgeMonths,
        gender: _selectedGender,
        measurementDate: DateTime.now(),
      );

      // Hitung Z-Score
      final result = NutritionCalculator.calculate(measurement);

      // Navigate ke result screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => NutritionResultScreen(
                measurement: measurement,
                result: result,
              ),
        ),
      );
    }
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildInfoCard(),
                        const SizedBox(height: AppDimensions.spacingL),
                        _buildWeightInput(),
                        const SizedBox(height: AppDimensions.spacingM),
                        _buildHeightInput(),
                        const SizedBox(height: AppDimensions.spacingM),
                        _buildAgeInput(),
                        const SizedBox(height: AppDimensions.spacingM),
                        _buildGenderSelector(),
                        const SizedBox(height: AppDimensions.spacingXL),
                        _buildCalculateButton(),
                      ],
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
          Text(
            'Kalkulator Status Gizi',
            style: AppTextStyles.h2.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  /// Info card instruksi
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
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: const Icon(
              Icons.info_outline,
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
                  'Petunjuk Pengisian',
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                Text(
                  'Isi data pengukuran anak untuk menghitung status gizi berdasarkan standar WHO',
                  style: AppTextStyles.body2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Input berat badan
  Widget _buildWeightInput() {
    return _buildInputCard(
      icon: Icons.monitor_weight_outlined,
      iconColor: AppColors.primary,
      title: 'Berat Badan',
      child: TextFormField(
        controller: _weightController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        style: AppTextStyles.h3,
        decoration: InputDecoration(
          hintText: 'Contoh: 10.5',
          hintStyle: AppTextStyles.body2.copyWith(color: AppColors.textHint),
          suffixText: 'kg',
          suffixStyle: AppTextStyles.h4.copyWith(color: AppColors.primary),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Berat badan harus diisi';
          }
          final weight = double.tryParse(value);
          if (weight == null || weight <= 0 || weight > 50) {
            return 'Berat badan tidak valid (1-50 kg)';
          }
          return null;
        },
      ),
    );
  }

  /// Input tinggi badan
  Widget _buildHeightInput() {
    return _buildInputCard(
      icon: Icons.height,
      iconColor: AppColors.secondary,
      title: 'Panjang/Tinggi Badan',
      subtitle: '< 2 tahun: ukur berbaring, ≥ 2 tahun: ukur berdiri',
      child: TextFormField(
        controller: _heightController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        style: AppTextStyles.h3,
        decoration: InputDecoration(
          hintText: 'Contoh: 85.5',
          hintStyle: AppTextStyles.body2.copyWith(color: AppColors.textHint),
          suffixText: 'cm',
          suffixStyle: AppTextStyles.h4.copyWith(color: AppColors.secondary),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Tinggi badan harus diisi';
          }
          final height = double.tryParse(value);
          if (height == null || height < 40 || height > 130) {
            return 'Tinggi badan tidak valid (40-130 cm)';
          }
          return null;
        },
      ),
    );
  }

  /// Input umur (tahun dan bulan)
  Widget _buildAgeInput() {
    return _buildInputCard(
      icon: Icons.cake_outlined,
      iconColor: AppColors.success,
      title: 'Umur Anak',
      subtitle: 'Maksimal 5 tahun (60 bulan)',
      child: Row(
        children: [
          // Tahun
          Expanded(
            child: TextFormField(
              controller: _ageYearsController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTextStyles.h3,
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.textHint,
                ),
                suffixText: 'tahun',
                suffixStyle: AppTextStyles.body1.copyWith(
                  color: AppColors.success,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          // Bulan
          Expanded(
            child: TextFormField(
              controller: _ageMonthsController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTextStyles.h3,
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: AppTextStyles.body2.copyWith(
                  color: AppColors.textHint,
                ),
                suffixText: 'bulan',
                suffixStyle: AppTextStyles.body1.copyWith(
                  color: AppColors.success,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Selector jenis kelamin
  Widget _buildGenderSelector() {
    return _buildInputCard(
      icon: Icons.wc,
      iconColor: AppColors.info,
      title: 'Jenis Kelamin',
      child: Row(
        children: [
          Expanded(child: _buildGenderOption('L', 'Laki-laki', Icons.male)),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(child: _buildGenderOption('P', 'Perempuan', Icons.female)),
        ],
      ),
    );
  }

  /// Option button gender
  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = _selectedGender == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacingM,
          horizontal: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.info.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          border: Border.all(
            color: isSelected ? AppColors.info : AppColors.glassBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.info : AppColors.textSecondary,
              size: AppDimensions.iconM,
            ),
            const SizedBox(width: AppDimensions.spacingS),
            Text(
              label,
              style: AppTextStyles.body1.copyWith(
                color: isSelected ? AppColors.info : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Template card untuk input
  Widget _buildInputCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.glassBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingXS),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Icon(icon, color: iconColor, size: AppDimensions.iconS),
              ),
              const SizedBox(width: AppDimensions.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.h4),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppDimensions.spacingXS),
                      Text(subtitle, style: AppTextStyles.caption),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),
          child,
        ],
      ),
    );
  }

  /// Tombol hitung
  Widget _buildCalculateButton() {
    return ElevatedButton(
      onPressed: _calculateNutrition,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calculate, size: AppDimensions.iconM),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            'Hitung Status Gizi',
            style: AppTextStyles.h3.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

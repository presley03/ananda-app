import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/constants/app_info.dart';
import '../../services/database_service.dart';
import '../../models/child_profile.dart';
import '../../widgets/simple_card.dart';

/// Add Profile Screen
/// Form untuk menambah profil anak baru
///
/// Features:
/// - Input: Nama, Tanggal Lahir, Jenis Kelamin
/// - Validasi form
/// - Date picker untuk tanggal lahir
/// - Gender selection (Laki-laki/Perempuan)
/// - Save to database
class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({super.key});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();

  DateTime? _selectedDate;
  String _selectedGender = 'L'; // Default: Laki-laki
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Show date picker
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Validate and save profile
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih tanggal lahir anak')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final profile = ChildProfile(
        name: _nameController.text.trim(),
        birthDate: _selectedDate!,
        gender: _selectedGender,
      );

      await _dbService.insertChild(profile.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil ditambahkan! âœ…'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Form
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
                        _buildNameField(),
                        const SizedBox(height: AppDimensions.spacingM),
                        _buildDateField(),
                        const SizedBox(height: AppDimensions.spacingM),
                        _buildGenderField(),
                        const SizedBox(height: AppDimensions.spacingXL),
                        _buildSaveButton(),
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

  /// Build header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            'Tambah Profil Anak',
            style: AppTextStyles.h2.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  /// Build info card
  Widget _buildInfoCard() {
    return SimpleCard(
      tintColor: AppColors.info.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.info,
            size: AppDimensions.iconL,
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Text(
              'Data ini akan digunakan untuk menghitung usia anak dan rekomendasi skrining',
              style: AppTextStyles.body2,
            ),
          ),
        ],
      ),
    );
  }

  /// Build name field
  Widget _buildNameField() {
    return SimpleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nama Anak', style: AppTextStyles.label),
          const SizedBox(height: AppDimensions.spacingS),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Masukkan nama anak',
              hintStyle: AppTextStyles.body2.copyWith(
                color: AppColors.textHint,
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(AppDimensions.spacingM),
            ),
            style: AppTextStyles.body1,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama tidak boleh kosong';
              }
              if (value.trim().length < 2) {
                return 'Nama minimal 2 karakter';
              }
              if (value.trim().length > 50) {
                return 'Nama maksimal 50 karakter';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  /// Build date field
  Widget _buildDateField() {
    return SimpleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tanggal Lahir', style: AppTextStyles.label),
          const SizedBox(height: AppDimensions.spacingS),
          InkWell(
            onTap: _selectDate,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppColors.primary,
                    size: AppDimensions.iconM,
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Text(
                    _selectedDate == null
                        ? 'Pilih tanggal lahir'
                        : _formatDate(_selectedDate!),
                    style: AppTextStyles.body1.copyWith(
                      color:
                          _selectedDate == null
                              ? AppColors.textHint
                              : AppColors.textPrimary,
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

  /// Build gender field
  Widget _buildGenderField() {
    return SimpleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Jenis Kelamin', style: AppTextStyles.label),
          const SizedBox(height: AppDimensions.spacingS),
          Row(
            children: [
              Expanded(
                child: _buildGenderOption(
                  'L',
                  'Laki-laki',
                  Icons.boy,
                  AppColors.info,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: _buildGenderOption(
                  'P',
                  'Perempuan',
                  Icons.girl,
                  Colors.pink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build gender option button
  Widget _buildGenderOption(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedGender == value;

    return InkWell(
      onTap: () => setState(() => _selectedGender = value),
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? color.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.textHint,
              size: AppDimensions.iconXL,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build save button
  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _isSaving ? null : _saveProfile,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        elevation: 0,
      ),
      child:
          _isSaving
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
              : Text('Simpan Profil', style: AppTextStyles.button),
    );
  }
}

import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/constants/app_info.dart';
import '../../services/database_service.dart';
import '../../models/child_profile.dart';
import '../../widgets/glass_card.dart';

/// Edit Profile Screen
/// Form untuk mengedit profil anak yang sudah ada
///
/// Features:
/// - Pre-filled form dengan data existing
/// - Input: Nama, Tanggal Lahir, Jenis Kelamin
/// - Validasi form
/// - Update to database
class EditProfileScreen extends StatefulWidget {
  final ChildProfile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();

  late DateTime _selectedDate;
  late String _selectedGender;
  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill form with existing data
    _nameController.text = widget.profile.name;
    _selectedDate = widget.profile.birthDate;
    _selectedGender = widget.profile.gender;

    // Listen for changes
    _nameController.addListener(_checkChanges);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Check if form has changes
  void _checkChanges() {
    final hasChanges =
        _nameController.text.trim() != widget.profile.name ||
        _selectedDate != widget.profile.birthDate ||
        _selectedGender != widget.profile.gender;

    if (hasChanges != _hasChanges) {
      setState(() => _hasChanges = hasChanges);
    }
  }

  /// Show date picker
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
        _checkChanges();
      });
    }
  }

  /// Validate and update profile
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_hasChanges) {
      Navigator.pop(context);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updatedProfile = widget.profile.copyWith(
        name: _nameController.text.trim(),
        birthDate: _selectedDate,
        gender: _selectedGender,
        updatedAt: DateTime.now(),
      );

      await _dbService.updateChild(widget.profile.id!, updatedProfile.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui! âœ…'),
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
          Expanded(
            child: Text(
              'Edit Profil',
              style: AppTextStyles.h2.copyWith(color: AppColors.primary),
            ),
          ),
          if (_hasChanges)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingM,
                vertical: AppDimensions.spacingS,
              ),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
              ),
              child: Text(
                'Ada perubahan',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build info card
  Widget _buildInfoCard() {
    return GlassCard(
      tintColor: AppColors.warning.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(
            Icons.edit_outlined,
            color: AppColors.warning,
            size: AppDimensions.iconL,
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Text(
              'Perubahan tanggal lahir akan mempengaruhi perhitungan usia dan rekomendasi skrining',
              style: AppTextStyles.body2,
            ),
          ),
        ],
      ),
    );
  }

  /// Build name field
  Widget _buildNameField() {
    return GlassCard(
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
    return GlassCard(
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
                  Text(_formatDate(_selectedDate), style: AppTextStyles.body1),
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
    return GlassCard(
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
      onTap: () {
        setState(() {
          _selectedGender = value;
          _checkChanges();
        });
      },
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
      onPressed: (_isSaving || !_hasChanges) ? null : _updateProfile,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.disabled,
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
              : Text(
                _hasChanges ? 'Simpan Perubahan' : 'Tidak Ada Perubahan',
                style: AppTextStyles.button,
              ),
    );
  }
}

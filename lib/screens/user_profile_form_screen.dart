import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/user_profile.dart';
import '../services/database_service.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';
import '../widgets/glass_card.dart';

/// User Profile Form Screen
/// Screen untuk input/edit profil user (opsional)
///
/// Features:
/// - Input nama & role (wajib)
/// - Upload foto (opsional)
/// - Input lokasi (opsional)
/// - Simpan ke database lokal
class UserProfileFormScreen extends StatefulWidget {
  final UserProfile? existingProfile; // Null = create, not null = edit
  final bool isFirstTime; // True = welcome dialog, false = edit from settings

  const UserProfileFormScreen({
    super.key,
    this.existingProfile,
    this.isFirstTime = false,
  });

  @override
  State<UserProfileFormScreen> createState() => _UserProfileFormScreenState();
}

class _UserProfileFormScreenState extends State<UserProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final DatabaseService _db = DatabaseService();

  String _selectedRole = 'Ibu';
  String? _photoPath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingProfile != null) {
      _nameController.text = widget.existingProfile!.name;
      _selectedRole = widget.existingProfile!.role;
      _locationController.text = widget.existingProfile!.location ?? '';
      _photoPath = widget.existingProfile!.photoPath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  /// Pick photo from gallery
  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _photoPath = pickedFile.path;
      });
    }
  }

  /// Save profile
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final profile = UserProfile(
        name: _nameController.text.trim(),
        role: _selectedRole,
        photoPath: _photoPath,
        location:
            _locationController.text.trim().isEmpty
                ? null
                : _locationController.text.trim(),
      );

      await _db.saveUserProfile(profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil disimpan! âœ…'),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate back with success
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan profil: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Skip profile setup (first time only)
  void _skipSetup() {
    Navigator.pop(context, false);
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
              // Header
              _buildHeader(),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: AppDimensions.spacingL),

                        // Photo picker
                        _buildPhotoPicker(),

                        const SizedBox(height: AppDimensions.spacingXL),

                        // Name field
                        _buildNameField(),

                        const SizedBox(height: AppDimensions.spacingL),

                        // Role selector
                        _buildRoleSelector(),

                        const SizedBox(height: AppDimensions.spacingL),

                        // Location field (optional)
                        _buildLocationField(),

                        const SizedBox(height: AppDimensions.spacingXL),

                        // Save button
                        _buildSaveButton(),

                        // Skip button (first time only)
                        if (widget.isFirstTime) ...[
                          const SizedBox(height: AppDimensions.spacingM),
                          _buildSkipButton(),
                        ],
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
          if (!widget.isFirstTime)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.spacingS),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
            ),

          if (!widget.isFirstTime)
            const SizedBox(width: AppDimensions.spacingM),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isFirstTime ? 'Selamat Datang! ðŸ‘‹' : 'Edit Profil',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (widget.isFirstTime)
                  const Text(
                    'Boleh tahu nama Anda?',
                    style: TextStyle(
                      fontSize: 14,
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

  /// Build photo picker
  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickPhoto,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: 0.1),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 3,
          ),
        ),
        child:
            _photoPath != null
                ? ClipOval(
                  child: Image.file(File(_photoPath!), fit: BoxFit.cover),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      size: 40,
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap untuk\nupload foto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  /// Build name field
  Widget _buildNameField() {
    return GlassCard(
      child: TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Nama',
          hintText: 'Contoh: Siti, Budi',
          prefixIcon: Icon(Icons.person_rounded, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(AppDimensions.spacingM),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Nama wajib diisi';
          }
          return null;
        },
      ),
    );
  }

  /// Build role selector
  Widget _buildRoleSelector() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Anda adalah:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  UserProfile.availableRoles.map((role) {
                    final isSelected = _selectedRole == role;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRole = role;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? AppColors.primary
                                  : Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppColors.primary
                                    : AppColors.primary.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          role,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Build location field
  Widget _buildLocationField() {
    return GlassCard(
      child: TextFormField(
        controller: _locationController,
        decoration: const InputDecoration(
          labelText: 'Lokasi (Opsional)',
          hintText: 'Contoh: Palangkaraya',
          prefixIcon: Icon(Icons.location_on_rounded, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(AppDimensions.spacingM),
        ),
      ),
    );
  }

  /// Build save button
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child:
            _isLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : const Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }

  /// Build skip button
  Widget _buildSkipButton() {
    return TextButton(
      onPressed: _skipSetup,
      child: const Text(
        'Lewati (Nanti saja)',
        style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
      ),
    );
  }
}

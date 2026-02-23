import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../models/user_profile.dart';
import '../services/database_service.dart';
import '../utils/constants/colors.dart';

class UserProfileFormScreen extends StatefulWidget {
  final UserProfile? existingProfile;
  final bool isFirstTime;

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

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked != null) setState(() => _photoPath = picked.path);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
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
            content: Text('Profil berhasil disimpan!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Column(
        children: [
          // Header gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primary, AppColors.secondary],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 32),
                child: Row(
                  children: [
                    if (!widget.isFirstTime)
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isFirstTime
                              ? 'Selamat Datang!'
                              : 'Edit Profil',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.isFirstTime
                              ? 'Boleh tahu nama Anda?'
                              : 'Ubah data profil Anda',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Photo picker
                    GestureDetector(
                      onTap: _pickPhoto,
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.1),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child:
                                _photoPath != null
                                    ? ClipOval(
                                      child: Image.file(
                                        File(_photoPath!),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : const Icon(
                                      Icons.person_rounded,
                                      size: 48,
                                      color: AppColors.primary,
                                    ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),
                    const Text(
                      'Tap untuk ganti foto',
                      style: TextStyle(fontSize: 12, color: AppColors.textHint),
                    ),

                    const SizedBox(height: 24),

                    // Nama
                    _label('Nama Lengkap'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(
                        'Masukkan nama Anda',
                        Icons.person_rounded,
                      ),
                      validator:
                          (v) =>
                              (v == null || v.trim().isEmpty)
                                  ? 'Nama wajib diisi'
                                  : null,
                    ),

                    const SizedBox(height: 20),

                    // Role
                    _label('Anda adalah:'),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            UserProfile.availableRoles.map((role) {
                              final sel = _selectedRole == role;
                              return GestureDetector(
                                onTap:
                                    () => setState(() => _selectedRole = role),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        sel
                                            ? AppColors.primary
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          sel
                                              ? AppColors.primary
                                              : AppColors.primary.withValues(
                                                alpha: 0.3,
                                              ),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    role,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          sel
                                              ? Colors.white
                                              : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Lokasi
                    _label('Lokasi (Opsional)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _locationController,
                      decoration: _inputDecoration(
                        'Contoh: Palangkaraya',
                        Icons.location_on_rounded,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Tombol simpan
                    GestureDetector(
                      onTap: _isLoading ? null : _saveProfile,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    'Simpan',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                        ),
                      ),
                    ),

                    if (widget.isFirstTime) ...[
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(
                          'Lewati (Nanti saja)',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    ),
  );

  InputDecoration _inputDecoration(String hint, IconData icon) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      );
}

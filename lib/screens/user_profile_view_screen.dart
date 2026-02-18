import 'package:flutter/material.dart';
import 'dart:io';
import '../models/user_profile.dart';
import '../services/database_service.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';
import '../widgets/simple_card.dart';
import 'user_profile_form_screen.dart';

/// User Profile View Screen
/// Screen untuk melihat detail profil user
///
/// Features:
/// - Tampilkan foto, nama, role, lokasi
/// - Button edit profil
/// - Button hapus profil
class UserProfileViewScreen extends StatelessWidget {
  final UserProfile profile;

  const UserProfileViewScreen({super.key, required this.profile});

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
              _buildHeader(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingL),
                  child: Column(
                    children: [
                      const SizedBox(height: AppDimensions.spacingL),

                      // Photo
                      _buildPhoto(),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Profile info
                      _buildProfileInfo(),

                      const SizedBox(height: AppDimensions.spacingXL),

                      // Edit button
                      _buildEditButton(context),

                      const SizedBox(height: AppDimensions.spacingM),

                      // Delete button
                      _buildDeleteButton(context),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
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
          const SizedBox(width: AppDimensions.spacingM),
          const Text(
            'Profil Saya',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoto() {
    return Container(
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
          profile.photoPath != null
              ? ClipOval(
                child: Image.file(File(profile.photoPath!), fit: BoxFit.cover),
              )
              : Icon(
                Icons.person_rounded,
                size: 60,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
    );
  }

  Widget _buildProfileInfo() {
    return SimpleCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          children: [
            // Name
            _buildInfoRow(
              icon: Icons.person_rounded,
              label: 'Nama',
              value: profile.name,
            ),

            const SizedBox(height: AppDimensions.spacingL),

            // Role
            _buildInfoRow(
              icon: Icons.family_restroom_rounded,
              label: 'Hubungan',
              value: profile.roleDisplay,
            ),

            if (profile.location != null) ...[
              const SizedBox(height: AppDimensions.spacingL),

              // Location
              _buildInfoRow(
                icon: Icons.location_on_rounded,
                label: 'Lokasi',
                value: profile.location!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingS),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder:
                  (context) => UserProfileFormScreen(
                    existingProfile: profile,
                    isFirstTime: false,
                  ),
            ),
          );

          if (result == true && context.mounted) {
            Navigator.pop(context, true); // Return true to reload
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.edit_rounded, color: Colors.white),
        label: const Text(
          'Edit Profil',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Hapus Profil?'),
                  content: const Text(
                    'Data profil Anda akan dihapus. Anda masih bisa membuat profil baru nanti.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.danger,
                      ),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
          );

          if (confirm == true && context.mounted) {
            final db = DatabaseService();
            await db.deleteUserProfile();

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil berhasil dihapus'),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pop(context, true); // Return true to reload
            }
          }
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: AppColors.danger),
        ),
        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
        label: const Text(
          'Hapus Profil',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.danger,
          ),
        ),
      ),
    );
  }
}

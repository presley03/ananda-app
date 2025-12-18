import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';
import 'user_profile_form_screen.dart';

/// Welcome Dialog
/// Dialog yang muncul saat first launch untuk setup profil (opsional)
/// 
/// Usage:
/// ```dart
/// final result = await showWelcomeDialog(context);
/// if (result == true) {
///   // User completed profile
/// } else {
///   // User skipped
/// }
/// ```
Future<bool?> showWelcomeDialog(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false, // User must choose
    builder: (context) => const WelcomeDialog(),
  );
}

class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.waving_hand_rounded,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingL),
            
            // Title
            const Text(
              'Selamat Datang di Ananda!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppDimensions.spacingM),
            
            // Description
            const Text(
              'Ananda membantu Anda memantau tumbuh kembang si kecil dengan mudah.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppDimensions.spacingS),
            
            const Text(
              'Untuk pengalaman lebih personal, boleh kami tahu nama Anda?',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppDimensions.spacingXL),
            
            // Setup button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Close dialog
                  Navigator.pop(context);
                  
                  // Navigate to profile form
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfileFormScreen(
                        isFirstTime: true,
                      ),
                    ),
                  );
                  
                  // Return result to caller
                  if (context.mounted && result != null) {
                    // Refresh home screen if needed
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Isi Profil',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingM),
            
            // Skip button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: AppColors.textSecondary.withOpacity(0.3),
                  ),
                ),
                child: const Text(
                  'Nanti Saja',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: AppDimensions.spacingS),
            
            // Info text
            Text(
              'Anda bisa mengisi profil nanti di pengaturan',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

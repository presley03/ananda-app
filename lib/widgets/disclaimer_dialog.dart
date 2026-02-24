import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/dimensions.dart';
import '../utils/constants/legal_texts.dart';
import '../utils/constants/app_info.dart';

/// Disclaimer Dialog
/// Muncul sekali saat first launch
/// User harus centang "Saya Mengerti" dan klik "Lanjutkan"
class DisclaimerDialog extends StatefulWidget {
  final VoidCallback onAccepted;

  const DisclaimerDialog({super.key, required this.onAccepted});

  @override
  State<DisclaimerDialog> createState() => _DisclaimerDialogState();

  /// Show disclaimer dialog
  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // User must accept
      builder:
          (context) => DisclaimerDialog(
            onAccepted: () {
              Navigator.of(context).pop();
            },
          ),
    );
  }
}

class _DisclaimerDialogState extends State<DisclaimerDialog> {
  bool _isChecked = false;
  bool _isLoading = false;

  /// Handle accept button
  Future<void> _handleAccept() async {
    if (!_isChecked) {
      // Show warning if not checked
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan centang "Saya Mengerti" untuk melanjutkan'),
          backgroundColor: AppColors.warning,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Save acceptance to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppInfo.keyDisclaimerAccepted, true);
      await prefs.setBool(AppInfo.keyFirstLaunch, false);

      if (!mounted) return;

      // Close dialog
      widget.onAccepted();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusL),
                  topRight: Radius.circular(AppDimensions.radiusL),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warning,
                    size: AppDimensions.iconL,
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: Text(
                      LegalTexts.disclaimerTitle,
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main points
                    _buildPoint(
                      '📱 Aplikasi Edukasi',
                      'Ananda adalah aplikasi edukasi dan alat bantu skrining perkembangan anak.',
                    ),
                    const SizedBox(height: AppDimensions.spacingM),

                    _buildPoint(
                      '⚕️ Bukan Pengganti Dokter',
                      'Aplikasi ini TIDAK menggantikan konsultasi medis profesional atau pemeriksaan langsung oleh tenaga kesehatan.',
                    ),
                    const SizedBox(height: AppDimensions.spacingM),

                    _buildPoint(
                      '✅ Hasil Bersifat Indikatif',
                      'Hasil skrining bersifat indikatif dan memerlukan konfirmasi lebih lanjut oleh tenaga kesehatan.',
                    ),
                    const SizedBox(height: AppDimensions.spacingM),

                    _buildPoint(
                      '👨‍⚕️ Konsultasi Diperlukan',
                      'Jika hasil menunjukkan kemungkinan keterlambatan, segera konsultasikan dengan dokter spesialis anak atau tenaga kesehatan.',
                    ),

                    const SizedBox(height: AppDimensions.spacingL),

                    // Read more link
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/disclaimer');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.spacingS,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Baca Selengkapnya',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacingXS),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Checkbox & Button
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.radiusL),
                  bottomRight: Radius.circular(AppDimensions.radiusL),
                ),
              ),
              child: Column(
                children: [
                  // Checkbox
                  InkWell(
                    onTap: () => setState(() => _isChecked = !_isChecked),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spacingS,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _isChecked,
                              onChanged: (value) {
                                setState(() => _isChecked = value ?? false);
                              },
                              activeColor: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spacingM),
                          Expanded(
                            child: Text(
                              'Saya mengerti dan menerima disclaimer di atas',
                              style: AppTextStyles.body2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.spacingM),

                  // Accept Button
                  SizedBox(
                    width: double.infinity,
                    height: AppDimensions.buttonHeightM,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.disabled,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Text('Lanjutkan', style: AppTextStyles.button),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build point widget
  Widget _buildPoint(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXS),
        Text(description, style: AppTextStyles.body2),
      ],
    );
  }
}

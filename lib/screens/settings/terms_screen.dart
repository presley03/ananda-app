import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/legal_texts.dart';
import '_settings_content_screen.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});
  @override
  Widget build(BuildContext context) => SettingsContentScreen(
    title: 'Syarat & Ketentuan',
    subtitle: 'Ketentuan layanan aplikasi',
    icon: Icons.description_outlined,
    iconColor: AppColors.accentTeal,
    iconBg: const Color(0xFFEDFAFF),
    content: LegalTexts.termsContent,
  );
}

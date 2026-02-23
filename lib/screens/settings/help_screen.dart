import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/legal_texts.dart';
import '_settings_content_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) => SettingsContentScreen(
    title: 'Bantuan',
    subtitle: 'Panduan penggunaan aplikasi',
    icon: Icons.help_outline_rounded,
    iconColor: AppColors.accentPurple,
    iconBg: const Color(0xFFF3EDFF),
    content: LegalTexts.helpContent,
  );
}

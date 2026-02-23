import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/legal_texts.dart';
import '_settings_content_screen.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) => SettingsContentScreen(
    title: 'Kebijakan Privasi',
    subtitle: 'Perlindungan data pengguna',
    icon: Icons.privacy_tip_outlined,
    iconColor: AppColors.success,
    iconBg: const Color(0xFFEDFFF5),
    content: LegalTexts.privacyContent,
  );
}

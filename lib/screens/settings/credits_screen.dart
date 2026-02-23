import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/app_info.dart';
import '../../utils/constants/legal_texts.dart';
import '_settings_content_screen.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});
  @override
  Widget build(BuildContext context) => SettingsContentScreen(
    title: 'Pembuat',
    subtitle: AppInfo.developerName,
    icon: Icons.groups_outlined,
    iconColor: AppColors.accentPurple,
    iconBg: const Color(0xFFF3EDFF),
    content: LegalTexts.creditsContent,
  );
}

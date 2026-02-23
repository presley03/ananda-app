import 'package:flutter/material.dart';
import '../../utils/constants/legal_texts.dart';
import '_settings_content_screen.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});
  @override
  Widget build(BuildContext context) => SettingsContentScreen(
    title: 'Disclaimer',
    subtitle: 'Ketentuan penggunaan aplikasi',
    icon: Icons.warning_amber_rounded,
    iconColor: const Color(0xFFD4AC0D),
    iconBg: const Color(0xFFFFFBED),
    content: LegalTexts.disclaimerContent,
  );
}

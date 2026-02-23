import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/legal_texts.dart';
import '_settings_content_screen.dart';

class ReferencesScreen extends StatelessWidget {
  const ReferencesScreen({super.key});
  @override
  Widget build(BuildContext context) => SettingsContentScreen(
    title: 'Sumber Referensi',
    subtitle: 'IDAI, WHO, Permenkes',
    icon: Icons.library_books_outlined,
    iconColor: AppColors.accentTeal,
    iconBg: const Color(0xFFEDFAFF),
    content: LegalTexts.referencesContent,
  );
}

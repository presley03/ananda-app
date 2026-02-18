import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants/colors.dart';

/// Widget untuk menampilkan konten materi dengan Google Fonts
/// TETAP 100% OFFLINE - Font di-embed ke APK saat build!
class FormattedMaterialContent extends StatelessWidget {
  final String content;
  final TextStyle? baseStyle;

  const FormattedMaterialContent({
    super.key,
    required this.content,
    this.baseStyle,
  });

  /// Cek apakah sebuah line adalah header
  bool _isHeader(String line) {
    final trimmed = line.trim();

    // Bukan header jika dimulai dengan bullet
    if (trimmed.startsWith('•') || trimmed.startsWith('â€¢')) return false;

    // Bukan header jika terlalu panjang (lebih dari 80 karakter)
    // Header biasanya pendek, kalimat panjang = paragraf biasa
    if (trimmed.length > 80) return false;

    // Header jika diakhiri dengan: : ? atau **
    if (trimmed.endsWith(':')) return true;
    if (trimmed.endsWith('?')) return true;
    if (trimmed.endsWith('**')) return true;

    return false;
  }

  /// Fix encoding issues pada text
  String _fixEncoding(String text) {
    return text
        .replaceAll('â€¢', '•') // Fix bullet encoding
        .replaceAll('â€"', '–') // Fix en dash
        .replaceAll('â€"', '—') // Fix em dash
        .replaceAll('â€˜', ''')       // Fix left single quote
        .replaceAll('â€™', ''') // Fix right single quote
        .replaceAll('â€œ', '"') // Fix left double quote
        .replaceAll('â€', '"') // Fix right double quote
        .replaceAll('Â°', '°') // Fix degree symbol
        .replaceAll('Â½', '½'); // Fix half symbol
  }

  @override
  Widget build(BuildContext context) {
    // Fix encoding dulu sebelum diproses
    final fixedContent = _fixEncoding(content);

    // Split content by line breaks
    final lines = fixedContent.split('\n');

    // Build widgets
    List<Widget> widgets = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Skip empty lines but add spacing
      if (line.trim().isEmpty) {
        if (i > 0 && i < lines.length - 1) {
          widgets.add(const SizedBox(height: 12));
        }
        continue;
      }

      // Check if line is a header
      final isHeader = _isHeader(line);

      // Check if line is a bullet point
      final isBullet = line.trim().startsWith('•');

      if (isHeader) {
        // Remove ** from start and end if present
        String headerText = line.trim();

        if (headerText.startsWith('**')) {
          headerText = headerText.substring(2);
        }
        if (headerText.endsWith('**')) {
          headerText = headerText.substring(0, headerText.length - 2);
        }

        // Add header with Nunito Sans Bold + Teal color
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 16),
            child: SelectableText(
              headerText,
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                height: 1.5,
                color: AppColors.primary,
                letterSpacing: -0.2,
              ),
            ),
          ),
        );
      } else if (isBullet) {
        // Format bullet point dengan hanging indent
        final bulletText = line.trim().substring(1).trim();

        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bullet symbol - fixed width
                SizedBox(
                  width: 20,
                  child: Text(
                    '•',
                    style: GoogleFonts.nunitoSans(
                      height: 1.7,
                      fontSize: 15,
                      color: AppColors.primary.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Text - Expanded untuk auto wrap & indent
                Expanded(
                  child: SelectableText(
                    bulletText,
                    style: GoogleFonts.nunitoSans(
                      height: 1.7,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        // Regular paragraph
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SelectableText(
              line.trim(),
              style: GoogleFonts.nunitoSans(
                height: 1.7,
                fontSize: 15,
                color: AppColors.textPrimary,
                letterSpacing: 0.1,
              ),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

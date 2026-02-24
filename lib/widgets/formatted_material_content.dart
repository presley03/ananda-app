import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants/colors.dart';

/// Widget untuk menampilkan konten materi dengan Google Fonts
/// Support: header, bullet, inline bold (**text**), tabel (|col|col|)
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
    if (trimmed.startsWith('•') || trimmed.startsWith('|')) return false;
    if (trimmed.length > 80) return false;

    // Bukan header jika dimulai dengan ** (itu inline bold di paragraf)
    if (trimmed.startsWith('**')) return false;

    if (trimmed.endsWith(':')) return true;
    if (trimmed.endsWith('?')) return true;
    if (trimmed.endsWith('**')) return true;
    return false;
  }

  /// Cek apakah line adalah baris tabel
  bool _isTableRow(String line) {
    final trimmed = line.trim();
    return trimmed.startsWith('|') && trimmed.endsWith('|');
  }

  /// Cek apakah line adalah separator tabel (|---|---|)
  bool _isTableSeparator(String line) {
    final trimmed = line.trim();
    return _isTableRow(trimmed) &&
        trimmed
            .replaceAll('|', '')
            .replaceAll('-', '')
            .replaceAll(':', '')
            .replaceAll(' ', '')
            .isEmpty;
  }

  /// Parse cells dari baris tabel
  List<String> _parseTableRow(String line) {
    final trimmed = line.trim();
    final inner = trimmed.substring(1, trimmed.length - 1);
    return inner.split('|').map((cell) => cell.trim()).toList();
  }

  /// Fix encoding issues pada text
  String _fixEncoding(String text) {
    return text
        .replaceAll('â€¢', '•')
        .replaceAll('â€"', '\u2013')
        .replaceAll('â€"', '\u2014')
        .replaceAll('â€˜', '\u2018')
        .replaceAll('â€™', '\u2019')
        .replaceAll('â€œ', '\u201C')
        .replaceAll('â€', '\u201D')
        .replaceAll('Â°', '°')
        .replaceAll('Â½', '½');
  }

  @override
  Widget build(BuildContext context) {
    final fixedContent = _fixEncoding(content);
    final lines = fixedContent.split('\n');

    List<Widget> widgets = [];
    int i = 0;

    while (i < lines.length) {
      final line = lines[i];

      // Empty line — spacing
      if (line.trim().isEmpty) {
        if (i > 0 && i < lines.length - 1) {
          widgets.add(const SizedBox(height: 12));
        }
        i++;
        continue;
      }

      // Tabel — kumpulkan semua baris tabel sekaligus
      if (_isTableRow(line) && !_isTableSeparator(line)) {
        List<String>? headerRow;
        final List<List<String>> dataRows = [];
        bool isFirst = true;

        while (i < lines.length && _isTableRow(lines[i])) {
          if (_isTableSeparator(lines[i])) {
            i++;
            continue;
          }
          final cells = _parseTableRow(lines[i]);
          if (isFirst) {
            headerRow = cells;
            isFirst = false;
          } else {
            dataRows.add(cells);
          }
          i++;
        }

        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: _buildTable(headerRow, dataRows),
          ),
        );
        continue;
      }

      // Header
      if (_isHeader(line)) {
        String headerText = line.trim();
        if (headerText.startsWith('**')) headerText = headerText.substring(2);
        if (headerText.endsWith('**'))
          headerText = headerText.substring(0, headerText.length - 2);

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
        i++;
        continue;
      }

      // Bullet point
      if (line.trim().startsWith('•')) {
        final bulletText = line.trim().substring(1).trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Expanded(
                  child: _buildRichText(
                    bulletText,
                    GoogleFonts.nunitoSans(
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
        i++;
        continue;
      }

      // Regular paragraph
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildRichText(
            line.trim(),
            GoogleFonts.nunitoSans(
              height: 1.7,
              fontSize: 15,
              color: AppColors.textPrimary,
              letterSpacing: 0.1,
            ),
          ),
        ),
      );
      i++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  /// Build tabel dengan header dan data rows
  Widget _buildTable(List<String>? headerRow, List<List<String>> rows) {
    final dataStyle = GoogleFonts.nunitoSans(
      fontSize: 13,
      color: AppColors.textPrimary,
      height: 1.5,
    );
    final headerStyle = GoogleFonts.nunitoSans(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      height: 1.5,
    );

    // Tentukan lebar minimum per kolom
    const double colMinWidth = 120.0;
    final int colCount =
        headerRow?.length ?? (rows.isNotEmpty ? rows[0].length : 1);
    final double tableMinWidth = colMinWidth * colCount;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: tableMinWidth),
          child: Table(
            border: TableBorder.all(
              color: AppColors.primary.withValues(alpha: 0.15),
              width: 1,
            ),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            defaultColumnWidth: const IntrinsicColumnWidth(),
            children: [
              // Header row
              if (headerRow != null)
                TableRow(
                  decoration: BoxDecoration(color: AppColors.primary),
                  children:
                      headerRow
                          .map(
                            (cell) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Text(
                                cell,
                                style: headerStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          )
                          .toList(),
                ),
              // Data rows dengan zebra striping
              ...rows.asMap().entries.map((entry) {
                final isEven = entry.key % 2 == 0;
                return TableRow(
                  decoration: BoxDecoration(
                    color:
                        isEven
                            ? Colors.white
                            : AppColors.primary.withValues(alpha: 0.05),
                  ),
                  children:
                      entry.value
                          .map(
                            (cell) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Text(
                                cell,
                                style: dataStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          )
                          .toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Build RichText dengan support:
  /// **text** = bold
  /// ==text== = highlight stabilo hijau
  Widget _buildRichText(String text, TextStyle baseTextStyle) {
    if (!text.contains('**') && !text.contains('==')) {
      return SelectableText(text, style: baseTextStyle);
    }

    final boldStyle = baseTextStyle.copyWith(fontWeight: FontWeight.w700);
    final highlightStyle = baseTextStyle.copyWith(
      fontWeight: FontWeight.w600,
      color: const Color(0xFF1A6B3C),
      background: Paint()..color = const Color(0xFFCCF5E0),
    );

    // Tokenize dengan regex yang menangkap semua segmen
    final RegExp pattern = RegExp(r'\*\*(.*?)\*\*|==(.*?)==');
    final List<TextSpan> spans = [];
    int lastEnd = 0;

    for (final match in pattern.allMatches(text)) {
      // Teks biasa sebelum marker
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastEnd, match.start),
            style: baseTextStyle,
          ),
        );
      }

      if (match.group(1) != null) {
        // Bold: **text**
        spans.add(TextSpan(text: match.group(1)!, style: boldStyle));
      } else if (match.group(2) != null) {
        // Highlight: ==text==
        spans.add(TextSpan(text: match.group(2)!, style: highlightStyle));
      }

      lastEnd = match.end;
    }

    // Sisa teks setelah marker terakhir
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd), style: baseTextStyle));
    }

    return SelectableText.rich(TextSpan(children: spans));
  }
}

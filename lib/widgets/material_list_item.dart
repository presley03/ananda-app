import 'package:flutter/material.dart';
import '../models/material.dart' as model;
import '../utils/constants/colors.dart';

class MaterialListItem extends StatelessWidget {
  final model.Material material;
  final VoidCallback onTap;
  final bool showBookmark;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;
  final int index;

  const MaterialListItem({
    super.key,
    required this.material,
    required this.onTap,
    required this.index,
    this.showBookmark = false,
    this.isBookmarked = false,
    this.onBookmarkTap,
  });

  static const List<List<Color>> _palette = [
    [Color(0xFFFFF0ED), Color(0xFFFF6B6B)], // coral
    [Color(0xFFEDF6FF), Color(0xFF5B9BD5)], // soft blue
    [Color(0xFFFFFBED), Color(0xFFD4AC0D)], // golden
    [Color(0xFFEDFFF5), Color(0xFF4CAF82)], // mint green
    [Color(0xFFFFF3ED), Color(0xFFFF8C42)], // orange
    [Color(0xFFF3EDFF), Color(0xFF9B72CF)], // soft purple
  ];

  List<Color> get _cardColors => _palette[index % _palette.length];

  @override
  Widget build(BuildContext context) {
    final bg = _cardColors[0];
    final accent = _cardColors[1];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          // Tidak ada border, tidak ada shadow — flat & clean
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge + subkategori
                  Row(
                    children: [
                      _buildBadge(accent),
                      const SizedBox(width: 8),
                      Text(
                        material.subcategoryDisplay,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),

                  // Judul
                  Text(
                    material.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Preview 2 baris
                  Text(
                    material.contentPreview,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),

                  // Waktu baca
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: accent.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${material.estimatedReadingTime} menit baca',
                        style: TextStyle(
                          fontSize: 11,
                          color: accent.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bookmark
            if (showBookmark)
              GestureDetector(
                onTap: onBookmarkTap,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Icon(
                    isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    size: 20,
                    color: isBookmarked ? accent : AppColors.textHint,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        material.categoryDisplay,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: accent,
        ),
      ),
    );
  }
}

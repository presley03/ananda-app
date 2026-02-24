library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/material.dart' as model;
import '../widgets/formatted_material_content.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/dimensions.dart';

class MaterialDetailScreen extends StatefulWidget {
  final model.Material material;
  final bool isBookmarked;
  final VoidCallback? onBookmarkToggle;

  const MaterialDetailScreen({
    super.key,
    required this.material,
    this.isBookmarked = false,
    this.onBookmarkToggle,
  });

  @override
  State<MaterialDetailScreen> createState() => _MaterialDetailScreenState();
}

class _MaterialDetailScreenState extends State<MaterialDetailScreen> {
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background putih — artikel menyatu dengan layar
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── HEADER ──────────────────────────────────
          SliverToBoxAdapter(child: _buildHeader()),

          // ── ARTIKEL CONTENT ─────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Meta info
                _buildMetaInfo(),
                const SizedBox(height: 20),

                // Gambar ilustrasi (jika ada)
                if (widget.material.image != null &&
                    widget.material.image!.isNotEmpty)
                  _buildImage(),

                const SizedBox(height: 28),

                // Konten artikel — terbuka, tidak dalam kotak
                _buildContent(),
                const SizedBox(height: 24),

                // Tags
                if (widget.material.tagList.isNotEmpty) _buildTags(),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildShareFAB(),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back + Bookmark row
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      _isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: Colors.white,
                    ),
                    onPressed: _toggleBookmark,
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Badges
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildBadge(widget.material.categoryDisplay),
                    _buildBadge(widget.material.subcategoryDisplay),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Judul artikel di dalam header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.material.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  // Meta info — waktu baca & tanggal, tanpa kotak
  Widget _buildMetaInfo() {
    return Row(
      children: [
        Icon(Icons.access_time_rounded, size: 15, color: AppColors.textHint),
        const SizedBox(width: 5),
        Text(
          '${widget.material.estimatedReadingTime} menit baca',
          style: AppTextStyles.caption,
        ),
        if (widget.material.createdAt != null) ...[
          const SizedBox(width: 16),
          Icon(
            Icons.calendar_today_rounded,
            size: 15,
            color: AppColors.textHint,
          ),
          const SizedBox(width: 5),
          Text(
            _formatDate(widget.material.createdAt!),
            style: AppTextStyles.caption,
          ),
        ],
      ],
    );
  }

  // Gambar ilustrasi materi
  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          widget.material.image!,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
        ),
      ),
    );
  }

  // Konten — langsung di layar, tidak dalam card
  Widget _buildContent() {
    return FormattedMaterialContent(
      content: widget.material.content,
      baseStyle: const TextStyle(
        fontSize: 15,
        height: 1.75,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey.shade200, thickness: 1),
        const SizedBox(height: 12),
        const Text('Tags:', style: AppTextStyles.label),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              widget.material.tagList.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: AppDimensions.spacingL),
      ],
    );
  }

  Widget _buildShareFAB() {
    return FloatingActionButton.extended(
      onPressed: _shareContent,
      backgroundColor: AppColors.primary,
      elevation: 4,
      icon: const Icon(Icons.share_rounded, color: Colors.white),
      label: const Text(
        'Bagikan',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _toggleBookmark() {
    setState(() => _isBookmarked = !_isBookmarked);
    widget.onBookmarkToggle?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked ? 'Ditambahkan ke bookmark' : 'Dihapus dari bookmark',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor:
            _isBookmarked ? AppColors.success : AppColors.textSecondary,
      ),
    );
  }

  void _shareContent() {
    Clipboard.setData(
      ClipboardData(
        text:
            '${widget.material.title}\n\n${widget.material.content}\n\n---\nSumber: Aplikasi Ananda',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Konten telah disalin ke clipboard!'),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

/// File: material_detail_screen.dart
/// Path: lib/screens/material_detail_screen.dart
/// Description: Screen untuk menampilkan detail lengkap materi edukatif
///
/// Features:
/// - Full content display
/// - Bookmark toggle
/// - Share functionality
/// - Reading time estimate
/// - Back navigation
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/material.dart' as model;
import '../widgets/simple_card.dart';
import '../widgets/formatted_material_content.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/text_styles.dart';
import '../utils/constants/dimensions.dart';

class MaterialDetailScreen extends StatefulWidget {
  /// Material data to display
  final model.Material material;

  /// Initial bookmark state
  final bool isBookmarked;

  /// Callback when bookmark toggled
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              _buildAppBar(),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category & Subcategory Badges
                      _buildBadges(),

                      const SizedBox(height: AppDimensions.spacingM),

                      // Title
                      _buildTitle(),

                      const SizedBox(height: AppDimensions.spacingM),

                      // Meta info (reading time, date)
                      _buildMetaInfo(),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Content
                      _buildContent(),

                      const SizedBox(height: AppDimensions.spacingXL),

                      // Tags (if available)
                      if (widget.material.tagList.isNotEmpty) _buildTags(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Share FAB
      floatingActionButton: _buildShareFAB(),
    );
  }

  /// Build custom app bar
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingS,
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),

          const Spacer(),

          // Bookmark button
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
              color:
                  _isBookmarked ? AppColors.secondary : AppColors.textPrimary,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
    );
  }

  /// Build category and subcategory badges
  Widget _buildBadges() {
    return Wrap(
      spacing: AppDimensions.spacingS,
      runSpacing: AppDimensions.spacingS,
      children: [
        // Category badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Text(
            widget.material.categoryDisplay,
            style: AppTextStyles.label.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Subcategory badge
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Text(
            widget.material.subcategoryDisplay,
            style: AppTextStyles.label.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// Build title
  Widget _buildTitle() {
    return Text(
      widget.material.title,
      style: AppTextStyles.h2.copyWith(fontSize: 26, height: 1.3),
    );
  }

  /// Build meta information
  Widget _buildMetaInfo() {
    return SimpleCard(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          // Reading time
          const Icon(
            Icons.access_time_rounded,
            size: AppDimensions.iconS,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppDimensions.spacingXS),
          Text(
            '${widget.material.estimatedReadingTime} menit baca',
            style: AppTextStyles.body2,
          ),

          const SizedBox(width: AppDimensions.spacingL),

          // Date (if available)
          if (widget.material.createdAt != null) ...[
            const Icon(
              Icons.calendar_today_rounded,
              size: AppDimensions.iconS,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppDimensions.spacingXS),
            Text(
              _formatDate(widget.material.createdAt!),
              style: AppTextStyles.body2,
            ),
          ],
        ],
      ),
    );
  }

  /// Build content
  Widget _buildContent() {
    return SimpleCard(
      tintColor: _getCategoryTintColor(),
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: FormattedMaterialContent(
        content: widget.material.content,
        baseStyle: AppTextStyles.body1.copyWith(height: 1.7, fontSize: 15),
      ),
    );
  }

  /// Build tags
  Widget _buildTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tags:', style: AppTextStyles.label),
        const SizedBox(height: AppDimensions.spacingS),
        Wrap(
          spacing: AppDimensions.spacingS,
          runSpacing: AppDimensions.spacingS,
          children:
              widget.material.tagList.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                    vertical: AppDimensions.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(color: AppColors.glassBorder, width: 1),
                  ),
                  child: Text(
                    tag,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: AppDimensions.spacingL),
      ],
    );
  }

  /// Build share FAB
  Widget _buildShareFAB() {
    return FloatingActionButton.extended(
      onPressed: _shareContent,
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.share, color: Colors.white),
      label: const Text(
        'Bagikan',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Toggle bookmark
  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    // Callback to parent
    widget.onBookmarkToggle?.call();

    // Show feedback
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

  /// Share content
  void _shareContent() {
    // Copy to clipboard
    Clipboard.setData(
      ClipboardData(
        text: '''
${widget.material.title}

${widget.material.content}

---
Sumber: Aplikasi Ananda
Kategori: ${widget.material.categoryDisplay}
${widget.material.subcategoryDisplay}
''',
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Konten telah disalin ke clipboard!'),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.success,
      ),
    );

    // TODO: Implement native share dialog
    // Share.share(content) - requires share_plus package
  }

  /// Format date to readable string
  String _formatDate(DateTime date) {
    final months = [
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

  /// Get category tint color
  Color _getCategoryTintColor() {
    switch (widget.material.category) {
      case '0-1':
        return AppColors.category01Tint;
      case '1-2':
        return AppColors.category12Tint;
      case '2-5':
        return AppColors.category25Tint;
      default:
        return AppColors.glassWhite;
    }
  }
}

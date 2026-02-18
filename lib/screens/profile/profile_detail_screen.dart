import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';
import '../../services/database_service.dart';
import '../../models/child_profile.dart';
import '../../models/screening_result.dart';
import '../../widgets/simple_card.dart';
import 'edit_profile_screen.dart';

/// Profile Detail Screen
/// Menampilkan detail profil anak dan riwayat skrining
///
/// Features:
/// - Info profil lengkap (nama, umur, gender, tanggal lahir)
/// - Riwayat skrining semua jenis (KPSP, Gizi, TDD, M-CHAT)
/// - Edit profile button
/// - Delete profile button
/// - Kategori usia otomatis
class ProfileDetailScreen extends StatefulWidget {
  final ChildProfile profile;

  const ProfileDetailScreen({super.key, required this.profile});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<ScreeningResult> _screeningHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScreeningHistory();
  }

  /// Load screening history from database
  Future<void> _loadScreeningHistory() async {
    setState(() => _isLoading = true);

    try {
      final results = await _dbService.getScreeningResultsByChild(
        widget.profile.id!,
      );
      setState(() {
        _screeningHistory =
            results.map((map) => ScreeningResult.fromMap(map)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  /// Show delete confirmation dialog
  Future<void> _showDeleteDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Profil?'),
            content: Text(
              'Semua data dan riwayat skrining ${widget.profile.name} akan dihapus permanen.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );

    if (confirmed == true && mounted) {
      _deleteProfile();
    }
  }

  /// Delete profile from database
  Future<void> _deleteProfile() async {
    try {
      await _dbService.deleteChild(widget.profile.id!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil dihapus'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true); // Return true to refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  /// Navigate to edit screen
  Future<void> _navigateToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: widget.profile),
      ),
    );

    // Reload if profile was updated
    if (result == true && mounted) {
      // Refresh data and return to reload previous screen
      Navigator.pop(context, true);
    }
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
              // Header
              _buildHeader(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildProfileCard(),
                      const SizedBox(height: AppDimensions.spacingL),
                      _buildActionButtons(),
                      const SizedBox(height: AppDimensions.spacingL),
                      _buildScreeningHistorySection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Text(
              widget.profile.name,
              style: AppTextStyles.h2.copyWith(color: AppColors.primary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Build profile info card
  Widget _buildProfileCard() {
    return SimpleCard(
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color:
                  widget.profile.gender == 'L'
                      ? AppColors.info.withValues(alpha: 0.2)
                      : Colors.pink.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
            ),
            child: Icon(
              widget.profile.gender == 'L' ? Icons.boy : Icons.girl,
              size: 60,
              color:
                  widget.profile.gender == 'L' ? AppColors.info : Colors.pink,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Name
          Text(
            widget.profile.name,
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingS),

          // Divider
          Divider(color: Colors.grey.withValues(alpha: 0.3)),
          const SizedBox(height: AppDimensions.spacingM),

          // Info rows
          _buildInfoRow(
            Icons.cake_outlined,
            'Usia',
            widget.profile.ageDescription,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildInfoRow(
            widget.profile.gender == 'L' ? Icons.male : Icons.female,
            'Jenis Kelamin',
            widget.profile.genderDisplay,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildInfoRow(
            Icons.calendar_today_outlined,
            'Tanggal Lahir',
            _formatDate(widget.profile.birthDate),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          _buildInfoRow(
            Icons.category_outlined,
            'Kategori Materi',
            '${widget.profile.materialCategory} Tahun',
          ),
        ],
      ),
    );
  }

  /// Build info row
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: AppDimensions.iconM, color: AppColors.primary),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXS),
              Text(
                value,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _navigateToEdit,
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profil'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spacingM),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _showDeleteDialog,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Hapus'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build screening history section
  Widget _buildScreeningHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history,
              color: AppColors.primary,
              size: AppDimensions.iconM,
            ),
            const SizedBox(width: AppDimensions.spacingS),
            Text(
              'Riwayat Skrining',
              style: AppTextStyles.h3.copyWith(color: AppColors.primary),
            ),
            const Spacer(),
            if (_screeningHistory.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusRound,
                  ),
                ),
                child: Text(
                  '${_screeningHistory.length} hasil',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _isLoading
            ? _buildLoadingState()
            : _screeningHistory.isEmpty
            ? _buildEmptyHistoryState()
            : _buildHistoryList(),
      ],
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacingXL),
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  /// Build empty history state
  Widget _buildEmptyHistoryState() {
    return SimpleCard(
      child: Column(
        children: [
          Icon(Icons.assignment_outlined, size: 60, color: AppColors.textHint),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'Belum Ada Riwayat Skrining',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Lakukan skrining pertama dari menu Tools Skrining',
            style: AppTextStyles.body2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build history list
  Widget _buildHistoryList() {
    return Column(
      children:
          _screeningHistory.map((result) {
            return _buildHistoryCard(result);
          }).toList(),
    );
  }

  /// Build individual history card
  Widget _buildHistoryCard(ScreeningResult result) {
    Color statusColor;
    switch (result.resultColorStatus) {
      case 'success':
        statusColor = AppColors.success;
        break;
      case 'warning':
        statusColor = AppColors.warning;
        break;
      case 'danger':
        statusColor = AppColors.danger;
        break;
      default:
        statusColor = AppColors.info;
    }

    return SimpleCard(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: Row(
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Center(
              child: Text(
                result.resultEmoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.screeningTypeDisplay,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                Text(
                  result.result,
                  style: AppTextStyles.body2.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: AppDimensions.iconXS,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: AppDimensions.spacingXS),
                    Text(result.formattedDate, style: AppTextStyles.caption),
                    const SizedBox(width: AppDimensions.spacingM),
                    Icon(
                      Icons.cake,
                      size: AppDimensions.iconXS,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: AppDimensions.spacingXS),
                    Text(result.ageDescription, style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),

          // Score (if available)
          if (result.score != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingM,
                vertical: AppDimensions.spacingS,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Text(
                '${result.score}',
                style: AppTextStyles.h4.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Format date
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
}

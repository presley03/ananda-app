import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/dimensions.dart';
import '../../utils/constants/text_styles.dart';
import '../../services/database_service.dart';
import '../../models/child_profile.dart';
import '../../widgets/glass_card.dart';
import 'add_profile_screen.dart';
import 'profile_detail_screen.dart';

/// Profile List Screen
/// Menampilkan list profil anak yang sudah ditambahkan
///
/// Features:
/// - List semua profil anak dari database
/// - Empty state jika belum ada profil
/// - FAB untuk tambah profil baru
/// - Card dengan foto, nama, umur, gender
/// - Tap card untuk ke detail profil
class ProfileListScreen extends StatefulWidget {
  const ProfileListScreen({super.key});

  @override
  State<ProfileListScreen> createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<ChildProfile> _profiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  /// Load all profiles from database
  Future<void> _loadProfiles() async {
    setState(() => _isLoading = true);

    try {
      final results = await _dbService.getAllChildren();
      setState(() {
        _profiles = results.map((map) => ChildProfile.fromMap(map)).toList();
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

  /// Navigate to add profile screen
  Future<void> _navigateToAddProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProfileScreen()),
    );

    // Reload if profile was added
    if (result == true) {
      _loadProfiles();
    }
  }

  /// Navigate to profile detail
  Future<void> _navigateToDetail(ChildProfile profile) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileDetailScreen(profile: profile),
      ),
    );

    // Reload if profile was updated or deleted
    if (result == true) {
      _loadProfiles();
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
                child:
                    _isLoading
                        ? _buildLoadingState()
                        : _profiles.isEmpty
                        ? _buildEmptyState()
                        : _buildProfileList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddProfile,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Build header section
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          Icon(
            Icons.child_care,
            size: AppDimensions.iconL,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            'Profil Anak',
            style: AppTextStyles.h2.copyWith(color: AppColors.primary),
          ),
          const Spacer(),
          if (_profiles.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingM,
                vertical: AppDimensions.spacingS,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
              ),
              child: Text(
                '${_profiles.length} anak',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  /// Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.child_care_outlined,
              size: 100,
              color: AppColors.primary.withOpacity(0.3),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              'Belum Ada Profil Anak',
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Tambahkan profil anak pertama untuk mulai\nmemantau tumbuh kembangnya',
              style: AppTextStyles.body2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            ElevatedButton.icon(
              onPressed: _navigateToAddProfile,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Profil Anak'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingL,
                  vertical: AppDimensions.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build profile list
  Widget _buildProfileList() {
    return RefreshIndicator(
      onRefresh: _loadProfiles,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        itemCount: _profiles.length,
        itemBuilder: (context, index) {
          return _buildProfileCard(_profiles[index]);
        },
      ),
    );
  }

  /// Build individual profile card
  Widget _buildProfileCard(ChildProfile profile) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      onTap: () => _navigateToDetail(profile),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color:
                  profile.gender == 'L'
                      ? AppColors.info.withOpacity(0.2)
                      : Colors.pink.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Icon(
              profile.gender == 'L' ? Icons.boy : Icons.girl,
              size: AppDimensions.iconL,
              color: profile.gender == 'L' ? AppColors.info : Colors.pink,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  profile.name,
                  style: AppTextStyles.h4,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spacingXS),

                // Age
                Row(
                  children: [
                    Icon(
                      Icons.cake_outlined,
                      size: AppDimensions.iconS,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppDimensions.spacingXS),
                    Text(profile.ageDescription, style: AppTextStyles.body2),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacingXS),

                // Gender
                Row(
                  children: [
                    Icon(
                      profile.gender == 'L' ? Icons.male : Icons.female,
                      size: AppDimensions.iconS,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppDimensions.spacingXS),
                    Text(profile.genderDisplay, style: AppTextStyles.body2),
                  ],
                ),
              ],
            ),
          ),

          // Arrow
          Icon(
            Icons.chevron_right,
            color: AppColors.textHint,
            size: AppDimensions.iconM,
          ),
        ],
      ),
    );
  }
}

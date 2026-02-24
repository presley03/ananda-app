import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../widgets/compact_stats_inline.dart';
import '../widgets/recent_activity_list.dart';
import '../services/database_service.dart';
import '../models/user_profile.dart';
import '../models/child_profile.dart';
import '../models/material.dart' as model;
import 'screening/kpsp_age_selection_screen.dart';
import 'screening/nutrition_input_screen.dart';
import 'screening/tdd_age_selection_screen.dart';
import 'screening/mchat_age_selection_screen.dart';
import 'material_detail_screen.dart';
import 'material_search_screen.dart';
import 'user_profile_form_screen.dart';
import 'user_profile_view_screen.dart';
import 'bookmark_screen.dart';
import 'profile/profile_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _db = DatabaseService();
  UserProfile? _userProfile;
  List<ChildProfile> _children = [];
  ChildProfile? get _activeChild =>
      _children.isNotEmpty ? _children[_activeChildIndex] : null;
  int _activeChildIndex = 0;
  final PageController _childPageController = PageController();
  List<Map<String, dynamic>> _recommendedMaterials = [];
  String _greeting = 'Selamat pagi';
  int _screeningCount = 0;
  int _materialsReadCount = 0;
  int _childProfilesCount = 0;
  List<ActivityListItem> _recentActivities = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _childPageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadUserProfile(),
      _loadDashboardStats(),
      _loadActiveChild(),
    ]);
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await _db.getUserProfile();
      final hour = DateTime.now().hour;
      String timeGreet;
      if (hour < 12) {
        timeGreet = 'Selamat pagi';
      } else if (hour < 15) {
        timeGreet = 'Selamat siang';
      } else if (hour < 18) {
        timeGreet = 'Selamat sore';
      } else {
        timeGreet = 'Selamat malam';
      }
      final role = profile?.role ?? '';
      final greeting = role.isNotEmpty ? '$timeGreet, $role:' : '$timeGreet,';
      setState(() {
        _userProfile = profile;
        _greeting = greeting;
      });
    } catch (e) {
      /* silent */
    }
  }

  Future<void> _loadActiveChild() async {
    try {
      final childMaps = await _db.getAllChildren();
      if (childMaps.isNotEmpty) {
        final children = childMaps.map((m) => ChildProfile.fromMap(m)).toList();
        setState(() => _children = children);
        await _loadRecommendations(children.first);
      }
    } catch (e) {
      /* silent */
    }
  }

  Future<void> _loadRecommendations(ChildProfile child) async {
    try {
      final db = await _db.database;
      // Try exact match first
      var mats = await db.query(
        'materials',
        where: 'category = ?',
        whereArgs: [child.materialCategory],
        limit: 3,
      );
      // If no results, get any materials
      if (mats.isEmpty) {
        mats = await db.query('materials', limit: 3);
      }
      setState(() => _recommendedMaterials = mats);
    } catch (e) {
      /* silent */
    }
  }

  Future<void> _loadDashboardStats() async {
    try {
      final db = await _db.database;
      final s = await db.rawQuery(
        'SELECT COUNT(*) as count FROM screening_results',
      );
      _screeningCount = s.first['count'] as int? ?? 0;
      final b = await db.rawQuery('SELECT COUNT(*) as count FROM bookmarks');
      _materialsReadCount = b.first['count'] as int? ?? 0;
      final p = await db.rawQuery('SELECT COUNT(*) as count FROM children');
      _childProfilesCount = p.first['count'] as int? ?? 0;
      final activities = await db.rawQuery('''
        SELECT screening_type, created_at FROM screening_results
        ORDER BY created_at DESC LIMIT 3
      ''');
      _recentActivities =
          activities.map((a) {
            final type = a['screening_type'] as String;
            final createdAt = DateTime.parse(a['created_at'] as String);
            String title;
            IconData icon;
            Color color;
            switch (type) {
              case 'kpsp':
                title = 'KPSP Skrining';
                icon = Icons.fact_check_rounded;
                color = AppColors.accentTeal;
                break;
              case 'nutrition':
                title = 'Kalkulator Gizi';
                icon = Icons.restaurant_rounded;
                color = AppColors.success;
                break;
              case 'tdd':
                title = 'TDD Skrining';
                icon = Icons.hearing_rounded;
                color = AppColors.accentYellow;
                break;
              case 'mchat':
                title = 'M-CHAT-R';
                icon = Icons.psychology_rounded;
                color = AppColors.accentPurple;
                break;
              default:
                title = 'Skrining';
                icon = Icons.check_circle_rounded;
                color = AppColors.primary;
            }
            return ActivityListItem(
              title: title,
              timeAgo: _formatTimeAgo(createdAt),
              icon: icon,
              color: color,
            );
          }).toList();
      setState(() {});
    } catch (e) {
      /* silent */
    }
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays} hari lalu';
    if (diff.inHours > 0) return '${diff.inHours} jam lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes} menit lalu';
    return 'Baru saja';
  }

  Future<void> _onUserTap() async {
    if (_userProfile == null) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => const UserProfileFormScreen(isFirstTime: false),
        ),
      );
      if (result == true) _loadUserProfile();
    } else {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileViewScreen(profile: _userProfile!),
        ),
      );
      if (result == true) _loadUserProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Kartu anak aktif â€” carousel
                if (_children.isNotEmpty) ...[
                  _buildChildCarousel(),
                  const SizedBox(height: 24),
                ],

                // Rekomendasi materi sesuai usia anak
                if (_recommendedMaterials.isNotEmpty) ...[
                  _buildSectionLabel(
                    'REKOMENDASI UNTUK ${_activeChild?.name.toUpperCase() ?? "ANAK"}',
                  ),
                  const SizedBox(height: 8),
                  _buildRecommendations(),
                  const SizedBox(height: 24),
                ],

                _buildSectionLabel('TOOLS SKRINING'),
                const SizedBox(height: 8),
                _buildScreeningCards(),

                if (_recentActivities.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSectionLabel('AKTIVITAS TERAKHIR'),
                  const SizedBox(height: 8),
                  RecentActivityList(activities: _recentActivities),
                ],

                const SizedBox(height: 24),
                _buildSectionLabel('TERSIMPAN'),
                const SizedBox(height: 8),
                _buildBookmarkButton(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // HEADER
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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _onUserTap,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const MaterialSearchScreen(),
                            ),
                          ),
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.black12, width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Cari materi, skrining...',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // Jika sudah isi profil: tampilkan nama
              // Jika belum: ajakan isi biodata
              if (_userProfile != null) ...[
                Text(
                  _greeting,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 2),
                Text(
                  _userProfile!.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ] else ...[
                Text(
                  _greeting,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _onUserTap,
                  child: Row(
                    children: [
                      const Text(
                        'Silakan isi data Anda',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Isi Sekarang',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              CompactStatsInline(
                screeningCount: _screeningCount,
                materialsReadCount: _materialsReadCount,
                childProfilesCount: _childProfilesCount,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CHILD CAROUSEL
  Widget _buildChildCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 130,
          child: PageView.builder(
            controller: _childPageController,
            itemCount: _children.length,
            onPageChanged: (index) async {
              setState(() => _activeChildIndex = index);
              await _loadRecommendations(_children[index]);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index < _children.length - 1 ? 12 : 0,
                ),
                child: _buildChildCard(_children[index]),
              );
            },
          ),
        ),
        // Dot indicator â€” hanya tampil kalau > 1 anak
        if (_children.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_children.length, (i) {
              final isActive = i == _activeChildIndex;
              final child = _children[i];
              final isBoy = child.gender == 'L';
              final color =
                  isBoy ? AppColors.accentTeal : const Color(0xFFE0679A);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 20 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: isActive ? color : color.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }

  // CHILD CARD
  Widget _buildChildCard(ChildProfile child) {
    final isBoy = child.gender == 'L';
    final color = isBoy ? AppColors.accentTeal : const Color(0xFFE0679A);
    final bgColor = isBoy ? const Color(0xFFEDFAFF) : const Color(0xFFFFEDF5);

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileListScreen()),
        );
        _loadData();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Avatar anak
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isBoy ? Icons.boy_rounded : Icons.girl_rounded,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: 14),

            // Info anak
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          child.genderDisplay,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        child.ageDescription,
                        style: TextStyle(
                          fontSize: 13,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Progress bar usia sederhana
                  _buildAgeProgress(child),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right_rounded,
              color: color.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeProgress(ChildProfile child) {
    // Progress 0-60 bulan (5 tahun)
    final months = child.ageInMonths.clamp(0, 60);
    final progress = months / 60;
    final color =
        child.gender == 'L' ? AppColors.accentTeal : const Color(0xFFE0679A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${child.ageInMonths} bulan dari 60 bulan (5 tahun)',
          style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.7)),
        ),
      ],
    );
  }

  // REKOMENDASI
  Widget _buildRecommendations() {
    const palette = [
      [Color(0xFFFFF0ED), Color(0xFFFF6B6B)],
      [Color(0xFFEDF6FF), Color(0xFF5B9BD5)],
      [Color(0xFFFFFBED), Color(0xFFD4AC0D)],
    ];
    return Column(
      children: List.generate(_recommendedMaterials.length, (i) {
        final mat = _recommendedMaterials[i];
        final accent = palette[i % palette.length][1];
        final title = mat['title'] as String;
        final subcat = mat['subcategory'] as String? ?? '';
        final image = mat['image'] as String? ?? '';

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GestureDetector(
            onTap: () {
              final material = model.Material.fromMap(mat);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => MaterialDetailScreen(
                        material: material,
                        isBookmarked: false,
                        onBookmarkToggle: () {},
                      ),
                ),
              );
            },
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFF5F5F5),
              ),
              clipBehavior: Clip.hardEdge,
              child: Row(
                children: [
                  // Gambar di kiri
                  SizedBox(
                    width: 110,
                    height: 110,
                    child:
                        image.isNotEmpty
                            ? Image.asset(
                              image,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    color: accent.withValues(alpha: 0.15),
                                    child: Icon(
                                      Icons.image_rounded,
                                      color: accent,
                                      size: 32,
                                    ),
                                  ),
                            )
                            : Container(
                              color: accent.withValues(alpha: 0.15),
                              child: Icon(
                                Icons.article_rounded,
                                color: accent,
                                size: 32,
                              ),
                            ),
                  ),
                  // Konten di kanan
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              subcat,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: accent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                'Baca selengkapnya',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 11,
                                color: accent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // SECTION LABEL
  Widget _buildSectionLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  // MATERI CARDS

  // SCREENING CARDS
  Widget _buildScreeningCards() {
    final items = [
      {
        'label': 'KPSP',
        'sub': 'Skrining Perkembangan',
        'bg': const Color(0xFFFFF0ED),
        'accent': AppColors.primary,
        'icon': Icons.fact_check_rounded,
      },
      {
        'label': 'Kalkulator Gizi',
        'sub': 'Nutrisi & Antropometri',
        'bg': const Color(0xFFEDFFF5),
        'accent': AppColors.success,
        'icon': Icons.restaurant_rounded,
      },
      {
        'label': 'TDD',
        'sub': 'Tes Daya Dengar',
        'bg': const Color(0xFFEDF6FF),
        'accent': AppColors.accentTeal,
        'icon': Icons.hearing_rounded,
      },
      {
        'label': 'M-CHAT-R',
        'sub': 'Skrining Autisme',
        'bg': const Color(0xFFF3EDFF),
        'accent': AppColors.accentPurple,
        'icon': Icons.psychology_rounded,
      },
    ];
    final taps = [
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const KpspAgeSelectionScreen()),
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NutritionInputScreen()),
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TddAgeSelectionScreen()),
      ),
      () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MchatAgeSelectionScreen(child: _activeChild),
        ),
      ),
    ];
    return Column(
      children: List.generate(
        items.length,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: taps[i],
            child: _buildSimpleCard(
              bg: items[i]['bg'] as Color,
              accent: items[i]['accent'] as Color,
              icon: items[i]['icon'] as IconData,
              title: items[i]['label'] as String,
              subtitle: items[i]['sub'] as String,
              subtitleColored: true,
            ),
          ),
        ),
      ),
    );
  }

  // GENERIC SIMPLE CARD
  Widget _buildSimpleCard({
    required Color bg,
    required Color accent,
    required IconData icon,
    required String title,
    required String subtitle,
    bool subtitleColored = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: subtitleColored ? accent : AppColors.textSecondary,
                    fontWeight:
                        subtitleColored ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: accent.withValues(alpha: 0.6),
            size: 20,
          ),
        ],
      ),
    );
  }

  // BOOKMARK BUTTON
  Widget _buildBookmarkButton() {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookmarkScreen()),
          ),
      child: _buildSimpleCard(
        bg: AppColors.primaryLight,
        accent: AppColors.primary,
        icon: Icons.bookmark_rounded,
        title: 'Materi Tersimpan',
        subtitle: 'Lihat artikel yang sudah kamu bookmark',
      ),
    );
  }
}

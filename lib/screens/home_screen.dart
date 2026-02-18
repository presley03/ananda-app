import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';
import '../widgets/top_bar.dart';
import '../widgets/compact_stats_inline.dart';
import '../widgets/category_section.dart';
import '../widgets/screening_tools_section.dart';
import '../widgets/recent_activity_list.dart';
import '../services/database_service.dart';
import '../models/user_profile.dart';
import 'screening/kpsp_age_selection_screen.dart';
import 'screening/nutrition_input_screen.dart';
import 'screening/tdd_age_selection_screen.dart';
import 'screening/mchat_questions_screen.dart';
import 'material_list_screen.dart';
import 'material_search_screen.dart';
import 'user_profile_form_screen.dart';
import 'user_profile_view_screen.dart';

/// Home Screen - Minimalist Design
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _db = DatabaseService();
  UserProfile? _userProfile;
  String _greeting = 'Selamat pagi';
  bool _isLoading = true;

  // Stats data
  int _screeningCount = 0;
  int _materialsReadCount = 0;
  int _childProfilesCount = 0;
  List<ActivityListItem> _recentActivities = [];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadDashboardStats();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await _db.getUserProfile();
      final greeting = await _db.getUserGreeting();

      setState(() {
        _userProfile = profile;
        _greeting = greeting;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDashboardStats() async {
    try {
      final db = await _db.database;

      final screeningResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM screening_results',
      );
      _screeningCount = screeningResult.first['count'] as int? ?? 0;

      final bookmarkResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM bookmarks',
      );
      _materialsReadCount = bookmarkResult.first['count'] as int? ?? 0;

      final profileResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM children',
      );
      _childProfilesCount = profileResult.first['count'] as int? ?? 0;

      final activities = await db.rawQuery('''
        SELECT screening_type, created_at
        FROM screening_results
        ORDER BY created_at DESC
        LIMIT 3
      ''');

      _recentActivities =
          activities.map((activity) {
            final type = activity['screening_type'] as String;
            final createdAt = DateTime.parse(activity['created_at'] as String);
            final timeAgo = _formatTimeAgo(createdAt);

            String title;
            IconData icon;
            Color color;

            switch (type) {
              case 'kpsp':
                title = 'KPSP Skrining';
                icon = Icons.fact_check_rounded;
                color = const Color(0xFF42A5F5);
                break;
              case 'nutrition':
                title = 'Kalkulator Gizi';
                icon = Icons.restaurant_rounded;
                color = const Color(0xFF66BB6A);
                break;
              case 'tdd':
                title = 'TDD Skrining';
                icon = Icons.hearing_rounded;
                color = const Color(0xFFFFB74D);
                break;
              case 'mchat':
                title = 'M-CHAT-R';
                icon = Icons.psychology_rounded;
                color = const Color(0xFFEC407A);
                break;
              default:
                title = 'Skrining';
                icon = Icons.check_circle_rounded;
                color = AppColors.primary;
            }

            return ActivityListItem(
              title: title,
              timeAgo: timeAgo,
              icon: icon,
              color: color,
            );
          }).toList();

      setState(() {});
    } catch (e) {
      // Silent error
    }
  }

  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }

  Future<void> _onUserTap() async {
    if (_userProfile == null) {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => const UserProfileFormScreen(isFirstTime: false),
        ),
      );

      if (result == true) {
        _loadUserProfile();
      }
    } else {
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileViewScreen(profile: _userProfile!),
        ),
      );

      if (result == true) {
        _loadUserProfile();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              TopBar(
                onUserTap: _onUserTap,
                onSearchTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MaterialSearchScreen(),
                    ),
                  );
                },
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Greeting + Stats (Minimalist, No Card)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Greeting small
                            Text(
                              '$_greeting, ☀️',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Name big
                            Text(
                              _userProfile?.name ?? 'Bunda',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Stats inline
                            CompactStatsInline(
                              screeningCount: _screeningCount,
                              materialsReadCount: _materialsReadCount,
                              childProfilesCount: _childProfilesCount,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Materi Edukatif
                      _buildSectionHeader('Materi Edukatif'),
                      const SizedBox(height: 12),
                      CategorySection(
                        title: '', // Empty - handled by header above
                        onCategory01Tap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const MaterialListScreen(
                                    initialCategory: '0-1',
                                  ),
                            ),
                          );
                        },
                        onCategory12Tap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const MaterialListScreen(
                                    initialCategory: '1-2',
                                  ),
                            ),
                          );
                        },
                        onCategory25Tap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const MaterialListScreen(
                                    initialCategory: '2-5',
                                  ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 28),

                      // Tools Skrining
                      _buildSectionHeader('Tools Skrining'),
                      const SizedBox(height: 12),
                      ScreeningToolsSection(
                        title: '', // Empty - handled by header above
                        onKPSPTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const KpspAgeSelectionScreen(),
                            ),
                          );
                        },
                        onGiziTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NutritionInputScreen(),
                            ),
                          );
                        },
                        onTDDTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TddAgeSelectionScreen(),
                            ),
                          );
                        },
                        onMCHATTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const MchatQuestionsScreen(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 28),

                      // Recent Activity
                      if (_recentActivities.isNotEmpty) ...[
                        _buildSectionHeader('Aktivitas Terakhir'),
                        const SizedBox(height: 12),
                        RecentActivityList(activities: _recentActivities),
                        const SizedBox(height: 28),
                      ],

                      const SizedBox(height: 40),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';
import '../widgets/top_bar.dart';
import '../widgets/greeting_section.dart';
import '../widgets/category_section.dart';
import '../widgets/screening_tools_section.dart';
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

/// Home Screen (with User Profile support)
/// Main home screen dengan:
/// - Top Bar (user, search)
/// - Greeting Section (personalized)
/// - Category Section (Materi Edukatif)
/// - Screening Tools Section
///
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _db = DatabaseService();
  UserProfile? _userProfile;
  String _greeting = 'Selamat pagi, Bunda!';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// Load user profile from database
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

  /// Handle user icon tap
  Future<void> _onUserTap() async {
    if (_userProfile == null) {
      // No profile yet, navigate to form
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => const UserProfileFormScreen(isFirstTime: false),
        ),
      );

      if (result == true) {
        _loadUserProfile(); // Reload profile
      }
    } else {
      // Has profile, show profile view
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileViewScreen(profile: _userProfile!),
        ),
      );

      if (result == true) {
        _loadUserProfile(); // Reload if edited
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient background
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
                  // Navigate to search screen
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
                      // Greeting Section (personalized!)
                      GreetingSection(
                        userName: _userProfile?.name ?? 'Bunda',
                        subtitle:
                            'Mari pantau tumbuh kembang si kecil hari ini! 👶',
                      ),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Category Section - Materi Edukatif
                      CategorySection(
                        title: 'Materi Edukatif',
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

                      const SizedBox(height: AppDimensions.spacingXL),

                      // Screening Tools Section
                      ScreeningToolsSection(
                        title: 'Tools Skrining',
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

                      const SizedBox(height: AppDimensions.spacingXL),
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
}

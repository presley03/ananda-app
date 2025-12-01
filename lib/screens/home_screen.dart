import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/dimensions.dart';
import '../widgets/top_bar.dart';
import '../widgets/greeting_section.dart';
import '../widgets/category_section.dart';
import '../widgets/screening_tools_section.dart';
import 'screening/kpsp_age_selection_screen.dart';
import 'screening/nutrition_input_screen.dart';
import 'screening/tdd_age_selection_screen.dart';

/// Home Screen
/// Main home screen dengan:
/// - Top Bar (user, search, notification)
/// - Greeting Section
/// - Category Section (Materi Edukatif)
/// - Screening Tools Section
///
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                hasNotification: true, // Show notification badge
                onUserTap: () {
                  // TODO: Navigate to profile/user settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile - Coming soon! 👤'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                onSearchTap: () {
                  // TODO: Navigate to search screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Search - Coming soon! 🔍'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                onNotificationTap: () {
                  // TODO: Navigate to notifications
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifications - Coming soon! 🔔'),
                      duration: Duration(seconds: 1),
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
                      // Greeting Section
                      const GreetingSection(
                        userName: 'Bunda',
                        subtitle:
                            'Mari pantau tumbuh kembang si kecil hari ini! 👶',
                      ),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Category Section - Materi Edukatif
                      CategorySection(
                        title: 'Materi Edukatif',
                        onCategory01Tap: () {
                          // TODO: Navigate to Materi 0-1 Tahun
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Materi 0-1 Tahun - Coming soon! 👶',
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        onCategory12Tap: () {
                          // TODO: Navigate to Materi 1-2 Tahun
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Materi 1-2 Tahun - Coming soon! 🧒',
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        onCategory25Tap: () {
                          // TODO: Navigate to Materi 2-5 Tahun
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Materi 2-5 Tahun - Coming soon! 👦',
                              ),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: AppDimensions.spacingXL),

                      // Screening Tools Section
                      ScreeningToolsSection(
                        title: 'Tools Skrining',
                        onKPSPTap: () {
                          // Navigate to KPSP screening
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const KpspAgeSelectionScreen(),
                            ),
                          );
                        },
                        onGiziTap: () {
                          // Navigate to Nutrition calculator
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NutritionInputScreen(),
                            ),
                          );
                        },
                        onTDDTap: () {
                          // Navigate to TDD screening
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TddAgeSelectionScreen(),
                            ),
                          );
                        },
                        onMCHATTap: () {
                          // TODO: Navigate to M-CHAT screening
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'M-CHAT-R Screening - Coming soon! 🧩',
                              ),
                              duration: Duration(seconds: 1),
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

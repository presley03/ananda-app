import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/app_info.dart';
import '../utils/constants/dimensions.dart';

/// Splash Screen
/// Tampil saat app pertama kali dibuka
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Start animation
    _animationController.forward();

    // Navigate after delay
    _navigateAfterDelay();
  }

  /// Check first launch dan navigate
  Future<void> _navigateAfterDelay() async {
    // Wait for animation + minimum splash time
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // Check if first launch
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(AppInfo.keyFirstLaunch) ?? true;
    final disclaimerAccepted =
        prefs.getBool(AppInfo.keyDisclaimerAccepted) ?? false;

    // Navigate based on state
    if (!mounted) return;

    if (isFirstLaunch || !disclaimerAccepted) {
      // First launch - show disclaimer dialog on home screen
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'showDisclaimer': true},
      );
    } else {
      // Returning user - go directly to home
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      // Logo - sementara pakai icon
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(90),
                        ),
                        child: const Icon(
                          Icons.child_care,
                          size: 100,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spacingL),

                      // App Name
                      const Text(
                        'ANANDA',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: AppDimensions.spacingS),

                      // Tagline
                      const Text(
                        'Tumbuh Kembang Anak',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.spacingXXL),

                // Loading indicator
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: child,
                    );
                  },
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Version info
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: child,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.spacingL,
                    ),
                    child: Text(
                      'v${AppInfo.appVersion}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'material_list_screen.dart';
import 'profile/profile_list_screen.dart';

/// Main Navigation Wrapper
/// Wrapper screen yang handle bottom navigation dan switching antar screens
///
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // List of screens untuk tiap tab
  final List<Widget> _screens = [
    const HomeScreen(), // 0: Beranda
    const MaterialListScreen(), // 1: Materi
    const ProfileListScreen(), // 2: Profil - UPDATED!
    const SettingsScreen(), // 3: Pengaturan
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

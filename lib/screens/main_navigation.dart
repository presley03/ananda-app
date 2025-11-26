import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import 'material_list_screen.dart';

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
    const PlaceholderScreen(
      title: 'Profil',
      icon: Icons.child_care,
    ), // 2: Profil
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

/// Placeholder Screen
/// Temporary screen untuk tabs yang belum dibuat
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.teal),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.teal.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming Soon!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

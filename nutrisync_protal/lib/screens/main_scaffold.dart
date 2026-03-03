import 'package:flutter/material.dart';

import 'package:nutrisync_protal/screens/bmi/bmi_results_screen.dart';
import 'package:nutrisync_protal/screens/impact/impact_overview_screen.dart';
import 'package:nutrisync_protal/screens/impact/impact_simulation_screen.dart';
import 'package:nutrisync_protal/screens/nutrition/nutrition_summary_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const BmiResultsScreen(),
    const ImpactOverviewScreen(),
    const Scaffold(
      body: Center(child: Text('Add New Data')),
    ), // Placeholder for +
    const ImpactSimulationScreen(),
    const NutritionSummaryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(index: 0, icon: Icons.home_rounded),
              _buildNavItem(index: 1, icon: Icons.analytics_rounded),
              _buildNavItemCenter(),
              _buildNavItem(index: 3, icon: Icons.menu_book_rounded),
              _buildNavItem(index: 4, icon: Icons.person_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required int index, required IconData icon}) {
    final bool isActive = _currentIndex == index;
    const Color selectedColor = Color(0xFFEE3638);
    const Color unselectedColor = Color(0xFF2D2D4D);

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Icon(
          icon,
          size: 28,
          color: isActive
              ? selectedColor
              : unselectedColor.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildNavItemCenter() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEB),
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFEE3638).withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEE3638).withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.add_circle_outline_rounded,
            color: Color(0xFFEE3638),
            size: 32,
          ),
        ),
      ),
    );
  }
}

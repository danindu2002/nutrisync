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
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(index: 0, icon: Icons.home_rounded),
              _buildNavItem(index: 1, icon: Icons.show_chart_rounded),
              _buildNavItemCenter(),
              _buildNavItem(index: 3, icon: Icons.bookmark_rounded),
              _buildNavItem(index: 4, icon: Icons.person_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required int index, required IconData icon}) {
    const Color iconColor = Color(0xFF2D2D2D);

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        height: 64,
        child: Icon(icon, size: 26, color: iconColor),
      ),
    );
  }

  Widget _buildNavItemCenter() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFFF5C5C),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF5C5C).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

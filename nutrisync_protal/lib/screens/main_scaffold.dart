import 'package:flutter/material.dart';
import 'package:nutrisync_protal/core/theme/app_theme.dart';
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
      decoration: BoxDecoration(
        color: AppTheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(index: 0, icon: Icons.home_rounded),
              _buildNavItem(index: 1, icon: Icons.show_chart_rounded),
              _buildNavItemCenter(),
              _buildNavItem(index: 3, icon: Icons.person_outline_rounded),
              _buildNavItem(index: 4, icon: Icons.restaurant_menu_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required int index, required IconData icon}) {
    final bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primary.withValues(alpha: 0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 24,
          color: isActive ? AppTheme.primary : AppTheme.textLight,
        ),
      ),
    );
  }

  Widget _buildNavItemCenter() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppTheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:NutriSync/screens/bmi/bmi_results_screen.dart';
import 'package:NutriSync/screens/impact/impact_overview_screen.dart';
import 'package:NutriSync/screens/impact/impact_simulation_screen.dart';
import 'package:NutriSync/screens/nutrition/nutrition_summary_screen.dart';

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
              _buildNavItem(
                index: 0,
                assetPath: 'assets/images/HOME FILLED BUTTON.png',
              ),
              _buildNavItem(
                index: 1,
                assetPath: 'assets/images/CHAT FILLED.png',
              ),
              _buildNavItemCenter(),
              _buildNavItem(
                index: 3,
                assetPath: 'assets/images/saved jobs.png',
              ),
              _buildNavItem(
                index: 4,
                assetPath: 'assets/images/profile vector.png',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required int index, required String assetPath}) {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        height: 64,
        child: Center(
          child: Image.asset(
            assetPath,
            width: 26,
            height: 26,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItemCenter() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Image.asset(
        'assets/images/FAB.png',
        width: 50,
        height: 50,
        fit: BoxFit.contain,
      ),
    );
  }
}

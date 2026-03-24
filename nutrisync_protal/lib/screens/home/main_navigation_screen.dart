import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../dashboard/dashboard_screen.dart';
import '../scan_meal/scan_meal_screen.dart';
import 'home_screen.dart';
import '../meal_log/meal_log_screen.dart';
import '../user_profile/my_profile_screen.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Create unique GlobalKeys for each tab's Navigator
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // Home
    GlobalKey<NavigatorState>(), // Analytics
    GlobalKey<NavigatorState>(), // Add Meal
    GlobalKey<NavigatorState>(), // Meal Plan
    GlobalKey<NavigatorState>(), // Profile
  ];

  void _onTap(int index) {
    if (index == 2) {
      // Open Add Meal Screen as a full screen
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ScanMealScreen()),
      );
      return;
    }

    if (_currentIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This ensures back button pops nested screens before closing the app
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final NavigatorState? currentNav = _navigatorKeys[_currentIndex].currentState;
        if (currentNav != null && currentNav.canPop()) {
          currentNav.pop();
        } else {
          // If we can't pop anymore in the nested nav, we could let the app close
          // or navigate back to the first tab.
          if (_currentIndex != 0) {
            setState(() => _currentIndex = 0);
          } else {
            // Exit app
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildTabNavigator(0, HomeScreen(onMealLogTap: () {
              setState(() => _currentIndex = 3);
            })),
            _buildTabNavigator(1, const DashboardScreen()),
            const SizedBox.shrink(), // Placeholder for center button
            _buildTabNavigator(3, const MealLogScreen()),
            _buildTabNavigator(4, const MyProfileScreen()),
          ],
        ),
        bottomNavigationBar: _BottomNavBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
        ),
      ),
    );
  }

  // Helper method to wrap each tab in a nested Navigator
  Widget _buildTabNavigator(int index, Widget rootPage) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => rootPage,
        );
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, 0),
              _navItem(Icons.show_chart, 1),

              GestureDetector(
                onTap: () => onTap(2),
                child: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),

              _navItem(Icons.receipt_long, 3),
              _navItem(Icons.person_outline, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Icon(
        icon,
        size: 26,
        color: currentIndex == index
            ? AppColors.primary
            : Colors.grey.shade500,
      ),
    );
  }
}

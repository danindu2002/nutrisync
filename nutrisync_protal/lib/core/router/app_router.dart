import 'package:flutter/material.dart';
import 'package:nutrisync_protal/screens/bmi/bmi_results_screen.dart';
import 'package:nutrisync_protal/screens/impact/impact_simulation_screen.dart';
import 'package:nutrisync_protal/screens/impact/impact_overview_screen.dart';
import 'package:nutrisync_protal/screens/nutrition/nutrition_summary_screen.dart';
import 'package:nutrisync_protal/screens/main_scaffold.dart';

class AppRouter {
  static const String main = '/';
  static const String bmiResults = '/bmi-results';
  static const String impactSimulation = '/impact-simulation';
  static const String impactOverview = '/impact-overview';
  static const String nutritionSummary = '/nutrition-summary';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(
          builder: (_) => const MainScaffold(),
          settings: settings,
        );
      case bmiResults:
        return MaterialPageRoute(
          builder: (_) => const BmiResultsScreen(),
          settings: settings,
        );
      case impactSimulation:
        return MaterialPageRoute(
          builder: (_) => const ImpactSimulationScreen(),
          settings: settings,
        );
      case nutritionSummary:
        return MaterialPageRoute(
          builder: (_) => const NutritionSummaryScreen(),
          settings: settings,
        );
      case impactOverview:
        return MaterialPageRoute(
          builder: (_) => const ImpactOverviewScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(builder: (_) => const BmiResultsScreen());
    }
  }
}

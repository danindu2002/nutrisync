import 'contributing_meal_model.dart';

class RiskModel {
  final String name;
  final String description;
  final double riskLevel;
  final String icon;

  // New fields for popup
  final String subtitle;
  final String warningText;
  final List<ContributingMealModel> contributingMeals;

  RiskModel({
    required this.predictedRisk,
    required this.reasonTitle,
    required this.probability,
    required this.warning,
    required this.contibutedMealList,
    required this.icon,
    required this.subtitle,
    required this.warningText,
    required this.contributingMeals,
  });
}

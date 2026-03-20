class MealSwapModel {
  final String currentMealName;
  final String currentMealImagePath;
  final String currentMealMetric;

  final String suggestedMealName;
  final String suggestedMealImagePath;
  final String suggestedMealMetric;

  MealSwapModel({
    required this.currentMealName,
    required this.currentMealImagePath,
    required this.currentMealMetric,
    required this.suggestedMealName,
    required this.suggestedMealImagePath,
    required this.suggestedMealMetric,
  });
}
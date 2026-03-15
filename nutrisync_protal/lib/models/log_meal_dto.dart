class LogMealDTO {
  final int userId;
  final int? foodId; // manual entry nullable
  final double weight;
  final String mealTime;
  final String notes;
  final bool suggestRecommendations;
  final String name;
  final double totalProtein;
  final double totalCarbs;
  final double totalCalories;

  LogMealDTO({
    required this.userId,
    this.foodId,
    required this.weight,
    required this.mealTime,
    required this.notes,
    required this.suggestRecommendations,
    required this.name,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalCalories,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "foodId": foodId,
      "weight": weight,
      "mealTime": mealTime,
      "notes": notes,
      "suggestRecommendations": suggestRecommendations,
      "name": name,
      "totalProtein": totalProtein,
      "totalCarbs": totalCarbs,
      "totalCalories": totalCalories,
    };
  }
}
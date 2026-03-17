class UpdateMealDto {
  final int? mealId; // Using generic ID placeholder if needed
  final double kcal;
  final double protein;
  final double carbs;
  final double fat;

  UpdateMealDto({
    this.mealId,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  Map<String, dynamic> toJson() {
    return {
      if (mealId != null) 'mealId': mealId,
      'kcal': kcal,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }
}

class OnboardingDTO {
  String? fitnessGoal;
  String? goalMotivation;
  String? gender;
  int? age;
  double? heightCm; // Storing as CM for consistency
  double? weightKg;
  String? activityLevel;
  String? goalSpeed;
  String? dietaryPreference;
  List<String> allergies;
  Map<String, String> mealTimes; // e.g. {"breakfast": "08:00"}
  List<String> medicalConditions;
  int? dailyCalorieGoal;
  String? sleepQuality;

  OnboardingDTO({
    this.fitnessGoal,
    this.goalMotivation,
    this.gender,
    this.age = 25,
    this.heightCm = 170,
    this.weightKg = 70,
    this.activityLevel,
    this.goalSpeed,
    this.dietaryPreference,
    this.allergies = const [],
    this.mealTimes = const {},
    this.medicalConditions = const [],
    this.dailyCalorieGoal = 2000,
    this.sleepQuality,
  });

  Map<String, dynamic> toJson() {
    return {
      'fitnessGoal': fitnessGoal,
      'goalMotivation': goalMotivation,
      'gender': gender,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'activityLevel': activityLevel,
      'goalSpeed': goalSpeed,
      'dietaryPreference': dietaryPreference,
      'allergies': allergies,
      'mealTimes': mealTimes,
      'medicalConditions': medicalConditions,
      'dailyCalorieGoal': dailyCalorieGoal,
      'sleepQuality': sleepQuality,
    };
  }
}
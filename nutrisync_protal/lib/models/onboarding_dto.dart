class OnboardingDTO {
  String? username;
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? fitnessGoal;
  String? goalMotivation;
  String? gender;
  int? age;
  double? heightCm;
  double? weightKg;
  double? bmi;
  String? activityLevel;
  String? goalSpeed;
  String? dietaryPreference;
  List<String> allergies = [];
  Map<String, String> mealTimes; // e.g. {"breakfast": "08:00"}
  List<String> medicalConditions = [];
  int? dailyCalorieGoal;
  String? sleepQuality;
  String? regDate;

  OnboardingDTO({
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.password,
    this.fitnessGoal,
    this.goalMotivation,
    this.gender,
    this.age = 25,
    this.heightCm = 170,
    this.weightKg = 70,
    this.bmi,
    this.activityLevel,
    this.goalSpeed,
    this.dietaryPreference,
    this.allergies = const [],
    this.mealTimes = const {},
    this.medicalConditions = const [],
    this.dailyCalorieGoal = 2000,
    this.sleepQuality,
    this.regDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'password': password,
      'fitnessGoal': fitnessGoal,
      'goalMotivation': goalMotivation,
      'gender': gender,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'bmi': bmi ?? 0.0,
      'activityLevel': activityLevel,
      'goalSpeed': goalSpeed,
      'dietaryPreference': dietaryPreference,
      'allergies': allergies,
      'mealTimes': mealTimes,
      'medicalConditions': medicalConditions,
      'dailyCalorieGoal': dailyCalorieGoal,
      'sleepQuality': sleepQuality,
      'regDate': regDate,
    };
  }
}
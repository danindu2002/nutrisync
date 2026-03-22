class ApiMealContribution {
  final int logId;
  final String foodName;
  final String? image;
  final String contribution;

  ApiMealContribution({
    required this.logId,
    required this.foodName,
    this.image,
    required this.contribution,
  });

  factory ApiMealContribution.fromJson(Map<String, dynamic> json) {
    return ApiMealContribution(
      logId: json['logId'] ?? 0,
      foodName: json['foodName'] ?? 'Unknown Meal',
      image: json['image'],
      contribution: json['contribution'] ?? '',
    );
  }
}

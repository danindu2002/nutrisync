class DashboardCaloriesChartDto {
  final List<String> labels;
  final List<double> values;
  final double totalCalories;
  final String range;

  DashboardCaloriesChartDto({
    required this.labels,
    required this.values,
    required this.totalCalories,
    required this.range,
  });

  factory DashboardCaloriesChartDto.fromJson(Map<String, dynamic> json) {
    return DashboardCaloriesChartDto(
      labels: List<String>.from(json['labels'] ?? []),
      values: (json['values'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
      totalCalories: (json['totalCalories'] as num?)?.toDouble() ?? 0.0,
      range: json['range'] ?? '',
    );
  }
}
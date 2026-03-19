class DashboardNutritionChartDto {
  final List<String> labels;
  final List<double> values;
  final String range;

  DashboardNutritionChartDto({
    required this.labels,
    required this.values,
    required this.range,
  });

  factory DashboardNutritionChartDto.fromJson(Map<String, dynamic> json) {
    return DashboardNutritionChartDto(
      labels: List<String>.from(json['labels'] ?? []),
      values: (json['values'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
      range: json['range'] ?? '',
    );
  }
}
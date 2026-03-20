import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/auth_service.dart';
import '../services/dashboard_service.dart';
import '../widgets/common_widgets.dart';
import '../models/dashboard_calories_chart_dto.dart';
import '../models/dashboard_nutrition_chart_dto.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedRange = "1d";

  String _firstName = "User";
  String? _profileImage;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt("userId");

      if (userId == null) return;

      final ApiResponse response = await AuthService.getUserData(userId);

      if (response.status == 200) {
        final data = response.data;

        if (mounted) {
          setState(() {
            _firstName = data["firstName"] ?? "User";
            _score = data["score"] ?? 0;
            _profileImage = data["profileImage"];
          });
        }
      }
    } catch (e) {
      Logger.error("Error loading data: $e");
    }
  }

  void onRangeChanged(String range) {
    setState(() {
      selectedRange = range;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              HomeHeader(
                userName: _firstName,
                profileImageData: _profileImage,
                score: _score,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Calories",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _CaloriesLineChart(
                      selectedRange: selectedRange,
                      onRangeChanged: onRangeChanged,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Nutrition",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _NutritionsBarChart(
                      selectedRange: selectedRange,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CaloriesLineChart extends StatefulWidget {
  final String selectedRange;
  final ValueChanged<String> onRangeChanged;

  const _CaloriesLineChart({
    required this.selectedRange,
    required this.onRangeChanged,
  });

  @override
  State<_CaloriesLineChart> createState() => _CaloriesLineChartState();
}

class _CaloriesLineChartState extends State<_CaloriesLineChart> {
  bool isLoading = true;
  String? errorMessage;

  DashboardCaloriesChartDto? chartData;

  final int userId = 1;

  @override
  void initState() {
    super.initState();
    fetchCaloriesChart(widget.selectedRange);
  }

  @override
  void didUpdateWidget(covariant _CaloriesLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedRange != widget.selectedRange) {
      fetchCaloriesChart(widget.selectedRange);
    }
  }

  Future<void> fetchCaloriesChart(String range) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await DashboardService.getCaloriesChart(
        userId: userId,
        range: range,
      );

      if (response.status == 200 && response.data != null) {
        setState(() {
          chartData = DashboardCaloriesChartDto.fromJson(response.data);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = response.message ?? "Failed to load chart data";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error loading chart data";
        isLoading = false;
      });
    }
  }

  List<FlSpot> buildSpots() {
    final values = chartData?.values ?? [];
    if (values.isEmpty) {
      return const [FlSpot(0, 0)];
    }

    return values
        .asMap()
        .entries
        .map((entry) => FlSpot(
      entry.key.toDouble(),
      entry.value < 0 ? 0 : entry.value,
    ))
        .toList();
  }

  double calculateMaxY() {
    final values = chartData?.values ?? [];
    if (values.isEmpty) return 1000;

    final maxValue = values.reduce((a, b) => a > b ? a : b);

    if (maxValue <= 100) return 100;
    if (maxValue <= 500) return 500;
    if (maxValue <= 1000) return 1000;
    if (maxValue <= 2000) return 2000;
    if (maxValue <= 3000) return 3000;
    if (maxValue <= 5000) return 5000;
    return (maxValue / 1000).ceil() * 1000;
  }

  double calculateInterval() {
    final maxY = calculateMaxY();

    if (maxY <= 100) return 20;
    if (maxY <= 500) return 100;
    if (maxY <= 1000) return 200;
    if (maxY <= 2000) return 500;
    if (maxY <= 5000) return 1000;
    return 2000;
  }

  @override
  Widget build(BuildContext context) {
    final labels = chartData?.labels ?? [];
    final totalCalories = chartData?.totalCalories ?? 0.0;
    final spots = buildSpots();

    final tabs = [
      {"label": "1d", "value": "1d"},
      {"label": "1w", "value": "1w"},
      {"label": "1m", "value": "1m"},
      {"label": "1y", "value": "1y"},
      {"label": "All", "value": "all"},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: tabs.map((tab) {
              final label = tab["label"]!;
              final value = tab["value"]!;

              return GestureDetector(
                onTap: () => widget.onRangeChanged(value),
                child: _TimeTab(label, widget.selectedRange == value),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? Center(
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
                : LineChart(
              LineChartData(
                clipData: const FlClipData.all(),
                minX: 0,
                maxX: spots.isNotEmpty
                    ? (spots.length - 1).toDouble()
                    : 0,
                minY: 0,
                maxY: calculateMaxY(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: calculateInterval(),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: widget.selectedRange != "all",
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= labels.length) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            labels[index],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: calculateInterval(),
                      getTitlesWidget: (val, meta) => Text(
                        val.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved:
                    widget.selectedRange != "all" && spots.length > 2,
                    preventCurveOverShooting: true,
                    curveSmoothness: 0.18,
                    color: AppColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.2),
                          AppColors.primary.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "${totalCalories.toStringAsFixed(0)} kcal",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _NutritionsBarChart extends StatefulWidget {
  final String selectedRange;

  const _NutritionsBarChart({
    required this.selectedRange,
  });

  @override
  State<_NutritionsBarChart> createState() => _NutritionsBarChartState();
}

class _NutritionsBarChartState extends State<_NutritionsBarChart> {
  bool isLoading = true;
  String? errorMessage;
  DashboardNutritionChartDto? chartData;

  final int userId = 1;

  @override
  void initState() {
    super.initState();
    fetchNutritionChart(widget.selectedRange);
  }

  @override
  void didUpdateWidget(covariant _NutritionsBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedRange != widget.selectedRange) {
      fetchNutritionChart(widget.selectedRange);
    }
  }

  Future<void> fetchNutritionChart(String range) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await DashboardService.getNutritionChart(
        userId: userId,
        range: range,
      );

      if (response.status == 200 && response.data != null) {
        setState(() {
          chartData = DashboardNutritionChartDto.fromJson(response.data);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = response.message ?? "Failed to load nutrition chart";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error loading nutrition chart";
        isLoading = false;
      });
    }
  }

  double calculateMaxY() {
    final values = chartData?.values ?? [];
    if (values.isEmpty) return 100;

    final maxValue = values.reduce((a, b) => a > b ? a : b);

    if (maxValue <= 10) return 10;
    if (maxValue <= 50) return 50;
    if (maxValue <= 100) return 100;
    if (maxValue <= 200) return 200;
    if (maxValue <= 500) return 500;
    return (maxValue / 100).ceil() * 100;
  }

  Color getBarColor(String label) {
    switch (label) {
      case "Fat":
        return Colors.black;
      case "Protein":
        return Colors.redAccent;
      case "Carbs":
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }

  BarChartGroupData makeGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 45,
          borderRadius: BorderRadius.circular(12),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: calculateMaxY(),
            color: const Color(0xFFF5F5F5),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = chartData?.labels ?? [];
    final values = chartData?.values ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: isLoading
          ? const SizedBox(
        height: 260,
        child: Center(child: CircularProgressIndicator()),
      )
          : errorMessage != null
          ? SizedBox(
        height: 260,
        child: Center(
          child: Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      )
          : Column(
        children: [
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: calculateMaxY(),
                barTouchData: BarTouchData(enabled: false),
                titlesData: const FlTitlesData(show: false),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(labels.length, (index) {
                  return makeGroup(
                    index,
                    index < values.length ? values[index] : 0,
                    getBarColor(labels[index]),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(labels.length, (index) {
            final label = labels[index];
            final value = index < values.length ? values[index] : 0.0;

            return _nutritionLegend(
              label,
              "${value.toStringAsFixed(1)}g",
              getBarColor(label),
            );
          }),
        ],
      ),
    );
  }

  Widget _nutritionLegend(String title, String val, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(val, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _TimeTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const _TimeTab(this.text, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
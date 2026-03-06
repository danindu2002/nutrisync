import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/common_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text("Calories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _CaloriesLineChart(),
                  const SizedBox(height: 30),
                  const Text("Nutritions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _NutritionsBarChart(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Note: Ensure your DashboardScreen calls _CaloriesLineChart() in the column

class _CaloriesLineChart extends StatefulWidget {
  @override
  State<_CaloriesLineChart> createState() => _CaloriesLineChartState();
}

class _CaloriesLineChartState extends State<_CaloriesLineChart> {
  // Tracking the selected tab
  String selectedTab = "1w";

  // Mock Data sets for different time frames
  final Map<String, Map<String, dynamic>> _chartData = {
    "1d": {
      "burnLeft": "Burn 120 calorie left.",
      "total": "1450",
      "spots": [const FlSpot(0, 1200), const FlSpot(4, 1600), const FlSpot(8, 1450)]
    },
    "1w": {
      "burnLeft": "Burn 250 calorie left.",
      "total": "315", // Matches your Figma 315 kcal header
      "spots": [
        const FlSpot(0, 1850),
        const FlSpot(1, 1930),
        const FlSpot(2, 1800),
        const FlSpot(3, 1700),
        const FlSpot(4, 1900),
        const FlSpot(5, 2050),
        const FlSpot(6, 1950),
      ]
    },
    "1m": {
      "burnLeft": "Burn 50 calorie left.",
      "total": "1980",
      "spots": [const FlSpot(0, 1500), const FlSpot(3, 2000), const FlSpot(6, 1700), const FlSpot(9, 1980)]
    },
    "All": {
      "burnLeft": "Daily average achieved.",
      "total": "1867",
      "spots": [const FlSpot(0, 1000), const FlSpot(5, 1867), const FlSpot(10, 1400)]
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentData = _chartData[selectedTab] ?? _chartData["1w"]!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          // Header: Icon + Calorie Count + "Burn left"
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_fire_department_rounded, color: AppColors.primary, size: 32),
              const SizedBox(width: 8),
              Text(
                currentData["total"],
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              const Text(
                "kcal",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ],
          ),
          Text(
            currentData["burnLeft"],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Time Tabs
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ["1d", "1w", "1m", "All"].map((tab) {
                return _TimeTab(
                  tab,
                  selectedTab == tab,
                  onTap: () => setState(() => selectedTab = tab),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 30),

          // Line Chart
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 100,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 100,
                      reservedSize: 35,
                      getTitlesWidget: (val, _) => Text(
                        val.toInt().toString(),
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 1500, // Adjusted to match Figma range
                maxY: 2100,
                lineBarsData: [
                  LineChartBarData(
                    spots: currentData["spots"],
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.primary,
                    barWidth: 6,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withOpacity(0.4),
                          AppColors.primary.withOpacity(0.01),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeTab extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeTab(this.text, this.isSelected, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _NutritionsBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: const FlTitlesData(show: false),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _makeGroup(0, 70, Colors.black, "20%"),
                  _makeGroup(1, 40, Colors.redAccent, "30%"),
                  _makeGroup(2, 60, Colors.blueAccent, "40%"),
                  _makeGroup(3, 30, Colors.lightGreen, "10%"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _nutritionLegend("Fat", "201g", Colors.black),
          _nutritionLegend("Protein", "158g", Colors.redAccent),
          _nutritionLegend("Carbs", "11g", Colors.blueAccent),
          _nutritionLegend("Macro", "5g", Colors.lightGreen),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroup(int x, double y, Color color, String label) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 45,
          borderRadius: BorderRadius.circular(12),
          backDrawRodData: BackgroundBarChartRodData(show: true, toY: 100, color: const Color(0xFFF5F5F5)),
        ),
      ],
    );
  }

  Widget _nutritionLegend(String title, String val, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(height: 12, width: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(val, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

/*class _TimeTab extends StatelessWidget {
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
      child: Text(text, style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}*/

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
  const _CaloriesLineChart({super.key});

  @override
  State<_CaloriesLineChart> createState() => _CaloriesLineChartState();
}

class _CaloriesLineChartState extends State<_CaloriesLineChart> {
  String selectedTab = "1w";

  final Map<String, Map<String, dynamic>> _chartData = {
    "1d": {
      "burnLeft": "Burn 120 calorie left.",
      "total": "1450",
      "spots": [const FlSpot(0, 1200), const FlSpot(4, 1600), const FlSpot(8, 1450)]
    },
    "1w": {
      "burnLeft": "Burn 250 calorie left.",
      "total": "315",
      "spots": [
        const FlSpot(0, 1850), const FlSpot(1, 1930), const FlSpot(2, 1800),
        const FlSpot(3, 1700), const FlSpot(4, 1900), const FlSpot(5, 2050),
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
      "spots": [
        const FlSpot(0, 1400), const FlSpot(2, 1000), const FlSpot(4, 1867),
        const FlSpot(6, 400), const FlSpot(8, 1600)
      ]
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentData = _chartData[selectedTab] ?? _chartData["1w"]!;
    final List<FlSpot> spots = currentData["spots"];

    // Dynamic scale logic so the line stays within the chart
    double minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    double padding = (maxY - minY) * 0.2; // 20% padding

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildHeader(currentData["total"], currentData["burnLeft"]),
          const SizedBox(height: 20),
          _buildTabs(),
          const SizedBox(height: 30),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                minY: (minY - padding).floorToDouble(),
                maxY: (maxY + padding).ceilToDouble(),
                gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 400),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (val, _) => Text(val.toInt().toString(),
                          style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 6,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors.primary.withOpacity(0.4), AppColors.primary.withOpacity(0.01)],
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

  Widget _buildHeader(String total, String burnLeft) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_fire_department_rounded, color: AppColors.primary, size: 32),
            const SizedBox(width: 8),
            Text(total, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(width: 4),
            const Text("kcal", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
        Text(burnLeft, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ["1d", "1w", "1m", "All"].map((tab) => _TimeTab(
            tab,
            selectedTab == tab,
            onTap: () => setState(() => selectedTab = tab)
        )).toList(),
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
    // Dynamic Data Logic: Defining counts to calculate percentages
    final double fatGrams = 201;
    final double proteinGrams = 158;
    final double carbGrams = 11;
    final double macroGrams = 5;

    double totalGrams = fatGrams + proteinGrams + carbGrams + macroGrams;

    // Percentage strings for the bar labels
    String fatPerc = "${((fatGrams / totalGrams) * 100).toStringAsFixed(0)}%";
    String proteinPerc = "${((proteinGrams / totalGrams) * 100).toStringAsFixed(0)}%";
    String carbPerc = "${((carbGrams / totalGrams) * 100).toStringAsFixed(0)}%";
    String macroPerc = "${((macroGrams / totalGrams) * 100).toStringAsFixed(0)}%";

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
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      // Adding explicit types (double value, TitleMeta meta) resolves the error
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );

                        String text = "";
                        switch (value.toInt()) {
                          case 0: text = fatPerc; break;
                          case 1: text = proteinPerc; break;
                          case 2: text = carbPerc; break;
                          case 3: text = macroPerc; break;
                        }

                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: -25, // Moves text inside the bar
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  _makeGroup(0, (fatGrams / totalGrams) * 100, Colors.black),
                  _makeGroup(1, (proteinGrams / totalGrams) * 100, Colors.redAccent),
                  _makeGroup(2, (carbGrams / totalGrams) * 100, Colors.blueAccent),
                  _makeGroup(3, (macroGrams / totalGrams) * 100, Colors.lightGreen),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _nutritionLegend("Fat", "${fatGrams.toInt()}g", Colors.black),
          _nutritionLegend("Protein", "${proteinGrams.toInt()}g", Colors.redAccent),
          _nutritionLegend("Carbs", "${carbGrams.toInt()}g", Colors.blueAccent),
          _nutritionLegend("Macro", "${macroGrams.toInt()}g", Colors.lightGreen),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 45,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
              bottom: Radius.circular(20)
          ),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: const Color(0xFFF5F5F5),
          ),
        ),
      ],
    );
  }

  Widget _nutritionLegend(String title, String val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const Spacer(),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

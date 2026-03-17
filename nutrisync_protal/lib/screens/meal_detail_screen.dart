import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/constants.dart';
import '../models/update_meal_dto.dart';
import '../services/meal_service.dart';

class MealDetailScreen extends StatefulWidget {
  final Map<String, dynamic> mealData;

  const MealDetailScreen({super.key, required this.mealData});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late TextEditingController kcalController;
  late TextEditingController proteinController;
  late TextEditingController carbsController;
  late TextEditingController fatController;

  // Initial dummy macro values since mealData only has type, name, imageUrl presently
  double currentKcal = 480;
  double currentProtein = 15;
  double currentCarbs = 60;
  double currentFat = 20;

  @override
  void initState() {
    super.initState();
    kcalController = TextEditingController(
      text: currentKcal.toStringAsFixed(0),
    );
    proteinController = TextEditingController(
      text: currentProtein.toStringAsFixed(0),
    );
    carbsController = TextEditingController(
      text: currentCarbs.toStringAsFixed(0),
    );
    fatController = TextEditingController(text: currentFat.toStringAsFixed(0));

    // Listeners to update chart live
    VoidCallback updateChart = () {
      setState(() {
        currentProtein = double.tryParse(proteinController.text) ?? 0;
        currentCarbs = double.tryParse(carbsController.text) ?? 0;
        currentFat = double.tryParse(fatController.text) ?? 0;
        currentKcal = double.tryParse(kcalController.text) ?? 0;
      });
    };

    proteinController.addListener(updateChart);
    carbsController.addListener(updateChart);
    fatController.addListener(updateChart);
    kcalController.addListener(updateChart);
  }

  @override
  void dispose() {
    kcalController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatController.dispose();
    super.dispose();
  }

  Future<void> _saveMeal() async {
    final updateDto = UpdateMealDto(
      mealId: 123, // Dummy ID
      kcal: double.tryParse(kcalController.text) ?? 0,
      protein: double.tryParse(proteinController.text) ?? 0,
      carbs: double.tryParse(carbsController.text) ?? 0,
      fat: double.tryParse(fatController.text) ?? 0,
    );

    await MealService.updateMealNutrition(updateDto);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Meal saved successfully!')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Top Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.network(
              widget.mealData["imageUrl"],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.grey.shade300),
            ),
          ),

          // Back Button
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.3),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 2. Draggable/Scrollable Bottom Sheet Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        widget.mealData["name"],
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppColors.secondary,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Info Row (Time, Kcal, Type)
                      _buildInfoRow(),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),

                      const Text(
                        "Nutrition",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nutrition Donut Chart
                      _buildNutritionChart(),
                      const SizedBox(height: 32),

                      // Editable Macros Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildEditableMacro("PROTEIN (G)", proteinController),
                          const SizedBox(width: 12),
                          _buildEditableMacro("CARBS (G)", carbsController),
                          const SizedBox(width: 12),
                          _buildEditableMacro("FAT (G)", fatController),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _saveMeal,
                          child: const Text(
                            "Save Meal",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _infoItem(Icons.schedule, "10 min", Colors.grey.shade600),
        Container(width: 1, height: 30, color: Colors.grey.shade200),
        _infoItem(
          Icons.local_fire_department_outlined,
          "${kcalController.text} kcal",
          AppColors.primary,
          isEditable: true,
        ),
        Container(width: 1, height: 30, color: Colors.grey.shade200),
        _infoItem(
          Icons.home_outlined,
          _capitalize(widget.mealData["type"]),
          Colors.grey.shade600,
        ),
      ],
    );
  }

  Widget _infoItem(
    IconData icon,
    String label,
    Color color, {
    bool isEditable = false,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey.shade400, size: 24),
        const SizedBox(height: 8),
        if (isEditable)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 35,
                child: TextField(
                  controller: kcalController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 13,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Text(
                "kcal",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontSize: 13,
                ),
              ),
            ],
          )
        else
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
              fontSize: 13,
            ),
          ),
      ],
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Widget _buildNutritionChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 60,
                    startDegreeOffset: 270,
                    sections: _showingSections(),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentKcal.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.secondary,
                      ),
                    ),
                    const Text(
                      "KCAL",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _indicator(const Color(0xFF4ADE80), "Protein"),
              const SizedBox(width: 16),
              _indicator(const Color(0xFF60A5FA), "Carbs"),
              const SizedBox(width: 16),
              _indicator(const Color(0xFFFB923C), "Fat"),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    double total = currentProtein + currentCarbs + currentFat;
    if (total == 0) total = 1; // Prevent division by zero visually

    const radius = 18.0;
    return [
      PieChartSectionData(
        color: const Color(0xFF60A5FA), // Blue for Carbs
        value: currentCarbs,
        title: '',
        radius: radius,
      ),
      PieChartSectionData(
        color: const Color(0xFFFB923C), // Orange for Fat
        value: currentFat,
        title: '',
        radius: radius,
      ),
      PieChartSectionData(
        color: const Color(0xFF4ADE80), // Green for Protein
        value: currentProtein,
        title: '',
        radius: radius,
      ),
    ];
  }

  Widget _indicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableMacro(String label, TextEditingController controller) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.secondary,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

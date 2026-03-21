import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants.dart';

class MealDetailScreen extends StatelessWidget {
  final Map<String, dynamic> mealData;

  const MealDetailScreen({super.key, required this.mealData});

  // Modern, vibrant colors for the macros
  static const Color proteinColor = Color(0xFFFF4757); // Vibrant Coral Red
  static const Color carbsColor = Color(0xFF5352ED);   // Vibrant Indigo Blue
  static const Color fatColor = Color(0xFFFFA502);     // Vibrant Golden Orange

  @override
  Widget build(BuildContext context) {
    // Safely extract data with fallbacks
    String imageUrl = mealData["mealImageUrl"] ?? mealData["imageUrl"] ?? "";
    String recipeName = mealData["recipeName"] ?? mealData["name"] ?? "Unknown Meal";
    String mealType = (mealData["mealType"] ?? mealData["type"] ?? "MEAL").toString().toUpperCase();
    String prepTime = mealData["prepTimeMin"] != null ? "${mealData["prepTimeMin"]} min" : "15 min";

    double currentKcal = (mealData["calories"] ?? mealData["kcal"] ?? 480).toDouble();
    double currentProtein = (mealData["proteinG"] ?? mealData["protein"] ?? 15).toDouble();
    double currentCarbs = (mealData["carbsG"] ?? mealData["carbs"] ?? 60).toDouble();
    double currentFat = (mealData["fatG"] ?? mealData["fat"] ?? 20).toDouble();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Top Image Header (Takes up 45% of the screen)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                imageUrl.isNotEmpty && imageUrl.startsWith('http')
                    ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                )
                    : _buildPlaceholder(),

                // Decorative Gradient Overlay for better contrast
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                        Colors.black.withOpacity(0.2),
                      ],
                      stops: const [0.0, 0.3, 1.0],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Back Button Overlay
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.95),
              radius: 22,
              child: IconButton(
                padding: const EdgeInsets.only(left: 6), // Center the iOS icon properly
                icon: const Icon(Icons.arrow_back_ios, color: AppColors.textMain, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // 2. Bottom Content Container (Compact, Modern, and Non-Scrolling)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 24,
                    offset: const Offset(0, -8),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Decorative Drag Handle
                    Center(
                      child: Container(
                        width: 48,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Meal Name (Up to 3 lines)
                    Text(
                      recipeName,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textMain,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 13),

                    // Meal Type Chip (Under the name)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        mealType,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Prep Time and Calories (Same Horizontal Plane)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Prep Time Chip (Kept as is)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.schedule_rounded, color: AppColors.textSub, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "Prep: $prepTime",
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textSub),
                              ),
                            ],
                          ),
                        ),

                        // Calories (Just Red Icon and Text)
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department_rounded, color: AppColors.primary, size: 24),
                            const SizedBox(width: 6),
                            Text(
                              "${currentKcal.toStringAsFixed(0)} kcal",
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const Spacer(), // First spacer pushes card down slightly

                    // Unified Nutritional Breakdown Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA), // Light shade of grey
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nutritional Breakdown",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textMain),
                          ),
                          const SizedBox(height: 20),

                          // Chart and Macros Dashboard Row
                          Row(
                            children: [
                              // Left side: Big, Thick Pie Chart
                              SizedBox(
                                height: 140,
                                width: 140,
                                child: Stack(
                                  children: [
                                    PieChart(
                                      PieChartData(
                                        sectionsSpace: 6,
                                        centerSpaceRadius: 40,
                                        startDegreeOffset: 270,
                                        sections: _getChartSections(currentProtein, currentCarbs, currentFat),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
                                            ]
                                        ),
                                        child: const Icon(Icons.restaurant_menu_rounded, color: Colors.grey, size: 26),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),

                              // Right side: Compact Macro Keys
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildCompactMacroIndicator("Protein", currentProtein, proteinColor),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1),
                                    ),
                                    _buildCompactMacroIndicator("Carbs", currentCarbs, carbsColor),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1),
                                    ),
                                    _buildCompactMacroIndicator("Fat", currentFat, fatColor),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Spacer(), // Second spacer perfectly centers the card in remaining space
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF3F4F6),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood_rounded, size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text("No Image Available", style: TextStyle(color: Colors.grey.shade400, fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  // Tighter, more compact macro indicator specifically designed to fit within the new grey card
  Widget _buildCompactMacroIndicator(String label, double amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSub),
            ),
          ],
        ),
        Text(
          "${amount.toStringAsFixed(0)}g",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textMain),
        ),
      ],
    );
  }

  List<PieChartSectionData> _getChartSections(double protein, double carbs, double fat) {
    double total = protein + carbs + fat;
    if (total == 0) total = 1; // Prevent division by zero

    const double thickness = 22.0; // Thick rings

    return [
      PieChartSectionData(
        color: proteinColor,
        value: protein,
        title: '',
        radius: thickness,
        showTitle: false,
      ),
      PieChartSectionData(
        color: carbsColor,
        value: carbs,
        title: '',
        radius: thickness,
        showTitle: false,
      ),
      PieChartSectionData(
        color: fatColor,
        value: fat,
        title: '',
        radius: thickness,
        showTitle: false,
      ),
    ];
  }
}
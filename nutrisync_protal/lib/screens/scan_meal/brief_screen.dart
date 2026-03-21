import 'dart:io';
import 'package:NutriSync/services/meal_service.dart';
import 'package:flutter/material.dart';
import 'package:NutriSync/screens/scan_meal/add_meal_screen.dart';
import 'package:NutriSync/widgets/common_widgets.dart';
import '../../core/constants.dart';

class BriefScreen extends StatefulWidget {
  final File imageFile;

  const BriefScreen({super.key, required this.imageFile});

  @override
  State<BriefScreen> createState() => _BriefScreenState();
}

class _BriefScreenState extends State<BriefScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _mealData;

  @override
  void initState() {
    super.initState();
    _identifyMeal();
  }

  Future<void> _identifyMeal() async {
    try {
      final ApiResponse response = await MealService.identifyMeal(widget.imageFile);

      if (mounted) {
        if (response.success) {
          setState(() {
            _mealData = response.data;
            _isLoading = false;
          });

          showModernToast(context, response.message, type: 'success');
        } else {
          setState(() => _isLoading = false);
          showModernToast(context, response.message.isNotEmpty ? response.message : "Failed to identify meal.", type: 'error');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        showModernToast(context, "An error occurred.", type: 'error');
      }
      Logger.error("API Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Brief",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.redAccent),
            SizedBox(height: 16),
            Text("Analyzing Meal...", style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      )
          : _mealData == null
          ? _buildIdentifyFailedView()
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFoodHeader(),
            const SizedBox(height: 25),

            const Text(
              "Nutrition",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            _buildNutrientGrid(),
            const SizedBox(height: 20),

            const Text(
              "Micro-Nutrients (mg/g)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            _buildMicroGrid(),
            const SizedBox(height: 10),

            PrimaryButton(
              text: "Add New Meal",
              isRed: true,
              onTap: () {
                // Helper to extract only numbers/decimals from the API response
                String parseVal(String? val) {
                  return val?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '';
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMealScreen(
                      isManual: false,
                      imageFile: widget.imageFile,
                      foodId: _mealData?['foodId'] as int?,
                      calories: parseVal(_mealData?['caloriesInKcal']),
                      protein: parseVal(_mealData?['proteinInG']),
                      carbs: parseVal(_mealData?['carbohydratesInG']),
                      fats: parseVal(_mealData?['totalFatsInG']),
                      mealName: _mealData?['name'],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ==== NEW FALLBACK WIDGET ====
  Widget _buildIdentifyFailedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: FileImage(widget.imageFile),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                ),
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 24),
            const Text(
              "Identification Failed",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "We couldn't recognize the exact nutritional details of this meal. You can still add it manually!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              text: "Add Meal Manually",
              isRed: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMealScreen(
                      isManual: true,
                      imageFile: widget.imageFile,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodHeader() {
    String mealName = _mealData?["name"] ?? "Unknown Food";
    if (mealName.isNotEmpty) {
      mealName = mealName[0].toUpperCase() + mealName.substring(1);
    }

    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: FileImage(widget.imageFile),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mealName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutrientGrid() {
    final items = [
      {"label": "Calories", "val": "${_mealData?['caloriesInKcal'] ?? '0'} Kcal", "icon": Icons.local_fire_department, "color": Colors.orange},
      {"label": "Proteins", "val": _mealData?['proteinInG'] ?? '0 g', "icon": Icons.bakery_dining, "color": Colors.red},
      {"label": "Carbs", "val": _mealData?['carbohydratesInG'] ?? '0 g', "icon": Icons.grain, "color": Colors.brown},
      {"label": "Fiber", "val": _mealData?['fiberInG'] ?? '0 g', "icon": Icons.eco, "color": Colors.green},
      {"label": "Fats", "val": _mealData?['totalFatsInG'] ?? '0 g', "icon": Icons.water_drop, "color": Colors.orangeAccent},
      {"label": "Water", "val": _mealData?['waterInG'] ?? '0 g', "icon": Icons.opacity, "color": Colors.blue},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.2,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _NutrientTile(
        title: items[index]['label'] as String,
        value: items[index]['val'] as String,
        icon: items[index]['icon'] as IconData,
        color: items[index]['color'] as Color,
      ),
    );
  }

  Widget _buildMicroGrid() {
    final microItems = [
      {"title": "Calcium", "val": _mealData?['calciumInMg'] ?? '0 mg', "label": "Ca", "color": Colors.orange},
      {"title": "Sugar", "val": _mealData?['sugarsInG'] ?? '0 g', "label": "S", "color": Colors.purple},
      {"title": "Glucose", "val": _mealData?['glucoseInG'] ?? '0 g', "label": "G", "color": Colors.green},
      {"title": "Lactose", "val": _mealData?['lactoseInG'] ?? '0 g', "label": "L", "color": Colors.blueAccent},
      {"title": "Sodium", "val": _mealData?['sodiumInMg'] ?? '0 mg', "label": "Na", "color": Colors.brown},
      {"title": "Cholesterol", "val": _mealData?['cholesterolInMg'] ?? '0 mg', "label": "C", "color": Colors.redAccent},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.2,
      ),
      itemCount: microItems.length,
      itemBuilder: (context, index) => _NutrientTile(
        title: microItems[index]['title'] as String,
        value: microItems[index]['val'] as String,
        color: microItems[index]['color'] as Color,
        isMicro: true,
        microLabel: microItems[index]['label'] as String,
      ),
    );
  }
}

class _NutrientTile extends StatelessWidget {
  final String title, value;
  final IconData? icon;
  final Color color;
  final bool isMicro;
  final String? microLabel;

  const _NutrientTile({
    required this.title, required this.value, this.icon, required this.color, this.isMicro = false, this.microLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          isMicro
              ? CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            radius: 18,
            child: Text(microLabel!, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          )
              : Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(value, style: const TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
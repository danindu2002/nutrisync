import 'package:NutriSync/screens/add_meal_screen.dart';
import 'package:NutriSync/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

class BriefScreen extends StatelessWidget {
  const BriefScreen({super.key});

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
      body: SingleChildScrollView(
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
              "Micro-Nutrients (mg)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            _buildMicroGrid(),
            const SizedBox(height: 20),

            PrimaryButton(
              text: "Add New Meal",
              isRed: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddMealScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodHeader() {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: const DecorationImage(
              image: AssetImage("assets/images/dashboard/salad_eggs.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Apple",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text("Fruit", style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildNutrientGrid() {
    final items = [
      {
        "label": "Calories",
        "val": "99.5 Kcal",
        "icon": Icons.local_fire_department,
        "color": Colors.orange,
      },
      {
        "label": "Proteins",
        "val": "99.5 g",
        "icon": Icons.bakery_dining,
        "color": Colors.red,
      },
      {
        "label": "Carbs",
        "val": "99.5 g",
        "icon": Icons.grain,
        "color": Colors.brown,
      },
      {
        "label": "Fiber",
        "val": "99.5 g",
        "icon": Icons.eco,
        "color": Colors.green,
      },
      {
        "label": "Fats",
        "val": "99.5 g",
        "icon": Icons.water_drop,
        "color": Colors.orangeAccent,
      },
      {
        "label": "Water",
        "val": "99.5 ml",
        "icon": Icons.opacity,
        "color": Colors.blue,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
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
      {
        "title": "Vitamin C",
        "val": "99.5 mg",
        "label": "C",
        "color": Colors.orange,
      },
      {
        "title": "Vitamin B6",
        "val": "99.5 mg",
        "label": "B6",
        "color": Colors.purple,
      },
      {
        "title": "Vitamin A",
        "val": "99.5 mg",
        "label": "A",
        "color": Colors.redAccent,
      },
      {
        "title": "Vitamin E",
        "val": "99.5 mg",
        "label": "E",
        "color": Colors.green,
      },
      {
        "title": "Calcium",
        "val": "99.5 mg",
        "label": "Ca",
        "color": Colors.blueAccent,
      },
      {"title": "Iron", "val": "99.5 mg", "label": "Fe", "color": Colors.brown},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
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
    required this.title,
    required this.value,
    this.icon,
    required this.color,
    this.isMicro = false,
    this.microLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          isMicro
              ? CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  radius: 18,
                  child: Text(
                    microLabel!,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
              : Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Expanded(
            // Added Expanded to handle long text within the tile
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

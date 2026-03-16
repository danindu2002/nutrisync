import 'package:flutter/material.dart';
import '../core/constants.dart';

class MealPlanPreviewScreen extends StatefulWidget {
  const MealPlanPreviewScreen({super.key});

  @override
  State<MealPlanPreviewScreen> createState() => _MealPlanPreviewScreenState();
}

class _MealPlanPreviewScreenState extends State<MealPlanPreviewScreen> {
  final TextEditingController _nameController = TextEditingController();

  // Dummy Data for Preview
  final List<Map<String, dynamic>> mealGroups = [
    {
      "date": "Tomorrow, Mar 7",
      "meals": [
        {
          "type": "BREAKFAST",
          "name": "Herb Egg Muffin",
          "imageUrl":
              "https://images.unsplash.com/photo-1614704812328-98f98ae06aeb?q=80&w=250&auto=format&fit=crop",
        },
        {
          "type": "LUNCH",
          "name": "Keto Nut Bar",
          "imageUrl":
              "https://images.unsplash.com/photo-1603569283847-aa295f0d016a?q=80&w=250&auto=format&fit=crop",
        },
        {
          "type": "DINNER",
          "name": "Quick Oven-Baked Pork Chops",
          "imageUrl":
              "https://images.unsplash.com/photo-1628198759312-32a58b5fa21e?q=80&w=250&auto=format&fit=crop",
        },
      ],
    },
    {
      "date": "Sunday, Mar 8",
      "meals": [
        {
          "type": "BREAKFAST",
          "name": "Keto Nut Bar",
          "imageUrl":
              "https://images.unsplash.com/photo-1603569283847-aa295f0d016a?q=80&w=250&auto=format&fit=crop",
        },
        {
          "type": "LUNCH",
          "name": "Keto Nut Bar",
          "imageUrl":
              "https://images.unsplash.com/photo-1603569283847-aa295f0d016a?q=80&w=250&auto=format&fit=crop",
        },
        {
          "type": "DINNER",
          "name": "Quick Oven-Baked Pork Chops",
          "imageUrl":
              "https://images.unsplash.com/photo-1628198759312-32a58b5fa21e?q=80&w=250&auto=format&fit=crop",
        },
      ],
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                children: [
                  _buildSubtitle(),
                  const SizedBox(height: 24),
                  _buildNameInput(),
                  const SizedBox(height: 32),
                  ...mealGroups.map((group) => _buildMealGroup(group)),
                ],
              ),
            ),
            _buildBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: AppColors.secondary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          const Text(
            "Meal Plan Preview",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      "Here are the meals selected for your plan. You can swap any meal if you prefer something else.",
      style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.4),
    );
  }

  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Meal Plan Name",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: "Enter meal plan name",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealGroup(Map<String, dynamic> group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group["date"],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(
          (group["meals"] as List).length,
          (index) => _buildMealCard(group["meals"][index]),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    Color badgeColor;
    Color badgeTextColor;

    switch (meal["type"]) {
      case "BREAKFAST":
        badgeColor = const Color(0xFFFEF3C7);
        badgeTextColor = const Color(0xFFD97706);
        break;
      case "LUNCH":
        badgeColor = const Color(0xFFFFEDD5);
        badgeTextColor = const Color(0xFFC2410C);
        break;
      case "DINNER":
        badgeColor = const Color(0xFFDBEAFE);
        badgeTextColor = const Color(0xFF1D4ED8);
        break;
      default:
        badgeColor = Colors.grey.shade200;
        badgeTextColor = Colors.grey.shade700;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // Meal Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              meal["imageUrl"],
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 70,
                height: 70,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Meal Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    meal["type"],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: badgeTextColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  meal["name"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          // Swap Button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.sync, color: Color(0xFF10B981)),
              onPressed: () {
                // Handle swap action
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SizedBox(
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
          onPressed: () {
            // Handle save meal plan
          },
          child: const Text(
            "Save Meal Plan",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

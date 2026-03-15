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
                ],
              ),
            ),
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
}

import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/common_widgets.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  bool isManual = true;
  String selectedMealType = "Breakfast";
  double protein = 40;
  double carbs = 75;
  double calories = 55;
  bool suggestRecommendations = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Meal Name"),
                  const SizedBox(height: 12),
                  _buildTextField(
                    "Enter your meal name",
                    Icons.restaurant_menu,
                  ),
                  const SizedBox(height: 24),
                  _buildLabel("Meal Type"),
                  const SizedBox(height: 12),
                  _buildMealTypeSelector(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1F2937), // Dark grey background like in image
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    "Add New Meal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 40), // Balance the back button
            ],
          ),
          const SizedBox(height: 24),
          _buildToggleSwitch(),
        ],
      ),
    );
  }

  Widget _buildToggleSwitch() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isManual = true),
              child: Container(
                decoration: BoxDecoration(
                  color: isManual ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Manual",
                  style: TextStyle(
                    color: isManual ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isManual = false),
              child: Container(
                decoration: BoxDecoration(
                  color: !isManual ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  "AI Scan",
                  style: TextStyle(
                    color: !isManual ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildTextField(String hint, IconData? icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildMealTypeSelector() {
    final types = ["Breakfast", "Launch", "Snack"];
    return Row(
      children: types.map((type) {
        final isSelected = selectedMealType == type;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => setState(() => selectedMealType = type),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? Border.all(color: Colors.black, width: 2)
                    : null,
              ),
              child: Row(
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isSelected
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    size: 16,
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavIcon(icon: Icons.home, isActive: currentIndex == 0),
              _NavIcon(icon: Icons.show_chart, isActive: currentIndex == 1),

              /// Center Add Button
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),

              _NavIcon(icon: Icons.receipt_long, isActive: currentIndex == 3),
              _NavIcon(icon: Icons.person, isActive: currentIndex == 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;

  const _NavIcon({required this.icon, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 28,
      color: isActive ? const Color(0xFF1F2937) : Colors.grey.shade400,
    );
  }
}

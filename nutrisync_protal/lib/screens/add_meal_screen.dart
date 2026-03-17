import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/log_meal_dto.dart';
import '../services/meal_service.dart';
import '../widgets/common_widgets.dart';

class AddMealScreen extends StatefulWidget {
  final bool isManual;
  final File? imageFile;
  final int? foodId;
  final String? calories;
  final String? protein;
  final String? carbs;
  final String? fats;
  final String? mealName;

  const AddMealScreen({
    super.key,
    this.isManual = true,
    this.imageFile,
    this.foodId,
    this.calories,
    this.protein,
    this.carbs,
    this.fats,
    this.mealName,
  });

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  String selectedMealType = "Breakfast";
  bool suggestRecommendations = false;
  File? _currentImage;

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _currentImage = widget.imageFile;

    // Pre-fill data if coming from BriefScreen
    if (!widget.isManual) {
      _nameController.text = _capitalize(widget.mealName ?? "");
      _caloriesController.text = widget.calories ?? "";
      _proteinController.text = widget.protein ?? "";
      _carbsController.text = widget.carbs ?? "";
      _fatsController.text = widget.fats ?? "";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _currentImage = File(image.path);
      });
    }
  }

  Future<void> _submitMeal() async {
    FocusScope.of(context).unfocus();

    // Validate required fields
    if (_nameController.text.trim().isEmpty ||
        _weightController.text.trim().isEmpty ||
        _caloriesController.text.trim().isEmpty ||
        _proteinController.text.trim().isEmpty ||
        _carbsController.text.trim().isEmpty ||
        _fatsController.text.trim().isEmpty) {
      showModernToast(context, "Please fill in all required fields", type: 'error');
      return;
    }

    if (_currentImage == null) {
      showModernToast(context, "Please provide a meal image", type: 'error');
      return;
    }

    try {
      LoadingIndicator.show(context);

      // Get User ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt("userId");

      if (userId == null) {
        if (mounted) LoadingIndicator.hide(context);
        showModernToast(context, "User session invalid. Please log in again.", type: 'error');
        return;
      }

      // Prepare JSON data payload
      final logMealDTO = LogMealDTO(
        userId: userId,
        foodId: widget.foodId,
        weight: double.tryParse(_weightController.text.trim()) ?? 0.0,
        mealTime: selectedMealType.toUpperCase(),
        notes: _notesController.text.trim(),
        suggestRecommendations: suggestRecommendations,
        name: _nameController.text.trim(),
        totalProtein: double.tryParse(_proteinController.text.trim()) ?? 0.0,
        totalCarbs: double.tryParse(_carbsController.text.trim()) ?? 0.0,
        totalFats: double.tryParse(_fatsController.text.trim()) ?? 0.0,
        totalCalories: double.tryParse(_caloriesController.text.trim()) ?? 0.0,
      );
      final ApiResponse response = await MealService.logMeal(_currentImage!, logMealDTO.toJson());

      if (mounted) LoadingIndicator.hide(context);

      if (response.success) {
        showModernToast(context, "Meal added successfully!", type: 'success');
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        showModernToast(context, response.message.isNotEmpty ? response.message : "Failed to add meal", type: 'error');
      }
    } catch (e) {
      if (mounted) LoadingIndicator.hide(context);
      Logger.error("Log Meal Error: $e");
      showModernToast(context, "An unexpected error occurred", type: 'error');
    }
  }

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
                  _buildLabel("Meal Name *"),
                  const SizedBox(height: 12),
                  _buildTextField("Enter your meal name", Icons.restaurant_menu, _nameController),
                  const SizedBox(height: 24),

                  _buildLabel("Meal Type *"),
                  const SizedBox(height: 12),
                  _buildMealTypeSelector(),
                  const SizedBox(height: 24),

                  _buildLabel("Weight (g) *"),
                  const SizedBox(height: 12),
                  _buildTextField("Enter meal weight", Icons.scale, _weightController, isNumber: true),
                  const SizedBox(height: 24),

                  _buildLabel("Calories (Kcal) *"),
                  const SizedBox(height: 12),
                  _buildTextField("Enter calories amount", Icons.local_fire_department, _caloriesController, isNumber: true),
                  const SizedBox(height: 24),

                  _buildLabel("Protein (g) *"),
                  const SizedBox(height: 12),
                  _buildTextField("Enter protein amount", Icons.fitness_center, _proteinController, isNumber: true),
                  const SizedBox(height: 24),

                  _buildLabel("Carbohydrates (g) *"),
                  const SizedBox(height: 12),
                  _buildTextField("Enter carbohydrates amount", Icons.bakery_dining, _carbsController, isNumber: true),
                  const SizedBox(height: 24),

                  _buildLabel("Fats (g) *"),
                  const SizedBox(height: 12),
                  _buildTextField("Enter fats amount", Icons.emoji_food_beverage, _fatsController, isNumber: true),
                  const SizedBox(height: 24),

                  _buildLabel("Meal Thumbnail *"),
                  const SizedBox(height: 12),
                  _buildImagePickerPlaceholder(),
                  const SizedBox(height: 24),

                  _buildLabel("Additional Notes"),
                  const SizedBox(height: 12),
                  _buildTextField("Any extra details about the meal", null, _notesController),
                  const SizedBox(height: 24),

                  _buildSwitch(),
                  const SizedBox(height: 32),

                  PrimaryButton(
                      onTap: _submitMeal,
                      text: "Continue",
                      isRed: true
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1F2937),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Add New Meal",
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  Widget _buildTextField(String hint, IconData? icon, TextEditingController controller, {bool isNumber = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildMealTypeSelector() {
    final types = ["Breakfast", "Lunch", "Dinner"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.map((type) {
          final isSelected = selectedMealType == type;
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () => setState(() => selectedMealType = type),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.red : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildImagePickerPlaceholder() {
    return GestureDetector(
      onTap: widget.isManual ? _pickImage : null, // Only allow picking if manual
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary, width: 2),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          image: _currentImage != null
              ? DecorationImage(
            image: FileImage(_currentImage!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: _currentImage == null
            ? Center(child: Icon(Icons.add, color: AppColors.primary, size: 40))
            : null,
      ),
    );
  }

  Widget _buildSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Suggest Recommendations",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Switch(
          value: suggestRecommendations,
          activeColor: AppColors.primary,
          onChanged: (v) => setState(() => suggestRecommendations = v),
        ),
      ],
    );
  }
}
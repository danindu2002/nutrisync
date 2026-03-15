import 'dart:convert';
import 'package:NutriSync/screens/scan_meal_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../services/meal_service.dart';
import '../widgets/common_widgets.dart';

class MealLogScreen extends StatefulWidget {
  const MealLogScreen({super.key});

  @override
  State<MealLogScreen> createState() => _MealLogScreenState();
}

class _MealLogScreenState extends State<MealLogScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedMealType = "Breakfast";

  bool _isLoading = false;
  List<Map<String, dynamic>> _allMeals = [];

  final ScrollController _scrollController = ScrollController();
  static const double _dayItemWidth = 76; // width + margin

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();

    // Scroll to the current day and fetch meals
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
      _fetchMealLogs();
    });
  }

  void _scrollToSelectedDay() {
    final position = (selectedDate.day - 1) * _dayItemWidth;
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _fetchMealLogs() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId");

      if (userId == null) {
        setState(() => _isLoading = false);
        return;
      }

      // Format date to YYYY-MM-DD
      final String dateStr =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

      final ApiResponse response = await MealService.getMealLogs(
        userId,
        dateStr,
      );

      if (mounted) {
        if (response.success) {
          setState(() {
            _allMeals = List<Map<String, dynamic>>.from(response.data ?? []);
          });
          if (mounted) {
            setState(() => _isLoading = false);
          }
        } else {
          setState(() => _allMeals = []);
          showModernToast(
            context,
            response.message.isNotEmpty
                ? response.message
                : "Failed to load meals",
            type: 'error',
          );
          if (mounted) {
            setState(() => _isLoading = false);
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching meals: $e");
      setState(() => _allMeals = []);
    }
  }

  // Filter meals based on the selected tab
  List<Map<String, dynamic>> get _filteredMeals {
    return _allMeals.where((meal) {
      final mealTime = (meal['mealTime'] ?? '').toString().toUpperCase();
      return mealTime == selectedMealType.toUpperCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayedMeals = _filteredMeals;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMealTypeSelector(),
                  const SizedBox(height: 25),

                  // Display Loading, Empty State, or Meal Cards
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.redAccent,
                        ),
                      ),
                    )
                  else if (displayedMeals.isEmpty)
                    _buildNoMealsView()
                  else
                    ...displayedMeals.map((meal) {
                      return MealCard(
                        logId: meal['logId'],
                        title: meal['foodName']?.toString() ?? "",
                        calories: "${meal['totalCalories'] ?? 0} kcal",
                        protein: "${meal['totalProtein'] ?? 0}g",
                        carbs: "${meal['totalCarbs'] ?? 0}g",
                        fats: "${meal['totalFats'] ?? 0}g",
                        base64Image: meal['image'],
                        onDeleteSuccess: () {
                          _fetchMealLogs();
                        },
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMealsView() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_meals_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              "No meals logged for ${selectedMealType.toLowerCase()}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(
      selectedDate.year,
      selectedDate.month,
    );

    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 30),
      decoration: const BoxDecoration(color: Color(0xFF1E2026)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  "Meal Log",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => const ScanMealScreen(),
                      ),
                    ), // Navigate to AddMealScreen here if needed
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );

              if (picked != null) {
                setState(() => selectedDate = picked);
                _scrollToSelectedDay();
                _fetchMealLogs(); // Fetch new data on date change
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white54),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_month, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    "${_monthName(selectedDate.month)} ${selectedDate.year}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 80,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              itemCount: daysInMonth,
              itemBuilder: (context, index) {
                int day = index + 1;
                bool isSelected = selectedDate.day == day;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        day,
                      );
                    });
                    _scrollToSelectedDay();
                    _fetchMealLogs(); // Fetch new data on day tap
                  },
                  child: Container(
                    width: 64,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFF2C2F38),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _weekDayName(
                            selectedDate.year,
                            selectedDate.month,
                            day,
                          ),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$day",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeSelector() {
    final types = ["Breakfast", "Lunch", "Dinner"];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: types.map((type) {
          bool isSelected = selectedMealType == type;

          return Expanded(
            child: GestureDetector(
              onTap: () => setState(
                () => selectedMealType = type,
              ), // Tab change instantly filters UI
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  String _weekDayName(int year, int month, int day) {
    final date = DateTime(year, month, day);
    const weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return weekDays[date.weekday - 1];
  }
}

class MealCard extends StatelessWidget {
  final int logId; // ADDED: ID for the API
  final String title, calories, protein, carbs, fats;
  final String? base64Image;
  final VoidCallback
  onDeleteSuccess; // ADDED: To tell the parent screen to refresh

  const MealCard({
    super.key,
    required this.logId,
    required this.title,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.base64Image,
    required this.onDeleteSuccess,
  });

  ImageProvider _getImageProvider() {
    if (base64Image != null && base64Image!.isNotEmpty) {
      try {
        final cleanBase64 = base64Image!.contains(',')
            ? base64Image!.split(',').last
            : base64Image!;

        final decodedBytes = base64Decode(
          cleanBase64.replaceAll(RegExp(r'\s+'), ''),
        );
        return MemoryImage(decodedBytes);
      } catch (e) {
        debugPrint("Error decoding base64 image: $e");
      }
    }
    return const AssetImage('assets/images/placeholder.png');
  }

  // ==== NEW: Delete Confirmation Dialog & API Call ====
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Delete Meal"),
          content: const Text("Are you sure you want to delete this meal log?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), // Cancel
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog
                _deleteMeal(context); // Call delete method
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteMeal(BuildContext context) async {
    LoadingIndicator.show(context); // Show loading overlay

    final response = await MealService.deleteMealLog(logId);

    if (context.mounted) LoadingIndicator.hide(context); // Hide loading overlay

    if (context.mounted) {
      if (response.success) {
        // Assuming ApiResponse has a .success getter
        showModernToast(context, "Meal deleted successfully", type: 'success');
        onDeleteSuccess(); // Trigger parent UI refresh
      } else {
        showModernToast(
          context,
          response.message.isNotEmpty
              ? response.message
              : "Failed to delete meal",
          type: 'error',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double parseVal(String val) {
      final rawNum = val.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(rawNum) ?? 0.0;
    }

    final double pVal = parseVal(protein);
    final double cVal = parseVal(carbs);
    final double fVal = parseVal(fats);

    // 2. Find the highest value and multiply by 2
    double highestValue = [pVal, cVal, fVal].reduce((a, b) => a > b ? a : b);
    double maxValue = highestValue > 0 ? highestValue * 2 : 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 160,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(image: _getImageProvider(), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black54, Colors.black87],
              ),
            ),
          ),
          Positioned(
            top: 15,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: AppColors.primary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      calories,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ==== Delete Button ====
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
              ),
              onPressed: () => _showDeleteDialog(context),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _macroInfo(
                  protein,
                  pVal,
                  "Protein",
                  Colors.redAccent,
                  maxValue,
                ),
                _macroInfo(carbs, cVal, "Carbs", Colors.orange, maxValue),
                _macroInfo(fats, fVal, "Fats", Colors.blueAccent, maxValue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroInfo(
    String displayValue,
    double amount,
    String label,
    Color color,
    double maxValue,
  ) {
    double progress = maxValue > 0 ? (amount / maxValue) : 0.0;
    progress = progress.clamp(0.0, 1.0);

    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                value: progress, // Dynamic relative progress!
                strokeWidth: 3,
                color: color,
                backgroundColor: Colors.white24,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayValue,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}

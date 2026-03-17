import 'package:flutter/material.dart';
import '../core/constants.dart';

class MealLogScreen extends StatefulWidget {
  const MealLogScreen({super.key});

  @override
  State<MealLogScreen> createState() => _MealLogScreenState();
}

class _MealLogScreenState extends State<MealLogScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedMealType = "Breakfast";

  final ScrollController _scrollController = ScrollController();
  static const double _dayItemWidth = 76; // width + margin

  @override
  void initState() {
    super.initState();

    // ✅ Initialize with TODAY
    selectedDate = DateTime.now();

    // Wait until UI builds, then scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay();
    });
  }

  void _scrollToSelectedDay() {
    final position = (selectedDate.day - 1) * _dayItemWidth;

    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "My Meals",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Sort ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Icon(Icons.tune, size: 18, color: AppColors.primary),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  const MealCard(
                    title: "Fried Chicken",
                    calories: "250kcal",
                    protein: "20g",
                    carbs: "17g",
                    fats: "5g",
                    imagePath: "assets/images/chicken.jpg",
                  ),
                  const MealCard(
                    title: "Pasta",
                    calories: "250kcal",
                    protein: "36g",
                    carbs: "10g",
                    fats: "9g",
                    imagePath: "assets/images/pasta.jpg",
                  ),
                  const MealCard(
                    title: "Salmon",
                    calories: "185kcal",
                    protein: "25g",
                    carbs: "0g",
                    fats: "12g",
                    imagePath: "assets/images/salmon.jpg",
                  ),
                ],
              ),
            ),
          ),
        ],
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
          /// Top Bar
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
                  onPressed: () {},
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
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 📅 Date Picker Button
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );

              if (picked != null) {
                setState(() {
                  selectedDate = picked;
                });
                // Scroll after rebuild
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToSelectedDay();
                });
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

          /// 📆 Days Row (Scrollable)
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
                  },
                  child: Container(
                    width: 64,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(vertical: 14),
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

  /// ================= MEAL TYPE SELECTOR =================
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
              onTap: () => setState(() => selectedMealType = type),
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

  /// ================= HELPERS =================
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
  final String title, calories, protein, carbs, fats, imagePath;

  const MealCard({
    super.key,
    required this.title,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
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
          const Positioned(
            top: 15,
            right: 10,
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
          Positioned(
            bottom: 15,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _macroInfo(protein, "Protein", Colors.redAccent),
                _macroInfo(carbs, "Carbs", Colors.orange),
                _macroInfo(fats, "Fats", Colors.redAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroInfo(String value, String label, Color color) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                value: 0.7,
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
              value,
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

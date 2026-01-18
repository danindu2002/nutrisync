import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../models/onboarding_dto.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';
import 'package:flutter/services.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final OnboardingDTO _data = OnboardingDTO();

  int _currentPage = 0;
  final int _totalSteps = 15;
  bool _showWelcome = true;
  bool _isKcal = true;
  bool _isKg = true;
  bool _isCm = true;

  final Map<String, TimeOfDay?> _mealTimes = {
    "Breakfast": null,
    "Lunch": null,
    "Dinner": null,
  };

  void _hapticLight() {
    HapticFeedback.lightImpact();
  }

  void _nextPage() {
    _hapticLight();

    if (_showWelcome) {
      setState(() {
        _showWelcome = false;
      });
      return;
    }

    if (_currentPage < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitData();
    }
  }

  void _prevPage() {
    _hapticLight();

    if (_currentPage == 0) {
      setState(() {
        _showWelcome = true;
      });
      return;
    }

    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitData() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    bool success = await ApiService.submitOnboardingData(_data);
    Navigator.pop(context);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile Created!")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to save data.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _showWelcome
          ? _buildWelcomeScreen()
          : Column(
              children: [
                // Header Logic
                SafeArea(
                  bottom: false,
                  child: OnboardingHeader(
                    title: _getTitleForStep(_currentPage),
                    currentStep: _currentPage + 1,
                    totalSteps: _totalSteps,
                    onBack: _prevPage,
                  ),
                ),

                // Progress bar
                _buildProgressBar(),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      _buildFitnessGoalScreen(),
                      _buildGoalReasonScreen(),
                      _buildGenderScreen(),
                      _buildAgeScreen(),
                      _buildHeightScreen(),
                      _buildWeightScreen(),
                      _buildActivityScreen(),
                      _buildSpeedScreen(),
                      _buildDietScreen(),
                      _buildAllergiesScreen(),
                      _buildMealTimeScreen(),
                      _buildMedicalConditionScreen(),
                      _buildCalorieGoalScreen(),
                      _buildSleepQualityScreen(),
                      Container(
                        color: Colors.white,
                        child: const Center(child: Text("Ready to Sync?")),
                      ),
                    ],
                  ),
                ),

                // Bottom Button Logic
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                    child: PrimaryButton(
                      onTap: _nextPage,
                      text: _currentPage == _totalSteps - 1
                          ? "Finish"
                          : "Continue",
                      isRed: false,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _getTitleForStep(int index) {
    const titles = [
      "What's your Fitness Goal?",
      "Why do you need to fulfil that Goal?",
      "What's your Gender?",
      "What's your Age?",
      "What's your Height?",
      "What's your Weight?",
      "What's your Physical Activity Level?",
      "How quickly do you wish to achieve the Goal?",
      "What's your Dietary Preference?",
      "Do you have any Allergic Foods?",
      "What are your Meal Times?",
      "Do you have any Medical Conditions?",
      "What's your Calorie Goal per day?",
      "What's your Sleep Quality like?",
    ];
    if (index < titles.length) return titles[index];
    return "Assessment";
  }

  // --- Screen 0: Welcome ---
  Widget _buildWelcomeScreen() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/welcome.jpg', fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 50, color: Colors.grey),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Welcome To\n",
                      style: AppTextStyles.welcomeText,
                    ),
                    TextSpan(text: "Nutri", style: AppTextStyles.welcomeText),
                    TextSpan(text: "Sync", style: AppTextStyles.welcomeTextRed),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Your personal fitness AI Assistant",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: PrimaryButton(onTap: _nextPage, text: "Let's Go", isRed: true),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  // --- Screen 1: Fitness Goal ---
  Widget _buildFitnessGoalScreen() {
    // Map of Option -> Icon
    final Map<String, IconData> goalOptions = {
      "Lose Weight & Burn Fat": Icons.local_fire_department_outlined,
      "Build Muscle & Strength": Icons.fitness_center,
      "Improve Overall Fitness": Icons.accessibility_new_rounded,
      "Boost Energy & Endurance": Icons.bolt_rounded,
      "Overcome Health Conditions": Icons.healing_rounded,
    };

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: goalOptions.entries.map((entry) {
        return OptionCard(
          title: entry.key,
          icon: entry.value,
          isSelected: _data.fitnessGoal == entry.key,
          onTap: () => setState(() => _data.fitnessGoal = entry.key),
        );
      }).toList(),
    );
  }

  // --- Screen 2: Motivation ---
  Widget _buildGoalReasonScreen() {
    // Map of Option -> Icon
    final Map<String, IconData> reasonOptions = {
      "Improve My Health": Icons.favorite_border_rounded,
      "Feel More Confident": Icons.sentiment_very_satisfied_rounded,
      "Increase Productivity": Icons.rocket_launch_outlined,
      "Manage a Medical Condition": Icons.monitor_heart_outlined,
      "Change Lifestyle": Icons.published_with_changes,
    };

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: reasonOptions.entries.map((entry) {
        return OptionCard(
          title: entry.key,
          icon: entry.value,
          isSelected: _data.goalMotivation == entry.key,
          onTap: () => setState(() => _data.goalMotivation = entry.key),
        );
      }).toList(),
    );
  }

  // --- Screen 3: Gender ---
  Widget _buildGenderScreen() {
    final List<Map<String, dynamic>> dietOptions = [
      {
        "title": "Male",
        "image": "assets/images/male.jpg",
        "icon": Icons.male_rounded,
      },
      {
        "title": "Female",
        "image": "assets/images/female.jpg",
        "icon": Icons.female_rounded,
      },
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: dietOptions.map((opt) {
        final title = opt["title"] as String;
        final image = opt["image"] as String;
        final icon = opt["icon"] as IconData;

        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
            height: 230,
            child: ImageOptionCard(
              title: title,
              imagePath: image,
              icon: icon,
              isSelected: _data.gender == title,
              onTap: () => setState(() => _data.gender = title),
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- Screen 4: Age ---
  Widget _buildAgeScreen() {
    int currentAge = _data.age ?? 20;
    int initialIndex = currentAge - 16;

    return SizedBox.expand(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: initialIndex),
        itemExtent: 160,
        diameterRatio: 1.8,

        onSelectedItemChanged: (idx) {
          _hapticLight();
          setState(() => _data.age = idx + 16);
        },
        selectionOverlay: Container(),
        children: List.generate(80, (index) {
          final val = index + 16;
          final isSelected = val == currentAge;

          return Center(
            child: isSelected
                ? Container(
              width: 300,
              height: 380,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "$val",
                  style: const TextStyle(
                    fontSize: 130,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.15,
                  ),
                ),
              ),
            )
                : Text(
              "$val",
              style: TextStyle(
                fontSize: 65,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
              ),
            ),
          );
        }),
      ),
    );
  }

// --- TODO : Screen 5: Height ---
  Widget _buildHeightScreen() {
    double currentCm = _data.heightCm ?? 170.0;

    // Bounds
    double minCm = 100.0;
    double maxCm = 250.0;

    double minVal = _isCm ? minCm : minCm / 2.54;
    double maxVal = _isCm ? maxCm : maxCm / 2.54;
    double displayVal = _isCm ? currentCm : (currentCm / 2.54);

    return Column(
      children: [
        const SizedBox(height: 10),

        UnitSwitch(
          isLeftSelected: _isCm,
          leftLabel: "cm",
          rightLabel: "ft",
          onLeftTap: () => setState(() => _isCm = true),
          onRightTap: () => setState(() => _isCm = false),
        ),

        const SizedBox(height: 20),

        // Main Content Area
        Expanded(
          child: Stack(
            children: [
              Row(
                children: [
                  // --- Left: Interactive Ruler ---
                  Expanded(
                    flex: 3,
                    child: HeightRuler(
                      isCm: _isCm,
                      initialHeight: displayVal,
                      minHeight: minVal,
                      maxHeight: maxVal,
                      onChanged: (val) {
                        setState(() {
                          if (_isCm) {
                            _data.heightCm = val;
                          } else {
                            _data.heightCm = val * 2.54;
                          }
                        });
                      },
                    ),
                  ),

                  // --- Right: Static Image ---
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.only(right: 20, bottom: 50),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/height.png',
                        fit: BoxFit.contain,
                        height: 400,
                      ),
                    ),
                  ),
                ],
              ),

              // --- Center: Selected Value Display ---
              // Using Align ensures it stays vertically centered with the red line
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 110), // Push slightly right of the ruler ticks
                  child: IgnorePointer(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          _isCm
                              ? displayVal.toStringAsFixed(0)
                              : _formatInchesToFeet(displayVal),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _isCm ? "cm" : "",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

// Helper to format feet
  String _formatInchesToFeet(double totalInches) {
    int feet = totalInches ~/ 12;
    int inches = (totalInches % 12).round();
    return "$feet' $inches\"";
  }

  // --- Screen 6: Weight ---
  Widget _buildWeightScreen() {
    double currentKg = _data.weightKg ?? 70.0;

    // Bounds and Conversions
    double minVal = _isKg ? 20.0 : 44.0;
    double maxVal = _isKg ? 200.0 : 440.0;
    double displayVal = _isKg ? currentKg : (currentKg * 2.20462);
    String weightString = (displayVal % 1 == 0)
        ? displayVal.toStringAsFixed(0)
        : displayVal.toStringAsFixed(1);

    return Column(
      children: [
        const SizedBox(height: 30),
        UnitSwitch(
          isLeftSelected: _isKg,
          leftLabel: "kg",
          rightLabel: "lbs",
          onLeftTap: () => setState(() => _isKg = true),
          onRightTap: () => setState(() => _isKg = false),
        ),

        const SizedBox(height: 60), // Spacing before the number

        // Large Weight Value
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              weightString,
              style: const TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.w900,
                color: AppColors.secondary,
                letterSpacing: -2,
                height: 1.0,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _isKg ? "kg" : "lbs",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 60),

        // Ruler Area
        SizedBox(
          height: 130, // Defined height for the scale area
          child: WeightRuler(
            key: ValueKey(_isKg),
            initialWeight: displayVal,
            minWeight: minVal,
            maxWeight: maxVal,
            onChanged: (val) {
              setState(() {
                if (_isKg) {
                  _data.weightKg = val;
                } else {
                  _data.weightKg = val / 2.20462;
                }
              });
            },
          ),
        ),
      ],
    );
  }

  // --- Screen 7: Activity Level ---
  Widget _buildActivityScreen() {
    // Define the data for each option: Title, Description, and Icon
    final List<Map<String, dynamic>> options = [
      {
        "level": "Low",
        "desc": "No exercise",
        "icon": Icons.weekend_outlined, // Sofa/Resting
      },
      {
        "level": "Medium",
        "desc": "Light exercise 1-3 days per week",
        "icon": Icons.directions_walk, // Walking
      },
      {
        "level": "High",
        "desc": "Intense exercise 3-5 days per week",
        "icon": Icons.fitness_center, // Dumbbell
      },
      {
        "level": "Very High",
        "desc": "Daily exercise/ Physical job",
        "icon": Icons.directions_run, // Running
      },
      {
        "level": "Extreme",
        "desc": "Athlete/Very hard physical job",
        "icon": Icons.emoji_events_outlined, // Trophy/Medal
      },
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: options.map((opt) {
        final String level = opt["level"];
        return OptionCard(
          title: level,
          subtitle: opt["desc"], // The specific description you asked for
          icon: opt["icon"],
          isSelected: _data.activityLevel == level,
          onTap: () => setState(() => _data.activityLevel = level),
        );
      }).toList(),
    );
  }

  // --- Screen 8: Goal Speed ---
  Widget _buildSpeedScreen() {
    final List<Map<String, dynamic>> speedOptions = [
      {"label": "Gradual", "icon": Icons.directions_walk},
      {"label": "Moderate", "icon": Icons.directions_run},
      {"label": "Fast", "icon": Icons.bolt_rounded},
      {"label": "Aggressive", "icon": Icons.rocket_launch_rounded},
    ];

    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: speedOptions.map((opt) {
        final String label = opt["label"];
        final IconData icon = opt["icon"];
        final isSelected = _data.goalSpeed == label;

        return GestureDetector(
          onTap: () => setState(() => _data.goalSpeed = label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: isSelected ? Colors.white : Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- Screen 9: Diet ---
  Widget _buildDietScreen() {
    final List<Map<String, dynamic>> dietOptions = [
      {
        "title": "Vegetarian",
        "image": "assets/images/veg.jpg",
        "icon": Icons.eco_rounded,
      },
      {
        "title": "Non-vegetarian",
        "image": "assets/images/nonveg.jpg",
        "icon": Icons.local_fire_department_rounded,
      },
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: dietOptions.map((opt) {
        final title = opt["title"] as String;
        final image = opt["image"] as String;
        final icon = opt["icon"] as IconData;

        return SizedBox(
          height: 230,
          child: ImageOptionCard(
            title: title,
            imagePath: image,
            icon: icon,
            isSelected: _data.dietaryPreference == title,
            onTap: () => setState(() => _data.dietaryPreference = title),
          ),
        );
      }).toList(),
    );
  }

  // --- Screen 10: Allergies ---
  Widget _buildAllergiesScreen() {
    final common = ["Peanut", "Mushroom", "Pork", "Beef", "Milk"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Wrap(
            spacing: 10,
            children: common.map((allergy) {
              final isSelected = _data.allergies.contains(allergy);
              return FilterChip(
                label: Text(allergy),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    val
                        ? _data.allergies.add(allergy)
                        : _data.allergies.remove(allergy);
                  });
                },
                backgroundColor: Colors.white,
                selectedColor: AppColors.primary.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.black,
                ),
                shape: StadiumBorder(
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade300,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // --- Screen 11: Meal Times ---
  Widget _buildMealTimeScreen() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        children: [
          _buildMealCard(
              label: "Breakfast Time",
              icon: Icons.sunny,
              mealKey: "Breakfast"
          ),
          _buildMealCard(
              label: "Lunch Time",
              icon: Icons.restaurant_rounded,
              mealKey: "Lunch"
          ),
          _buildMealCard(
              label: "Dinner Time",
              icon: Icons.bedtime_rounded,
              mealKey: "Dinner"
          )
        ],
      ),
    );
  }

  Widget _buildMealCard({
    required String label,
    required IconData icon,
    required String mealKey
  }) {
    bool isSelected = _mealTimes[mealKey] != null;
    TimeOfDay displayTime = _mealTimes[mealKey] ?? const TimeOfDay(hour: 8, minute: 0);

    String hourStr = displayTime.hour.toString().padLeft(2, '0');
    String minuteStr = displayTime.minute.toString().padLeft(2, '0');

    Color activeColor = const Color(0xFFFF4B4B);
    Color activeBg = const Color(0xFFFFE5E5);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _mealTimes[mealKey] = null;
          } else {
            _mealTimes[mealKey] = const TimeOfDay(hour: 8, minute: 00);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 25),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Header: Icon + Label + Selection Indicator
            Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? activeColor : Colors.grey.shade600,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primary : Colors.grey.shade600,
                  ),
                ),
                const Spacer(),

                SelectionIndicator(
                    isSelected: isSelected,
                    activeColor: activeColor
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Time Picker Area
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeBox(hourStr, isSelected, () => _pickTime(context, mealKey, displayTime)),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    ":",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? Colors.grey.shade800 : Colors.grey.shade400,
                    ),
                  ),
                ),

                _buildTimeBox(minuteStr, isSelected, () => _pickTime(context, mealKey, displayTime)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        width: 100,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.transparent,
          ),
          boxShadow: isActive
              ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.grey.shade800 : Colors.grey.shade400,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, String key, TimeOfDay initial) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF4B4B), // Header background & Active dial
              onPrimary: Colors.white,    // Header text
              onSurface: Colors.black,    // Unselected text
              outline: Colors.transparent, // outlines
              tertiaryContainer: Color(0xFFFF4B4B),
              onTertiaryContainer: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _mealTimes[key] = picked;
      });
    }
  }

  // --- Screen 12: Medical Conditions ---
  Widget _buildMedicalConditionScreen() {
    final conditions = [
      "Diabetes",
      "High Cholesterol",
      "Hypertension",
      "Fatty Liver",
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: conditions.map((cond) {
          final isSelected = _data.medicalConditions.contains(cond);
          return FilterChip(
            label: Text(cond),
            selected: isSelected,
            onSelected: (val) {
              setState(() {
                val
                    ? _data.medicalConditions.add(cond)
                    : _data.medicalConditions.remove(cond);
              });
            },
            backgroundColor: Colors.white,
            selectedColor: AppColors.primary.withOpacity(0.2),
            labelStyle: TextStyle(
              color: isSelected ? AppColors.primary : Colors.black,
            ),
            shape: StadiumBorder(
              side: BorderSide(
                color: isSelected ? AppColors.primary : Colors.grey.shade300,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Screen 13: Calorie Goal ---
  Widget _buildCalorieGoalScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // slider
        UnitSwitch(
          isLeftSelected: _isKcal,
          leftLabel: "Kcal",
          rightLabel: "Joule's",
          activeColor: AppColors.primary,
          onLeftTap: () => setState(() => _isKcal = true),
          onRightTap: () => setState(() => _isKcal = false),
        ),
        const SizedBox(height: 40),

        // Updates based on unit
        Text(
          _isKcal
              ? "${_data.dailyCalorieGoal}"
              : "${(_data.dailyCalorieGoal! * 4.184).round()}",
          style: GoogleFonts.workSans(
            fontSize: 90,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
            height: 1,
          ),
        ),

        Text(
          _isKcal ? "calories daily" : "joules daily",
          style: GoogleFonts.workSans(
            fontSize: 20,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WideFloatingButton(
              icon: Icons.remove,
              backgroundColor: Colors.grey.shade200,
              iconColor: Colors.black45,
              onPressed: () => setState(() {
                _data.dailyCalorieGoal = (_data.dailyCalorieGoal! - 50).clamp(
                  500,
                  10000,
                );
              }),
            ),

            const SizedBox(width: 18),

            WideFloatingButton(
              icon: Icons.add,
              backgroundColor: AppColors.primary,
              iconColor: Colors.white,
              onPressed: () => setState(() {
                _data.dailyCalorieGoal = (_data.dailyCalorieGoal! + 50).clamp(
                  500,
                  10000,
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 70),
      ],
    );
  }

  Widget _buildSleepQualityScreen() {
    final List<Map<String, dynamic>> speedOptions = [
      {"label": "Excellent", "icon": Icons.sentiment_very_satisfied_rounded},
      {"label": "Good", "icon": Icons.sentiment_satisfied_rounded},
      {"label": "Fair", "icon": Icons.sentiment_neutral_rounded},
      {"label": "Poor", "icon": Icons.sentiment_dissatisfied_rounded},
    ];

    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: speedOptions.map((opt) {
        final String label = opt["label"];
        final IconData icon = opt["icon"];
        final isSelected = _data.sleepQuality == label;

        return GestureDetector(
          onTap: () => setState(() => _data.sleepQuality = label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: isSelected ? Colors.white : Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProgressBar() {
    final progress = (_currentPage + 1) / _totalSteps;

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: 8,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation(AppColors.primary),
        ),
      ),
    );
  }
}

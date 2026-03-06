import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../models/onboarding_dto.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';
import 'package:flutter/services.dart';

import 'dashboard_screen.dart';
import 'main_navigation_screen.dart';

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
  bool _showWelcome = false;
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
    if (!mounted) return;
    Navigator.pop(context);

    if (success) {
      showModernToast(
        context,
        "Profile created successfully!",
        type: 'success',
      );

      // Replace onboarding with dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } else {
      showModernToast(
        context,
        "Failed to save data. Please try again.",
        type: 'error',
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
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
                      _buildCompletionScreen(),
                    ],
                  ),
                ),

                // Bottom Button Logic
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 24,
                    ),
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
        Image.asset(
          'assets/images/questionnaire/welcome.jpg',
          fit: BoxFit.cover,
        ),
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
                child: PrimaryButton(
                  onTap: _nextPage,
                  text: "Let's Go",
                  isRed: true,
                ),
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
        "image": "assets/images/questionnaire/male.jpg",
        "icon": Icons.male_rounded,
      },
      {
        "title": "Female",
        "image": "assets/images/questionnaire/female.jpg",
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
        scrollController: FixedExtentScrollController(
          initialItem: initialIndex,
        ),
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

  Widget _buildHeightScreen() {
    double currentCm = _data.heightCm ?? 170.0;
    double minCm = 100.0;
    double maxCm = 250.0;
    double minVal, maxVal, displayVal;

    if (_isCm) {
      minVal = minCm;
      maxVal = maxCm;
      displayVal = currentCm;
    } else {
      minVal = (minCm / 2.54).floorToDouble();
      maxVal = (maxCm / 2.54).ceilToDouble();
      displayVal = currentCm / 2.54;
    }

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

        Expanded(
          child: Stack(
            children: [
              Row(
                children: [
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
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 30,
                        right: 0,
                        bottom: 40,
                      ),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/questionnaire/height.png',
                        fit: BoxFit.contain,
                        height: 400,
                      ),
                    ),
                  ),
                ],
              ),

              // Text Display
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 140),
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

                double h = _data.heightCm ?? 1.0;
                // BMI Formula: weight (kg) / height (m)^2
                _data.bmi = val / (h * h * 0.0001);
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
                width: 2,
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
        "image": "assets/images/questionnaire/veg.jpg",
        "icon": Icons.eco_rounded,
      },
      {
        "title": "Non-vegetarian",
        "image": "assets/images/questionnaire/nonveg.jpg",
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
    List<String> presetAllergies = [
      "MilkLow-Sodium", "Low-Cholesterol", "Keto", "Caffeine-Free",
      "MSG-Free", "Histamine", "Lacktose free", "Gluten free", "Diary free",
    ];

    const maxItems = 10;
    final TextEditingController _controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Do you have any\nallergic foods?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF2D3142)),
          ),
          const SizedBox(height: 30),

          /// Preset Filter Chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: presetAllergies.map((allergy) {
              final isSelected = _data.allergies.contains(allergy);
              return ChoiceChip(
                label: Text(allergy),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    // Ensure we are working with a growable list
                    List<String> mutableList = List<String>.from(_data.allergies);
                    if (val) {
                      if (!mutableList.contains(allergy) && mutableList.length < maxItems) {
                        mutableList.add(allergy);
                      }
                    } else {
                      mutableList.remove(allergy);
                    }
                    _data.allergies = mutableList;
                  });
                },
                backgroundColor: const Color(0xFFF2F2F2),
                selectedColor: const Color(0xFFF2544D),
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                side: BorderSide.none,
                showCheckmark: false,
              );
            }).toList(),
          ),

          const SizedBox(height: 40),

          /// Selection Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF2544D).withOpacity(0.5), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ..._data.allergies.map((item) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _data.allergies = List<String>.from(_data.allergies)..remove(item);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2544D).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(item, style: const TextStyle(color: Color(0xFFF2544D), fontWeight: FontWeight.bold)),
                        ),
                      );
                    }).toList(),

                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(hintText: "Add...", border: InputBorder.none, isDense: true),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        onSubmitted: (value) {
                          if (value.isNotEmpty && _data.allergies.length < maxItems) {
                            setState(() {
                              // Ensure list is growable here too
                              _data.allergies = List<String>.from(_data.allergies)..add(value);
                              _controller.clear();
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_document, size: 18, color: Color(0xFFF2544D)),
                      const SizedBox(width: 4),
                      Text("${_data.allergies.length}/$maxItems", style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
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
            mealKey: "Breakfast",
          ),
          _buildMealCard(
            label: "Lunch Time",
            icon: Icons.restaurant_rounded,
            mealKey: "Lunch",
          ),
          _buildMealCard(
            label: "Dinner Time",
            icon: Icons.bedtime_rounded,
            mealKey: "Dinner",
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard({
    required String label,
    required IconData icon,
    required String mealKey,
  }) {
    bool isSelected = _mealTimes[mealKey] != null;
    TimeOfDay displayTime =
        _mealTimes[mealKey] ?? const TimeOfDay(hour: 8, minute: 0);

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
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade600,
                  ),
                ),
                const Spacer(),

                SelectionIndicator(
                  isSelected: isSelected,
                  activeColor: activeColor,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Time Picker Area
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeBox(
                  hourStr,
                  isSelected,
                  () => _pickTime(context, mealKey, displayTime),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    ":",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: isSelected
                          ? Colors.grey.shade800
                          : Colors.grey.shade400,
                    ),
                  ),
                ),

                _buildTimeBox(
                  minuteStr,
                  isSelected,
                  () => _pickTime(context, mealKey, displayTime),
                ),
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
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
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

  Future<void> _pickTime(
    BuildContext context,
    String key,
    TimeOfDay initial,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF4B4B), // Header background & Active dial
              onPrimary: Colors.white, // Header text
              onSurface: Colors.black, // Unselected text
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
    final List<String> conditions = [
      "Diabetes",
      "Hypertension",
      "High Cholesterol",
      "Heart Disease",
      "Asthma",
      "Arthritis",
      "Thyroid Disorder",
      "Fatty Liver",
      "Anemia",
      "Kidney Disease",
      "Gastritis",
      "Migraine",
    ];

    const maxItems = 10;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Common allergy chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: conditions.map((allergy) {
              final isSelected = _data.medicalConditions.contains(allergy);
              return FilterChip(
                label: Text(allergy),
                selected: isSelected,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      if (!_data.medicalConditions.contains(allergy) &&
                          _data.medicalConditions.length < maxItems) {
                        _data.medicalConditions.add(allergy);
                      }
                    } else {
                      _data.medicalConditions.remove(allergy);
                    }
                  });
                },
                backgroundColor: Colors.grey.shade100,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : Colors.black87,
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

          const SizedBox(height: 40),

          /// Input-like container with selected chips
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_data.medicalConditions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "No medical conditions selected. Tap chips above to add.",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _data.medicalConditions.map((item) {
                      return Chip(
                        label: Text(item),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _data.medicalConditions.remove(item);
                          });
                        },
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        labelStyle: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 50),

                /// Counter
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_note, size: 16, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        "${_data.medicalConditions.length}/$maxItems",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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

  // --- Screen 14: Sleep quality ---
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
                width: 2,
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

  // --- Screen 15: Completion / Ready to Sync ---
  Widget _buildCompletionScreen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2), // Push content slightly upwards
          // 1. Hero Icon (Rocket Sign)
          Container(
            height: 260,
            width: 260,
            decoration: BoxDecoration(
              // Subtle primary color background blob
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.rocket_launch_rounded, // A dynamic rocket icon
              size: 160, // Big size
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 40),

          // 2. Headline
          const Text(
            "You're All Set!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // 3. Subtitle
          Text(
            "We've personalized your plan based on your goals and preferences. Let's start your journey!",
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 3), // Leave space for the bottom button
        ],
      ),
    );
  }

  // // --- Screen 15: Completion / Ready to Sync ---
  // Widget _buildCompletionScreen() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 30.0),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         const Spacer(flex: 2), // Push content slightly upwards
  //
  //         // 1. Hero Image
  //         // Make sure to add a 'success.png' or 'finish.png' to your assets
  //         Container(
  //           height: 280,
  //           decoration: BoxDecoration(
  //             color: AppColors.primary.withOpacity(0.05), // Subtle background blob
  //             shape: BoxShape.circle,
  //           ),
  //           padding: const EdgeInsets.all(40),
  //           child: Image.asset(
  //             'assets/images/questionnaire/finish.png',
  //             fit: BoxFit.contain,
  //           ),
  //         ),
  //
  //         const SizedBox(height: 40),
  //
  //         // 2. Headline
  //         const Text(
  //           "You're All Set!",
  //           style: TextStyle(
  //             fontSize: 28,
  //             fontWeight: FontWeight.w900,
  //             color: Colors.black87,
  //             letterSpacing: -0.5,
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //
  //         const SizedBox(height: 16),
  //
  //         // 3. Subtitle
  //         Text(
  //           "We've personalized your plan based on your goals and preferences. Let's start your journey!",
  //           style: TextStyle(
  //             fontSize: 16,
  //             height: 1.5,
  //             color: Colors.grey.shade600,
  //             fontWeight: FontWeight.w500,
  //           ),
  //           textAlign: TextAlign.center,
  //         ),
  //
  //         const Spacer(flex: 3), // Leave space for the bottom button
  //       ],
  //     ),
  //   );
  // }

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

import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../services/DietPlanService.dart';
import '../services/FirebaseImageService.dart';
import '../widgets/common_widgets.dart';
import 'meal_detail_screen.dart';

class MealPlanPreviewScreen extends StatefulWidget {
  final int? userId;
  final int? planId;
  final bool isReadOnly;

  const MealPlanPreviewScreen({
    super.key,
    required this.userId,
    this.planId,
    this.isReadOnly = false,
  });

  @override
  State<MealPlanPreviewScreen> createState() => _MealPlanPreviewScreenState();
}

class _MealPlanPreviewScreenState extends State<MealPlanPreviewScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = true;
  Map<String, dynamic>? _planData;

  @override
  void initState() {
    super.initState();
    if (widget.planId != null) {
      _fetchExistingPlan();
    } else {
      _generateNewPlan();
    }
  }

  Future<void> _fetchExistingPlan() async {
    setState(() => _isLoading = true);
    try {
      final response = await DietPlanService.getDietPlanDetails(widget.planId!);
      if (mounted) {
        if (response.success) {
          setState(() => _planData = response.data);
        } else {
          showModernToast(context, 'Failed to load plan details', type: 'error');
        }
      }
    } catch (e) {
      if (mounted) showModernToast(context, 'An unexpected error occurred', type: 'error');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _generateNewPlan() async {
    if (widget.userId == null) {
      showModernToast(context, 'User ID is missing.', type: 'error');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await DietPlanService.generatePlanPreview(widget.userId!);
      if (mounted) {
        if (response.success) {
          setState(() => _planData = response.data);
        } else {
          showModernToast(context, 'Failed to generate plan: ${response.message}', type: 'error');
        }
      }
    } catch (e) {
      if (mounted) showModernToast(context, 'An unexpected error occurred.', type: 'error');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _savePlan() async {
    if (_nameController.text.trim().isEmpty) {
      showModernToast(context, 'Please enter a name for your plan', type: 'error');
      return;
    }

    LoadingIndicator.show(context);

    final payload = {
      "userId": widget.userId,
      "dietPlanName": _nameController.text.trim(),
      "dietPlanDescription": "A newly generated AI diet plan.",
      "dietPlanImage": "https://images.unsplash.com/photo-1490645935967-10de6ba17061?q=80&w=600&auto=format&fit=crop",
      "generatedPlan": _planData,
    };

    final response = await DietPlanService.saveDietPlan(payload);

    LoadingIndicator.hide(context);

    if (response.success) {
      showModernToast(context, 'Plan saved successfully!', type: 'success');
      Navigator.pop(context);
    } else {
      showModernToast(context, 'Failed to save plan', type: 'error');
    }
  }

  void _showEditMealPopup(Map<String, dynamic> meal, int groupIndex, int mealIndex) {
    final TextEditingController nameController = TextEditingController(text: meal["recipeName"] ?? meal["name"] ?? "");
    final TextEditingController prepTimeController = TextEditingController(text: (meal["prepTimeMin"] ?? 15).toString());
    final TextEditingController kcalController = TextEditingController(text: (meal["calories"] ?? meal["kcal"] ?? 0).toString());
    final TextEditingController proteinController = TextEditingController(text: (meal["proteinG"] ?? meal["protein"] ?? 0).toString());
    final TextEditingController carbsController = TextEditingController(text: (meal["carbsG"] ?? meal["carbs"] ?? 0).toString());
    final TextEditingController fatController = TextEditingController(text: (meal["fatG"] ?? meal["fat"] ?? 0).toString());

    String currentImageUrl = meal["mealImageUrl"] ?? meal["imageUrl"] ?? "";
    String mealType = (meal["mealType"] ?? meal["type"] ?? "MEAL").toString().toUpperCase();
    bool isUploadingImage = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.background,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          child: StatefulBuilder(
            builder: (context, setPopupState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Edit Meal", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textMain)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, color: AppColors.textSub),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          setPopupState(() => isUploadingImage = true);
                          String? newUrl = await FirebaseImageService.pickAndUploadImage();
                          if (newUrl != null) {
                            setPopupState(() => currentImageUrl = newUrl);
                          }
                          setPopupState(() => isUploadingImage = false);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: isUploadingImage
                              ? Container(
                            height: 120, width: 120, color: Colors.grey.shade100,
                            child: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                          )
                              : currentImageUrl.isNotEmpty
                              ? Image.network(currentImageUrl, height: 120, width: 120, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildFallbackPopupImage())
                              : _buildFallbackPopupImage(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(child: Text("Tap image to change", style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600))),
                    const SizedBox(height: 24),

                    _buildPopupTextField("Meal Type", TextEditingController(text: mealType), isEnabled: false),
                    const SizedBox(height: 16),

                    _buildPopupTextField("Recipe Name", nameController),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(child: _buildPopupTextField("Prep Time (min)", prepTimeController, isNumeric: true)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildPopupTextField("Calories (kcal)", kcalController, isNumeric: true)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(child: _buildPopupTextField("Protein (g)", proteinController, isNumeric: true)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildPopupTextField("Carbs (g)", carbsController, isNumeric: true)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildPopupTextField("Fat (g)", fatController, isNumeric: true)),
                      ],
                    ),
                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          setState(() {
                            List<dynamic> weeklyPlan = [];
                            if (_planData!['weeklyPlan'] != null) {
                              weeklyPlan = _planData!['weeklyPlan'];
                            } else if (_planData!['generatedPlan'] != null && _planData!['generatedPlan']['weeklyPlan'] != null) {
                              weeklyPlan = _planData!['generatedPlan']['weeklyPlan'];
                            }

                            weeklyPlan[groupIndex]['meals'][mealIndex] = {
                              ...meal,
                              "recipeName": nameController.text.trim(),
                              "prepTimeMin": int.tryParse(prepTimeController.text) ?? 15,
                              "calories": int.tryParse(kcalController.text) ?? 0,
                              "proteinG": int.tryParse(proteinController.text) ?? 0,
                              "carbsG": int.tryParse(carbsController.text) ?? 0,
                              "fatG": int.tryParse(fatController.text) ?? 0,
                              "mealImageUrl": currentImageUrl,
                            };
                          });
                          Navigator.pop(context);
                          showModernToast(context, 'Meal swapped locally. Save plan to keep changes.', type: 'success');
                        },
                        child: const Text("Swap Meal", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFallbackPopupImage() {
    return Container(
      height: 120, width: 120, color: Colors.grey.shade200,
      child: const Icon(Icons.add_a_photo, color: Colors.grey, size: 30),
    );
  }

  Widget _buildPopupTextField(String label, TextEditingController controller, {bool isEnabled = true, bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSub)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: isEnabled,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          style: TextStyle(color: isEnabled ? AppColors.textMain : Colors.grey.shade500, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: isEnabled ? Colors.white : Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> weeklyPlan = [];
    if (_planData != null) {
      if (_planData!['weeklyPlan'] != null) {
        weeklyPlan = _planData!['weeklyPlan'];
      } else if (_planData!['generatedPlan'] != null && _planData!['generatedPlan']['weeklyPlan'] != null) {
        weeklyPlan = _planData!['generatedPlan']['weeklyPlan'];
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
              // UPDATED: Use the new animated AI loader here
                  ? const MealPlanAILoadingState()
                  : _planData == null || weeklyPlan.isEmpty
                  ? const Center(child: Text("No meals found for this plan."))
                  : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  if (!widget.isReadOnly) _buildSubtitle(),
                  if (!widget.isReadOnly) const SizedBox(height: 24),
                  if (!widget.isReadOnly) _buildNameInput(),
                  if (!widget.isReadOnly) const SizedBox(height: 32),
                  ...List.generate(weeklyPlan.length, (gIndex) => _buildMealGroup(weeklyPlan[gIndex], gIndex)),
                ],
              ),
            ),
            if (!widget.isReadOnly && !_isLoading && _planData != null && weeklyPlan.isNotEmpty)
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
            icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textMain),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          Text(
            widget.isReadOnly ? "View Meal Plan" : "Meal Plan Preview",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textMain),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return const Text(
      "Here are the meals selected for your plan. Review them before saving.",
      style: TextStyle(fontSize: 15, color: AppColors.textSub, height: 1.4),
    );
  }

  Widget _buildNameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Meal Plan Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textMain)),
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
              hintText: "E.g., My Healthy Week",
              hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealGroup(Map<String, dynamic> group, int groupIndex) {
    final List<dynamic> meals = group["meals"] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group["day"] ?? "Day",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMain),
        ),
        const SizedBox(height: 16),
        ...List.generate(meals.length, (mIndex) => _buildMealCard(meals[mIndex], groupIndex, mIndex)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal, int groupIndex, int mealIndex) {
    Color badgeColor;
    Color badgeTextColor;

    final String mealType = (meal["mealType"] ?? meal["type"] ?? "MEAL").toString().toUpperCase();
    final String recipeName = meal["recipeName"] ?? meal["name"] ?? "Unknown Meal";
    final String imageUrl = meal["mealImageUrl"] ?? meal["imageUrl"] ?? "";

    switch (mealType) {
      case "BREAKFAST":
        badgeColor = const Color(0xFFFEF3C7); badgeTextColor = const Color(0xFFD97706); break;
      case "LUNCH":
        badgeColor = const Color(0xFFFFEDD5); badgeTextColor = const Color(0xFFC2410C); break;
      case "DINNER":
        badgeColor = const Color(0xFFDBEAFE); badgeTextColor = const Color(0xFF1D4ED8); break;
      default:
        badgeColor = Colors.grey.shade200; badgeTextColor = Colors.grey.shade700;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => MealDetailScreen(mealData: meal)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isNotEmpty && imageUrl.startsWith('http')
                  ? Image.network(
                imageUrl, width: 70, height: 70, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildCardFallbackImage(),
              )
                  : _buildCardFallbackImage(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(6)),
                    child: Text(mealType, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeTextColor, letterSpacing: 0.5)),
                  ),
                  const SizedBox(height: 8),
                  Text(recipeName, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textMain)),
                ],
              ),
            ),
            if (!widget.isReadOnly)
              Container(
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                  onPressed: () => _showEditMealPopup(meal, groupIndex, mealIndex),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFallbackImage() {
    return Container(
      width: 70, height: 70, color: Colors.grey.shade200,
      child: const Icon(Icons.fastfood, color: Colors.grey),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: SizedBox(
        width: double.infinity, height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0,
          ),
          onPressed: _savePlan,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Save Meal Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
              SizedBox(width: 8),
              Icon(Icons.check_circle_outline, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// AI Loading Widget for Meal Plan Generation
// ---------------------------------------------------------
class MealPlanAILoadingState extends StatefulWidget {
  const MealPlanAILoadingState({super.key});

  @override
  State<MealPlanAILoadingState> createState() => _MealPlanAILoadingStateState();
}

class _MealPlanAILoadingStateState extends State<MealPlanAILoadingState> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _textTimer;
  int _textIndex = 0;

  final List<String> _loadingPhrases = [
    "Analyzing your dietary preferences...",
    "Calculating optimal macronutrients...",
    "Curating delicious, healthy recipes...",
    "Balancing your daily calorie goals...",
    "Generating your personalized meal plan...",
  ];

  @override
  void initState() {
    super.initState();
    // Creates a continuous smooth scaling/pulsing effect
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Cycles the text every 2.5 seconds
    _textTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (mounted) {
        setState(() {
          _textIndex = (_textIndex + 1) % _loadingPhrases.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _textTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pulsing Icon (Food / Meal Generation)
            ScaleTransition(
              scale: Tween<double>(begin: 0.85, end: 1.15).animate(
                CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
              ),
              child: Icon(
                Icons.fastfood_rounded,
                size: 90,
                color: AppColors.primary.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 40),

            // Custom Styled Progress Indicator
            const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 24),

            // Animated Text Switcher for AI Phrases
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _loadingPhrases[_textIndex],
                key: ValueKey<int>(_textIndex),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSub,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
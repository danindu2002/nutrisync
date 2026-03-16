import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/common_widgets.dart';
import 'meal_plan_preview_screen.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  final List<MealPlanItem> _mealPlans = [
    MealPlanItem(
      imagePath: 'assets/images/MealPlan.png',
      name: 'Diabetes Management Plan',
      description:
      'A personalized meal plan focused on balancing blood sugar levels through nutritious, portion-controlled meals.',
    ),
    MealPlanItem(
      imagePath: 'assets/images/MealPlan.png',
      name: 'Weight Loss Plan',
      description:
      'A calorie-conscious meal plan designed to support healthy weight reduction with balanced nutrition.',
    ),
  ];

  void _goToMealPlanPreview({MealPlanItem? plan}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MealPlanPreviewScreen(),
      ),
    );
  }

  void _showEditMealPlanPopup(int index) {
    final selectedPlan = _mealPlans[index];
    final TextEditingController nameController =
    TextEditingController(text: selectedPlan.name);
    final TextEditingController descriptionController =
    TextEditingController(text: selectedPlan.description);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(28),
            ),
            child: StatefulBuilder(
              builder: (context, setPopupState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.textMain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Image.asset(
                          selectedPlan.imagePath,
                          height: 140,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 12),

                      GestureDetector(
                        onTap: () {
                          showModernToast(
                            context,
                            'Image change will be connected later',
                            type: 'info',
                          );
                        },
                        child: Text(
                          'Change Photo',
                          style: AppTextStyles.subHeader.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Plan Name',
                          style: AppTextStyles.subHeader.copyWith(
                            color: AppColors.textMain,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter meal plan name',
                          filled: true,
                          fillColor: AppColors.cardBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Plan Description',
                          style: AppTextStyles.subHeader.copyWith(
                            color: AppColors.textMain,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Enter meal plan description',
                          filled: true,
                          fillColor: AppColors.cardBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _mealPlans[index] = MealPlanItem(
                                imagePath: selectedPlan.imagePath,
                                name: nameController.text.trim().isEmpty
                                    ? selectedPlan.name
                                    : nameController.text.trim(),
                                description:
                                descriptionController.text.trim().isEmpty
                                    ? selectedPlan.description
                                    : descriptionController.text.trim(),
                              );
                            });

                            Navigator.pop(context);

                            showModernToast(
                              context,
                              'Meal plan updated successfully',
                              type: 'success',
                            );
                          },
                          child: Text(
                            'Save Changes',
                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }



  Widget _buildFeaturePoint(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: AppTextStyles.subHeader.copyWith(
              color: AppColors.textMain,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlanCard(MealPlanItem plan, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(24),
              ),
              onTap: () => _goToMealPlanPreview(plan: plan),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        plan.imagePath,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.subHeader.copyWith(
                              color: AppColors.textMain,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            plan.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.subHeader.copyWith(
                              fontSize: 13,
                              color: AppColors.textSub,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () => _showEditMealPlanPopup(index),
            child: Container(
              width: 88,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Edit',
                    style: AppTextStyles.buttonText.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlanListState() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ...List.generate(
            _mealPlans.length,
                (index) => _buildMealPlanCard(_mealPlans[index], index),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasMealPlans = _mealPlans.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Bar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    color: AppColors.textMain,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Meal Plan',
                    style: AppTextStyles.header,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                'Stay on track with smart, personalized meal plans built for your goals.',
                style: AppTextStyles.subHeader.copyWith(
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              

              const SizedBox(height: 20),

              PrimaryButton(
                onTap: () => _goToMealPlanPreview(),
                text: 'Create Meal Plan',
                isRed: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealPlanItem {
  final String imagePath;
  final String name;
  final String description;

  MealPlanItem({
    required this.imagePath,
    required this.name,
    required this.description,
  });
}
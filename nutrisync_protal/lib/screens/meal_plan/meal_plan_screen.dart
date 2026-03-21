import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../services/diet_plan_service.dart';
import '../../services/firebase_image_service.dart';
import '../../widgets/common_widgets.dart';
import 'meal_plan_preview_screen.dart';

class MealPlanScreen extends StatefulWidget {
  final int? userId;
  const MealPlanScreen({super.key, required this.userId});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  bool _isLoading = true;
  List<dynamic> _mealPlans = [];

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await DietPlanService.getDietPlans(widget.userId);

      if (mounted) {
        if (response.success) {
          setState(() {
            _mealPlans = response.data ?? [];
          });
        } else if (response.status == 404) {
          setState(() {
            _mealPlans = [];
          });
        } else {
          debugPrint("Meal Plan Error: ${response.message}");
          showModernToast(context, 'Failed to load meal plans', type: 'error');
          setState(() {
            _mealPlans = [];
          });
        }
      }
    } catch (e) {
      debugPrint("Exception in _fetchPlans: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDeleteConfirmation(int planId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Plan?', style: AppTextStyles.header.copyWith(fontSize: 20)),
        content: Text(
          'Are you sure you want to delete this meal plan? This action cannot be undone.',
          style: AppTextStyles.subHeader,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSub)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              LoadingIndicator.show(context);

              final res = await DietPlanService.deleteDietPlan(planId);

              LoadingIndicator.hide(context);

              if (res.success) {
                showModernToast(context, 'Plan deleted', type: 'success');
                _fetchPlans(); // Refresh the list
              } else {
                showModernToast(context, 'Failed to delete plan', type: 'error');
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _goToMealPlanPreview({int? planId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealPlanPreviewScreen(
          userId: widget.userId,
          planId: planId, // If null, it generates a new one. If provided, it views the existing one.
          isReadOnly: planId != null,
        ),
      ),
    ).then((_) => _fetchPlans()); // Refresh list when returning
  }

  void _showEditMealPlanPopup(Map<String, dynamic> plan) {
    final TextEditingController nameController =
    TextEditingController(text: plan['dietPlanName'] ?? '');
    final TextEditingController descriptionController =
    TextEditingController(text: plan['dietPlanDescription'] ?? '');

    // Manage local state inside the dialog
    String currentImageUrl = plan['dietPlanImage'] ?? '';
    bool isUploadingImage = false;

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

                      // --- DYNAMIC IMAGE DISPLAY ---
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: isUploadingImage
                            ? const SizedBox(
                          height: 140,
                          width: 140,
                          child: Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        )
                            : currentImageUrl.startsWith('http')
                            ? Image.network(
                          currentImageUrl,
                          height: 140,
                          width: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildFallbackImage(),
                        )
                            : _buildFallbackImage(),
                      ),

                      const SizedBox(height: 12),

                      // --- UPLOAD BUTTON TRIGGER ---
                      GestureDetector(
                        onTap: () async {
                          setPopupState(() => isUploadingImage = true);

                          // Call your new Firebase service
                          String? newUrl = await FirebaseImageService.pickAndUploadImage();

                          if (newUrl != null) {
                            // Update the image immediately in the popup
                            setPopupState(() {
                              currentImageUrl = newUrl;
                              isUploadingImage = false;
                            });
                          } else {
                            // Cancelled or Failed
                            setPopupState(() => isUploadingImage = false);
                          }
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
                          onPressed: () async {
                            Navigator.pop(context); // Close dialog
                            LoadingIndicator.show(context); // Show full-screen loader

                            // Send the updated URL to Spring Boot
                            final payload = {
                              "dietPlanName": nameController.text.trim(),
                              "dietPlanDescription": descriptionController.text.trim(),
                              "dietPlanImage": currentImageUrl, // Uses the newly uploaded Firebase URL!
                            };

                            final res = await DietPlanService.updatePlanMetadata(plan['planId'], payload);

                            LoadingIndicator.hide(context);

                            if (res.success) {
                              showModernToast(context, 'Meal plan updated successfully', type: 'success');
                              _fetchPlans(); // Refresh the list screen to show new data
                            } else {
                              showModernToast(context, 'Failed to update plan', type: 'error');
                            }
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

  Widget _buildFallbackImage() {
    return Image.asset(
      'assets/images/meal_plan/MealPlan.png',
      height: 140,
      width: 140,
      fit: BoxFit.cover,
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/meal_plan/MealPlan.png',
            height: 220,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Text(
            'No Meal Plans Yet',
            style: AppTextStyles.header.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Create personalized meal plans tailored to your goals and nutrition needs.',
            style: AppTextStyles.subHeader,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildFeaturePoint(Icons.schedule, 'Full Daily Coverage'),
          const SizedBox(height: 12),
          _buildFeaturePoint(Icons.flag, 'Goal-Oriented'),
          const SizedBox(height: 12),
          _buildFeaturePoint(Icons.local_dining, 'Nutrient Dense'),
        ],
      ),
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

  Widget _buildMealPlanCard(Map<String, dynamic> plan) {
    String imageUrl = plan['dietPlanImage'] ?? '';
    String name = plan['dietPlanName'] ?? 'Custom Meal Plan';
    String description = plan['dietPlanDescription'] ?? 'Your personalized nutrition guide.';
    int planId = plan['planId'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Explicitly adding the requested slight grey shade
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), // Soft shadow to make the grey card pop
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: Content Area (Clickable to Preview)
            Expanded(
              child: InkWell(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
                onTap: () => _goToMealPlanPreview(planId: planId),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: imageUrl.startsWith('http')
                            ? Image.network(
                          imageUrl,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildCardFallbackImage(),
                        )
                            : _buildCardFallbackImage(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.subHeader.copyWith(
                                color: AppColors.textMain,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.subHeader.copyWith(
                                fontSize: 13,
                                color: AppColors.textSub,
                                height: 1.3,
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

            // Middle: Edit Button
            GestureDetector(
              onTap: () => _showEditMealPlanPopup(plan),
              child: Container(
                width: 48,
                color: AppColors.primary,
                child: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
              ),
            ),

            // Right: Delete Button
            GestureDetector(
              onTap: () => _showDeleteConfirmation(planId),
              child: Container(
                width: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE5E5),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardFallbackImage() {
    return Image.asset(
      'assets/images/meal_plan/MealPlan.png',
      width: 72,
      height: 72,
      fit: BoxFit.cover,
    );
  }

  Widget _buildMealPlanListState() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _mealPlans.length,
        itemBuilder: (context, index) {
          return _buildMealPlanCard(_mealPlans[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasMealPlans = _mealPlans.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _fetchPlans,
        color: AppColors.primary,
        child: SafeArea(
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

                if (_isLoading)
                  const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
                else if (hasMealPlans)
                  _buildMealPlanListState()
                else
                  _buildEmptyState(),

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
      ),
    );
  }
}
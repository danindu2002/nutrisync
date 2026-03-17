import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'dashboard_screen.dart';
import '../models/risk_model.dart';
import '../widgets/risk_card.dart';
import '../models/contributing_meal_model.dart';
import '../widgets/risk_detail_sheet.dart';
import '../models/meal_swap_model.dart';
import '../widgets/meal_swap_card.dart';
import '../services/api_service.dart';

class RiskPredictorScreen extends StatefulWidget {
  const RiskPredictorScreen({super.key});

  @override
  State<RiskPredictorScreen> createState() => _RiskPredictorScreenState();
}

class _RiskPredictorScreenState extends State<RiskPredictorScreen> {
  String selectedPeriod = '1 year';
  int currentSwapIndex = 0;

  bool isLoading = false;
  String? errorMessage;
  List<RiskModel> risks = [];

  final List<String> periods = ['1 year', '2 years', '5 years', '10 years'];

  // Mock risks removed. Now using API risks state list.

  final List<MealSwapModel> mockMealSwaps = [
    MealSwapModel(
      currentMealName: "Fried Rice",
      currentMealImagePath: "assets/images/risk/fried_rice.png",
      currentMealMetric: "50g Saturated Fat",
      suggestedMealName: "Quinoa Bowl",
      suggestedMealImagePath: "assets/images/risk/quinoa_bowl.png",
      suggestedMealMetric: "25g Saturated Fat",
    ),
    MealSwapModel(
      currentMealName: "Cheese Burger",
      currentMealImagePath: "assets/images/risk/burgerSwap.png",
      currentMealMetric: "90g Saturated Fat",
      suggestedMealName: "Grilled Chicken Wrap",
      suggestedMealImagePath: "assets/images/risk/GrilledChickenWrapSwap.png",
      suggestedMealMetric: "35g Saturated Fat",
    ),
    MealSwapModel(
      currentMealName: "Creamy Pasta",
      currentMealImagePath: "assets/images/risk/PastaSwap.png",
      currentMealMetric: "65g Saturated Fat",
      suggestedMealName: "Veggie Rice Bowl",
      suggestedMealImagePath: "assets/images/risk/VeggieRiceBowlSwap.png",
      suggestedMealMetric: "20g Saturated Fat",
    ),
  ];

  void _nextSwap() {
    setState(() {
      currentSwapIndex = (currentSwapIndex + 1) % mockMealSwaps.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchRisks();
  }

  Future<void> _fetchRisks() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    int years = 1;
    if (selectedPeriod.contains('2')) years = 2;
    if (selectedPeriod.contains('5')) years = 5;
    if (selectedPeriod.contains('10')) years = 10;

    int userId = 7; // Hardcoded for now based on API example

    try {
      final fetchedRisks = await ApiService.predictRisk(userId, years);
      setState(() {
        risks = fetchedRisks;
        isLoading = false;
        if (risks.isEmpty) {
          errorMessage = "No risks found.";
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Failed to fetch risks. Please try again.";
      });
    }
  }

  void _showRiskDetails(RiskModel risk) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RiskDetailSheet(risk: risk),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Bar
              Row(
                children: [
                  /// Back Arrow
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 18),
                    color: AppColors.textMain,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DashboardScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),

                  /// Title
                  Text("Risk Predictor", style: AppTextStyles.header),
                ],
              ),

              const SizedBox(height: 24),

              /// Red Card Container
              Container(
                width: double.infinity,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    /// Left Side: Label and Dropdown
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 12,
                          bottom: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Select Time Period:",
                              style: AppTextStyles.subHeader.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            /// Time Period Dropdown
                            Container(
                              height: 28,
                              width: 133,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedPeriod,
                                  hint: Text(
                                    "Risk Period",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                  isExpanded: true,
                                  menuMaxHeight: 200,
                                  isDense: true,

                                  /// Call backend AI prediction API here
                                  /// using the selected time period and update risks list
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        selectedPeriod = newValue;
                                      });
                                    }
                                  },
                                  items: periods.map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// Right Side: Predict Risks Button (Black Box)
                    GestureDetector(
                      onTap: _fetchRisks,
                      child: Container(
                        width: 120,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                            topLeft: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Predict Risks",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                "Top Predicted Risks",
                style: AppTextStyles.subHeader.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),

              const SizedBox(height: 16),

              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else if (errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      errorMessage!,
                      style: AppTextStyles.subHeader.copyWith(
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: risks.map((risk) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RiskCard(
                          risk: risk,
                          onTap: () => _showRiskDetails(risk),
                        ),
                      );
                    }).toList(),
                  ),
                ),

              const SizedBox(height: 24),

              Text(
                "Suggested Meal Swaps",
                style: AppTextStyles.subHeader.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),

              const SizedBox(height: 16),

              MealSwapCard(
                swap: mockMealSwaps[currentSwapIndex],
                onNext: _nextSwap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

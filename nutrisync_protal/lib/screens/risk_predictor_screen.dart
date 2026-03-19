import 'package:NutriSync/services/risk_service.dart';
import 'package:NutriSync/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/risk_model.dart';
import '../models/contributing_meal_model.dart';
import '../models/meal_swap_model.dart';

class RiskPredictorScreen extends StatefulWidget {
  const RiskPredictorScreen({super.key});

  @override
  State<RiskPredictorScreen> createState() => _RiskPredictorScreenState();
}

class _RiskPredictorScreenState extends State<RiskPredictorScreen> {
  String? selectedPeriod = '1 year';
  int currentSwapIndex = 0;
  bool isLoading = true;

  final List<String> periods = ['1 year', '2 years', '5 years', '10 years'];

  List<RiskModel> risks = [];
  List<MealSwapModel> mealSwaps = [];

  @override
  void initState() {
    super.initState();
    _loadRiskPrediction();
  }

  Future<void> _loadRiskPrediction() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt("userId");

      if (userId == null) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        return;
      }

      int years = int.tryParse(selectedPeriod?.split(' ').first ?? '1') ?? 1;

      final ApiResponse response = await RiskService.getRiskPrediction(
        userId,
        years,
      );

      if (response.status == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final List<dynamic> riskList = data['riskPredictionList'] ?? [];
        final List<dynamic> swapList = data['mealSwapList'] ?? [];

        if (mounted) {
          setState(() {
            risks = riskList.map((r) {
              String probStr =
                  r['probability']?.toString().replaceAll('%', '') ?? '0';
              double riskLvl = (double.tryParse(probStr) ?? 0.0) / 100.0;

              List<dynamic> contribList = r['contibutedMealList'] ?? [];
              List<ContributingMealModel> cMeals = contribList.map((c) {
                return ContributingMealModel(
                  mealName: c['foodName'] ?? 'Unknown Meal',
                  nutrientText: c['contribution'] ?? '',
                  imagePath:
                      c['image'] ?? 'assets/images/risk_predictor/burger.png',
                );
              }).toList();

              return RiskModel(
                name: r['predictedRisk'] ?? 'Unknown Risk',
                description: r['reasonTitle'] ?? '',
                riskLevel: riskLvl,
                icon: Icons.health_and_safety,
                subtitle: 'Based on recent activity & meals',
                warningText: r['warning'] ?? '',
                contributingMeals: cMeals,
              );
            }).toList();

            mealSwaps = swapList.map((s) {
              return MealSwapModel(
                currentMealName: s['riskyMealName'] ?? 'Unknown Meal',
                currentMealImagePath:
                    'assets/images/risk_predictor/burgerSwap.png',
                currentMealMetric: s['riskyMealFact'] ?? '',
                suggestedMealName: s['healthyMealName'] ?? 'Unknown Meal',
                suggestedMealImagePath:
                    'assets/images/risk_predictor/quinoa_bowl.png',
                suggestedMealMetric: s['healthyMealFact'] ?? '',
              );
            }).toList();

            currentSwapIndex = 0;
          });
        }
      } else {
        if (mounted) {
          showModernToast(context, response.message, type: 'error');
        }
      }
    } catch (e) {
      Logger.error("Error loading risk prediction: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _nextSwap() {
    if (mealSwaps.isEmpty) return;
    setState(() {
      currentSwapIndex = (currentSwapIndex + 1) % mealSwaps.length;
    });
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
                    onPressed: () => Navigator.pop(context),
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
                                      _loadRiskPrediction();
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
                      onTap: () {
                        _loadRiskPrediction();
                      },
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

              if (isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else if (risks.isEmpty && mealSwaps.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Text(
                      "No risks to display for this period.",
                      style: TextStyle(color: AppColors.textSub),
                    ),
                  ),
                )
              else ...[
                if (risks.isNotEmpty) ...[
                  Text(
                    "Top Predicted Risks",
                    style: AppTextStyles.subHeader.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                ],

                if (mealSwaps.isNotEmpty) ...[
                  Text(
                    "Suggested Meal Swaps",
                    style: AppTextStyles.subHeader.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  MealSwapCard(
                    swap: mealSwaps[currentSwapIndex],
                    onNext: _nextSwap,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class MealSwapCard extends StatefulWidget {
  final MealSwapModel swap;
  final VoidCallback onNext;

  const MealSwapCard({super.key, required this.swap, required this.onNext});

  @override
  State<MealSwapCard> createState() => _MealSwapCardState();
}

class _MealSwapCardState extends State<MealSwapCard> {
  bool _isExpanded = false;

  @override
  void didUpdateWidget(MealSwapCard oldWidget) {
    if (oldWidget.swap != widget.swap) {
      _isExpanded = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final nameMaxLines = _isExpanded ? null : 3;
    final metricMaxLines = _isExpanded ? null : 4;
    final overflow = _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: IntrinsicColumnWidth(),
              2: FlexColumnWidth(1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.top,
            children: [
              /// IMAGES & SWAP AREA
              TableRow(
                children: [
                  Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          widget.swap.currentMealImagePath,
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 4),
                        const Icon(
                          Icons.arrow_forward,
                          size: 28,
                          color: Colors.teal,
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: widget.onNext,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "Swap Meal",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          widget.swap.suggestedMealImagePath,
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /// GAP
              const TableRow(
                children: [
                  SizedBox(height: 8),
                  SizedBox(height: 8),
                  SizedBox(height: 8),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// NAMES
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.swap.currentMealName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: nameMaxLines,
                  overflow: overflow,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.swap.suggestedMealName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: nameMaxLines,
                  overflow: overflow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// METRICS
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.swap.currentMealMetric,
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                  textAlign: TextAlign.justify,
                  maxLines: metricMaxLines,
                  overflow: overflow,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.swap.suggestedMealMetric,
                  style: const TextStyle(fontSize: 12, color: Colors.green),
                  textAlign: TextAlign.justify,
                  maxLines: metricMaxLines,
                  overflow: overflow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Center(
                child: Text(
                  _isExpanded ? "Hide Details" : "Read More",
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RiskCard extends StatelessWidget {
  final RiskModel risk;
  final VoidCallback onTap;

  const RiskCard({super.key, required this.risk, required this.onTap});

  Color getRiskColor(double value) {
    if (value < 0.3) {
      return Colors.green;
    } else if (value < 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(risk.icon, color: AppColors.secondary),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    risk.name,
                    style: AppTextStyles.subHeader.copyWith(
                      color: AppColors.textMain,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: risk.riskLevel,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation(
                        getRiskColor(risk.riskLevel),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    risk.description,
                    style: AppTextStyles.subHeader.copyWith(
                      color: AppColors.textSub,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RiskDetailSheet extends StatelessWidget {
  final RiskModel risk;

  const RiskDetailSheet({super.key, required this.risk});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// top handle + close
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(Icons.close, color: AppColors.textMain),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// title block
                Text(
                  "Predicted Risk:",
                  style: AppTextStyles.subHeader.copyWith(
                    color: AppColors.textSub,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  risk.name,
                  style: AppTextStyles.header.copyWith(fontSize: 24),
                ),

                const SizedBox(height: 8),

                Text(
                  risk.subtitle,
                  style: AppTextStyles.subHeader.copyWith(
                    color: AppColors.textSub,
                  ),
                ),

                const SizedBox(height: 24),

                /// warning card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          risk.warningText,
                          style: AppTextStyles.subHeader.copyWith(
                            color: AppColors.textMain,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                /// meals title
                Text(
                  "Top Contributed Meals",
                  style: AppTextStyles.subHeader.copyWith(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                /// meals list
                Column(
                  children: risk.contributingMeals.map((meal) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              meal.imagePath,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meal.mealName,
                                  style: AppTextStyles.subHeader.copyWith(
                                    color: AppColors.textMain,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  meal.nutrientText,
                                  style: AppTextStyles.subHeader.copyWith(
                                    color: AppColors.textSub,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

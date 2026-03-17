import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/risk_model.dart';

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
                  risk.predictedRisk,
                  style: AppTextStyles.header.copyWith(fontSize: 24),
                ),

                const SizedBox(height: 8),

                Text(
                  risk.reasonTitle,
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
                          risk.warning,
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
                  children: risk.contibutedMealList.map((meal) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.fastfood,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meal.foodName,
                                  style: AppTextStyles.subHeader.copyWith(
                                    color: AppColors.textMain,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  meal.contribution,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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

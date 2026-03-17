import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/meal_swap_model.dart';

class MealSwapCard extends StatelessWidget {
  final MealSwapModel swap;
  final VoidCallback onNext;

  const MealSwapCard({super.key, required this.swap, required this.onNext});

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        children: [
          /// CURRENT MEAL
          Expanded(
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    swap.currentMealImagePath,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  swap.currentMealName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 4),

                Text(
                  swap.currentMealMetric,
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
          ),

          /// SWAP AREA
          Column(
            children: [
              const Icon(Icons.arrow_forward, size: 28, color: Colors.teal),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: onNext,
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
            ],
          ),

          const SizedBox(width: 12),

          /// SUGGESTED MEAL
          Expanded(
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    swap.suggestedMealImagePath,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  swap.suggestedMealName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 4),

                Text(
                  swap.suggestedMealMetric,
                  style: const TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ),

          /// NEXT ARROW
          IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
        ],
      ),
    );
  }
}

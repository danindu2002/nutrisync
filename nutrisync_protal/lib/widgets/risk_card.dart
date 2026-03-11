import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/risk_model.dart';

class RiskCard extends StatelessWidget {
  final RiskModel risk;
  final VoidCallback onTap;

  const RiskCard({
    super.key,
    required this.risk,
    required this.onTap,
  });

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
              child: Icon(
                risk.icon,
                color: AppColors.secondary,
              ),
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
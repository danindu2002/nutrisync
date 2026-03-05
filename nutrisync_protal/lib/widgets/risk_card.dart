import 'package:flutter/material.dart';
import '../models/risk_model.dart';

class RiskCard extends StatelessWidget {
  final RiskModel risk;

  const RiskCard({super.key, required this.risk});

  Color getRiskColor(double value) {
    if (value < 0.4) {
      return Colors.green;
    } else if (value < 0.7) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          /// Risk Icon
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              risk.icon,
              color: Colors.teal,
              size: 30,
            ),
          ),

          const SizedBox(width: 12),

          /// Risk Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Risk Title
                Text(
                  risk.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                /// Risk Bar
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

                /// Risk Description
                Text(
                  risk.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
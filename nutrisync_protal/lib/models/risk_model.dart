import 'package:flutter/material.dart';
import 'api_meal_contribution_model.dart';
import 'contributing_meal_model.dart'; // keeping this if used elsewhere, else we can remove it

class RiskModel {
  final String predictedRisk;
  final String reasonTitle;
  final double probability;
  final String warning;
  final List<ApiMealContribution> contibutedMealList;

  // Visual/UI helpers not from API directly can be computed or hardcoded per risk type
  final IconData icon;

  RiskModel({
    required this.predictedRisk,
    required this.reasonTitle,
    required this.probability,
    required this.warning,
    required this.contibutedMealList,
    required this.icon,
  });

  factory RiskModel.fromJson(Map<String, dynamic> json) {
    // Parse probability: "38%" -> 0.38
    String probString = json['probability'] ?? '0%';
    double probValue = 0.0;
    if (probString.isNotEmpty) {
      if (probString.endsWith('%')) {
        probString = probString.substring(0, probString.length - 1);
      }
      probValue = (double.tryParse(probString) ?? 0) / 100.0;
    }

    // Map meals list safely
    var mealsList = json['contibutedMealList'] as List?;
    List<ApiMealContribution> parsedMeals = [];
    if (mealsList != null) {
      parsedMeals = mealsList
          .map((m) => ApiMealContribution.fromJson(m as Map<String, dynamic>))
          .toList();
    }

    // Try to guess a good icon based on predefined risk types or fallback
    String name = (json['predictedRisk'] ?? '').toString().toLowerCase();
    IconData riskIcon = Icons.warning_amber_rounded;
    if (name.contains("heart") || name.contains("cholesterol")) {
      riskIcon = Icons.monitor_heart;
    } else if (name.contains("diabet") || name.contains("sugar")) {
      riskIcon = Icons.water_drop;
    } else if (name.contains("obesity") || name.contains("weight")) {
      riskIcon = Icons.balance;
    } else if (name.contains("deficienc")) {
      riskIcon = Icons.health_and_safety;
    }

    return RiskModel(
      predictedRisk: json['predictedRisk'] ?? 'Unknown Risk',
      reasonTitle: json['reasonTitle'] ?? '',
      probability: probValue,
      warning: json['warning'] ?? '',
      contibutedMealList: parsedMeals,
      icon: riskIcon,
    );
  }
}

import 'package:flutter/material.dart';
import 'contributing_meal_model.dart';

class RiskModel {
  final String name;
  final String description;
  final double riskLevel;
  final IconData icon;

  // New fields for popup
  final String subtitle;
  final String warningText;
  final List<ContributingMealModel> contributingMeals;

  RiskModel({
    required this.name,
    required this.description,
    required this.riskLevel,
    required this.icon,
    required this.subtitle,
    required this.warningText,
    required this.contributingMeals,
  });
}
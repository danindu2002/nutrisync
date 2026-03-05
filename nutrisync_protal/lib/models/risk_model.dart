import 'package:flutter/material.dart';

class RiskModel {
  final String name;
  final String description;
  final double riskLevel;
  final IconData icon;

  RiskModel({
    required this.name,
    required this.description,
    required this.riskLevel,
    required this.icon,
  });
}
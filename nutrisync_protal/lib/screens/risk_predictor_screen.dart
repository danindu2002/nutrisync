import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'dashboard_screen.dart';

class RiskPredictorScreen extends StatefulWidget {
  const RiskPredictorScreen({super.key});

  @override
  State<RiskPredictorScreen> createState() => _RiskPredictorScreenState();
}

class _RiskPredictorScreenState extends State<RiskPredictorScreen> {
  String? selectedPeriod;
  final List<String> periods = [
    '6 months',
    '1 year',
    '2 years',
    '5 years',
    '10 years'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
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
                  Text(
                    "Risk Predictor",
                    style: AppTextStyles.header,
                  ),
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
                        padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12),
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
                              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                  icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.black),
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedPeriod = newValue;
                                    });
                                  },
                                  items: periods.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(fontSize: 12, color: Colors.black),
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
                        // Prediction logic goes here
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

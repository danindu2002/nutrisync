import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../services/auth_service.dart';
import '../widgets/common_widgets.dart';

class PremiumSubscriptionScreen extends StatefulWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  State<PremiumSubscriptionScreen> createState() => _PremiumSubscriptionScreenState();
}

class _PremiumSubscriptionScreenState extends State<PremiumSubscriptionScreen> {
  // 0 = 6 months, 1 = 3 months, 2 = 1 month
  int selectedIndex = 0;

  final List<Map<String, dynamic>> packages = [
    {
      "title": "6 months",
      "tag": "SAVE 28%",
      "desc": "You'll begin paying the Regular Plus rate once your current offer expires.",
      "price": "\$5.99/month",
      "days": 180,
    },
    {
      "title": "3 months",
      "tag": null,
      "desc": "You'll begin paying the Regular Plus rate once your current offer expires.",
      "price": "\$6.99/month",
      "days": 90,
    },
    {
      "title": "1 month",
      "tag": null,
      "desc": "You'll begin paying the Regular Plus rate once your current offer expires.",
      "price": "\$7.99/month",
      "days": 30,
    },
  ];

  Future<void> _processPayment() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");

    if (userId == null) {
      showModernToast(context, "User session invalid.", type: 'error');
      return;
    }

    final selectedPackage = packages[selectedIndex];
    final int daysCount = selectedPackage['days'];

    LoadingIndicator.show(context);
    final response = await AuthService.subscribe(userId, daysCount);
    if (mounted) LoadingIndicator.hide(context);

    if (response.success) {
      if (mounted) {
        showModernToast(context, "Welcome to Premium!", type: 'success');
        Navigator.pop(context); // Go back to home screen
      }
    } else {
      if (mounted) {
        showModernToast(context, response.message.isNotEmpty ? response.message : "Payment failed.", type: 'error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: "Join ",
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  children: [
                    TextSpan(
                      text: "Premium",
                      style: TextStyle(color: AppColors.primary), // Uses your Red theme!
                    ),
                    const TextSpan(text: " now!"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Start saving big by choosing the subscription package that fits your needs",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: ListView.builder(
                  itemCount: packages.length,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex == index;
                    final pkg = packages[index];

                    return GestureDetector(
                      onTap: () => setState(() => selectedIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  pkg['title'],
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                if (pkg['tag'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      pkg['tag'],
                                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                const Spacer(),
                                Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              pkg['desc'],
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.4),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              pkg['price'],
                              style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Pay Now Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    "Pay now",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
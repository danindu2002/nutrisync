import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/common_widgets.dart'; // Using your PrimaryButton and AppColors

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Rewards",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [_buildPointsBadge()],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: const [
          RewardCard(
            title: "Premium Feature",
            points: 1000,
            description:
                "Unlock advanced meal planning and personalized recommendations for 1 month.",
            icon: Icons.card_giftcard,
            iconColor: Colors.teal,
            hasEnoughPoints: true,
          ),
          RewardCard(
            title: "Premium Feature",
            points: 200,
            description:
                "Unlock advanced AI based health risk prediction feature for 24 hours.",
            icon: Icons.card_giftcard,
            iconColor: Colors.teal,
            hasEnoughPoints: true,
          ),
          RewardCard(
            title: "Detailed Reports",
            points: 2000,
            description:
                "Access comprehensive nutrition analytics and health reports.",
            icon: Icons.insert_chart,
            iconColor: Colors.indigo,
            hasEnoughPoints: false, // Triggers "Not Enough Points" state
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPointsBadge() {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.stars_rounded, color: Colors.redAccent, size: 18),
            SizedBox(width: 4),
            Text(
              "1240",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RewardCard extends StatelessWidget {
  final String title;
  final int points;
  final String description;
  final IconData icon;
  final Color iconColor;
  final bool hasEnoughPoints;

  const RewardCard({
    super.key,
    required this.title,
    required this.points,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.hasEnoughPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // Blue border for unavailable items as seen in Figma
        border: !hasEnoughPoints
            ? Border.all(color: const Color(0xFF3B82F6), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} points",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ), //
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: AppColors.textSub,
              fontSize: 12,
              height: 1.4,
            ), //
          ),
          const SizedBox(height: 20),

          // Using your PrimaryButton structure but adapting for the "Not Enough Points" state
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: hasEnoughPoints ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasEnoughPoints
                    ? AppColors.primary
                    : AppColors.secondary, //
                disabledBackgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                hasEnoughPoints ? "Claim Reward" : "Not Enough Points",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

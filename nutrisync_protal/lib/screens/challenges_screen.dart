import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/common_widgets.dart'; // Import for PrimaryButton

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  bool isShowingActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      // Custom AppBar to match Figma
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Challenges",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        actions: [
          _buildPointsBadge(), // Points badge from Figma
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Figma-styled Segmented Tab Switcher
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildFigmaTabSwitcher(),
          ),

          const SizedBox(height: 25),

          // Main Content Area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                if (isShowingActive) ..._buildActiveChallenges() else ..._buildAvailableChallenges(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Figma Style: Points badge in the top right
  Widget _buildPointsBadge() {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.stars_rounded, color: Colors.redAccent, size: 18),
            SizedBox(width: 4),
            Text(
              "1240",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Figma Style: Segmented switch with light grey background and red active state
  Widget _buildFigmaTabSwitcher() {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isShowingActive = true),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isShowingActive ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Active",
                  style: TextStyle(
                    color: isShowingActive ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isShowingActive = false),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isShowingActive ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Available",
                  style: TextStyle(
                    color: !isShowingActive ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActiveChallenges() {
    return const [
      ChallengeCard(
        title: "30-Day Calorie Control",
        subtitle: "Stay under 2000 calories daily for 30 days",
        daysLeft: 11,
        points: 500,
        progress: 0.65,
        dayCount: "19/30",
        icon: Icons.fitness_center,
        iconColor: Colors.orange,
        isAvailableView: false,
      ),
      ChallengeCard(
        title: "Hydration Hero",
        subtitle: "Drink 8 glasses of water daily for 7 days",
        daysLeft: 3,
        points: 200,
        progress: 0.85,
        dayCount: "6/7",
        icon: Icons.water_drop,
        iconColor: Colors.blueAccent,
        isAvailableView: false,
      ),
      ChallengeCard(
        title: "Veggies Week",
        subtitle: "Include vegetables in every meal for 7 days",
        daysLeft: 7,
        points: 250,
        progress: 0.0,
        dayCount: "1/7",
        icon: Icons.restaurant,
        iconColor: Colors.green,
        isAvailableView: false,
      ),
    ];
  }

  List<Widget> _buildAvailableChallenges() {
    return const [
      ChallengeCard(
        title: "15-Day Calorie Control",
        subtitle: "Stay under 1000 calories daily for 15 days",
        daysLeft: 15,
        points: 250,
        icon: Icons.fitness_center,
        iconColor: Colors.deepPurple,
        isAvailableView: true,
      ),
      ChallengeCard(
        title: "Sugar Detox Challenge",
        subtitle: "Avoid added sugar for 14 days straight",
        daysLeft: 14,
        points: 800,
        icon: Icons.local_fire_department,
        iconColor: Colors.orange,
        isAvailableView: true,
      ),
    ];
  }
}

class ChallengeCard extends StatelessWidget {
  final String title, subtitle;
  final String? dayCount;
  final int daysLeft, points;
  final double? progress;
  final IconData icon;
  final Color iconColor;
  final bool isAvailableView;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.daysLeft,
    required this.points,
    required this.icon,
    required this.iconColor,
    this.progress,
    this.dayCount,
    required this.isAvailableView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 45, width: 45,
                decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(subtitle, style: TextStyle(color: AppColors.textSub, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _info(Icons.access_time_filled, "$daysLeft days left", AppColors.primary),
              _info(Icons.card_giftcard, "$points points", Colors.orange),
            ],
          ),

          if (!isAvailableView) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress ?? 0.0,
                backgroundColor: AppColors.cardBg,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Day $dayCount", style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
                Text("${((progress ?? 0.0) * 100).toInt()}%", style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              ],
            ),
          ],

          const SizedBox(height: 15),

          PrimaryButton(
              onTap: () {},
              text: isAvailableView ? "Join Challenge" : "Log Progress",
              isRed: true
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

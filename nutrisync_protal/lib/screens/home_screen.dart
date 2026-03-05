import 'package:NutriSync/screens/rewards_screen.dart';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/common_widgets.dart';
import 'challenges_screen.dart';
import 'meal_log_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onMealLogTap;

  const HomeScreen({super.key, required this.onMealLogTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          HomeHeader(),

          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _SectionTitle(title: "Your Metrics"),
                    const SizedBox(height: 12),
                    _MetricsRow(),
                    const SizedBox(height: 24),
                    _SectionTitle(title: "Meal Log"),
                    const SizedBox(height: 12),
                    _MealLogCard(onTap: onMealLogTap),
                    const SizedBox(height: 24),
                    _SectionTitle(title: "Challenges & Rewards"),
                    const SizedBox(height: 12),
                    _ChallengesRow(),
                    const SizedBox(height: 24),
                    _SectionTitle(title: "Health Risks & Impacts"),
                    const SizedBox(height: 12),
                    _NutritionRow(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _MetricsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _MetricCard(title: "Score", value: "88%", color: Colors.red),
        SizedBox(width: 12),
        _MetricCard(title: "Calories", value: "1200", color: Colors.blue),
        SizedBox(width: 12),
        _MetricCard(title: "Challenges", value: "24", color: Colors.grey),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealLogCard extends StatelessWidget {
  final VoidCallback onTap;

  const _MealLogCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          image: const DecorationImage(
            image: AssetImage("assets/images/dashboard/workout.png"),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            /// Dark Gradient Overlay for text readability
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            /// Text Content
            Positioned(
              bottom: 16,
              left: 16,
              right: 60, // Leave space for the action button
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Log Your Meals",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Track your nutrition intake",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            /// Action Indicator (Circular Arrow)
            Positioned(
              bottom: 16,
              right: 16,
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 20,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NutritionCard(
          title: "Daily Challenges",
          subtitle: "Take healthy goals",
          imagePath: "assets/images/dashboard/salad_eggs.png",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChallengesScreen()),
          ),
        ),
        const SizedBox(width: 12),
        _NutritionCard(
          title: "Earn Rewards",
          subtitle: "Prizes Await You",
          imagePath: "assets/images/dashboard/salad_eggs.png",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RewardsScreen()),
          ),
        ),
      ],
    );
  }
}

class _NutritionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NutritionCard(
          title: "Health Risk Predictor",
          subtitle: "Check Your Risk Factors",
          imagePath: "assets/images/dashboard/salad_eggs.png",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChallengesScreen()),
          ),
        ),
        const SizedBox(width: 12),
        _NutritionCard(
          title: "Health Impact Simulator",
          subtitle: "Personal Health Insights",
          imagePath: "assets/images/dashboard/salad_eggs.png",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChallengesScreen()),
          ),
        ),
      ],
    );
  }
}

class _NutritionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final VoidCallback onTap;

  const _NutritionCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        // Wrap with GestureDetector
        onTap: onTap,
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
            ],
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.65),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

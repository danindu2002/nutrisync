import 'package:NutriSync/screens/rewards_screen.dart';
import 'package:NutriSync/screens/risk_predictor_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../services/auth_service.dart';
import '../widgets/common_widgets.dart';
import 'challenges_screen.dart';
import 'impact_simulator/bmi_results_screen.dart';
import 'premium_subscription_screen.dart';
import 'meal_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onMealLogTap;

  const HomeScreen({super.key, required this.onMealLogTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPremium = false;

  // --- NEW: State variables to hold user data ---
  String firstName = "";
  int dailyCalorieGoal = 0;
  int activeChallenges = 0;
  int score = 0;
  dynamic profileImageData;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    await _checkPremiumStatus();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt("userId");

      if (userId == null) return;

      LoadingIndicator.show(context);
      final ApiResponse response = await AuthService.getUserData(userId);
      if (mounted) LoadingIndicator.hide(context);

      if (response.status == 200) {
        final data = response.data;

        final premiumExpireDate = data["premiumExpireDate"];
        await prefs.setString('premiumExpireDate', premiumExpireDate ?? "");

        if (mounted) {
          setState(() {
            firstName = data["firstName"] ?? "User";
            dailyCalorieGoal = data["dailyCalorieGoal"] ?? 0;
            activeChallenges = data["activeChallenges"] ?? 0;
            score = data["score"] ?? 0;
            profileImageData = data["profileImage"];
          });
        }
      }
    } catch (e) {
      Logger.error("Error loading data: $e");
    }
  }

  Future<void> _checkPremiumStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final expireDateStr = prefs.getString('premiumExpireDate');

    if (expireDateStr != null && expireDateStr.isNotEmpty) {
      final expireDate = DateTime.tryParse(expireDateStr);
      if (expireDate != null && expireDate.isAfter(DateTime.now())) {
        setState(() => isPremium = true);
        return;
      }
    }
    setState(() => isPremium = false);
  }

  void _navigateToMealPlan() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("userId");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MealPlanScreen(userId: userId)),
    );
  }

  void _navigateToPremium() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PremiumSubscriptionScreen()),
    );
    _initializeData();
  }

  Future<void> _navigateToRewards() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RewardsScreen()),
    );
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          HomeHeader(
            userName: firstName,
            profileImageData: profileImageData,
            score: score,
          ),

          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const _SectionTitle(title: "Your Metrics"),
                    const SizedBox(height: 12),

                    // --- UPDATED: Pass the fetched metrics down ---
                    _MetricsRow(
                      score: score,
                      calories: dailyCalorieGoal,
                      challenges: activeChallenges,
                    ),

                    const SizedBox(height: 24),
                    const _SectionTitle(title: "Meal Log"),
                    const SizedBox(height: 12),
                    _MealLogCard(onTap: widget.onMealLogTap),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: "Challenges & Rewards"),
                    const SizedBox(height: 12),
                    _ChallengesRow(onRewardsTap: _navigateToRewards),
                    const SizedBox(height: 24),

                    // --- PREMIUM SECTIONS ---
                    const _SectionTitle(title: "Generate Meal Plans"),
                    const SizedBox(height: 12),
                    _MealPlanCard(
                      isPremiumLocked: !isPremium,
                      onTap: () {
                        if (!isPremium) {
                          _navigateToPremium();
                        } else {
                          _navigateToMealPlan();
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: "Health Risks & Impacts"),
                    const SizedBox(height: 12),
                    _NutritionRow(
                      isPremiumLocked: !isPremium,
                      onLockedTap: _navigateToPremium,
                    ),

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
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  final int score;
  final int calories;
  final int challenges;

  const _MetricsRow({
    required this.score,
    required this.calories,
    required this.challenges,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetricCard(title: "Score", value: "$score%", color: Colors.red),
        const SizedBox(width: 12),
        _MetricCard(title: "Calorie Goal", value: "$calories", color: Colors.blue),
        const SizedBox(width: 12),
        _MetricCard(title: "Challenges", value: "$challenges", color: Colors.black54),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MetricCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13.5)),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
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
          image: const DecorationImage(image: AssetImage("assets/images/dashboard/workout.png"), fit: BoxFit.cover),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              bottom: 16, left: 16, right: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Log Your Meals", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Track your nutrition intake", style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            Positioned(
              bottom: 16, right: 16,
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 20,
                child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealPlanCard extends StatelessWidget {
  final bool isPremiumLocked;
  final VoidCallback onTap;

  const _MealPlanCard({super.key, required this.isPremiumLocked, required this.onTap});

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
              fit: BoxFit.cover
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Stack(
          children: [
            // 1. Dark Gradient Overlay (Base)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.7)],
                ),
              ),
            ),

            // 2. NEW: Whitish Disabled Overlay
            if (isPremiumLocked)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white.withOpacity(0.4), // Adjust opacity (0.0 to 1.0) as needed
                ),
              ),

            // 3. Text Content
            Positioned(
              bottom: 16, left: 16, right: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Generate AI Meal Plans",
                      style: TextStyle(
                        // If the overlay makes white text hard to read, you can tint it darker when locked
                          color: isPremiumLocked ? Colors.black87 : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  const SizedBox(height: 4),
                  Text(
                      "Personalized meal plans for your goals",
                      style: TextStyle(
                          color: isPremiumLocked ? Colors.black54 : Colors.white70,
                          fontSize: 14
                      )
                  ),
                ],
              ),
            ),

            // 4. Action Icon / Premium Crown
            Positioned(
              bottom: 16, right: 16,
              child: CircleAvatar(
                backgroundColor: isPremiumLocked ? Colors.amber : AppColors.primary,
                radius: 20,
                child: Icon(
                    isPremiumLocked ? Icons.workspace_premium : Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18
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
  final VoidCallback onRewardsTap;

  const _ChallengesRow({required this.onRewardsTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NutritionCard(
          title: "Daily Challenges", subtitle: "Take healthy goals",
          imagePath: "assets/images/dashboard/salad_eggs.png",
          isPremiumLocked: false,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChallengesScreen())),
        ),
        const SizedBox(width: 12),
        _NutritionCard(
          title: "Earn Rewards", subtitle: "Prizes Await You",
          imagePath: "assets/images/dashboard/salad_eggs.png",
          isPremiumLocked: false,
          onTap: onRewardsTap,
        ),
      ],
    );
  }
}

class _NutritionRow extends StatelessWidget {
  final bool isPremiumLocked;
  final VoidCallback onLockedTap;

  const _NutritionRow({required this.isPremiumLocked, required this.onLockedTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NutritionCard(
          title: "Health Risk Predictor", subtitle: "Check Your Risk Factors",
          imagePath: "assets/images/dashboard/salad_eggs.png",
          isPremiumLocked: isPremiumLocked,
          onTap: () {
            if (isPremiumLocked) {
              onLockedTap();
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RiskPredictorScreen()));
            }
          },
        ),
        const SizedBox(width: 12),
        _NutritionCard(
          title: "Health Impact Simulator", subtitle: "Personal Health Insights",
          imagePath: "assets/images/dashboard/salad_eggs.png",
          isPremiumLocked: isPremiumLocked,
          onTap: () {
            if (isPremiumLocked) {
              onLockedTap();
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const BmiResultsScreen()));
            }
          },
        ),
      ],
    );
  }
}

class _NutritionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isPremiumLocked;
  final VoidCallback onTap;

  const _NutritionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isPremiumLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
          ),
          child: Stack(
            children: [
              // 1. Dark Gradient Overlay (Base)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.15), Colors.black.withOpacity(0.65)],
                  ),
                ),
              ),

              // 2. NEW: Whitish Disabled Overlay
              if (isPremiumLocked)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),

              // 3. Premium Crown Badge (Top Right)
              if (isPremiumLocked)
                Positioned(
                  top: 10, right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                    child: const Icon(Icons.workspace_premium, color: Colors.white, size: 18),
                  ),
                ),

              // 4. Text Content
              Positioned(
                bottom: 12, left: 12, right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        title,
                        style: TextStyle(
                            color: isPremiumLocked ? Colors.black87 : Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    const SizedBox(height: 4),
                    Text(
                        subtitle,
                        style: TextStyle(
                            color: isPremiumLocked ? Colors.black54 : Colors.white70,
                            fontSize: 13
                        )
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
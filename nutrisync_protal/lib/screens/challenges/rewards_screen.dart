import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';
import '../../widgets/common_widgets.dart';
import '../../services/challenge_service.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  bool _isLoading = true;
  int _userPoints = 0;
  List<dynamic> _rewards = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");

    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    // Fetch points and rewards at the same time
    final results = await Future.wait([
      ChallengeService.getUserPoints(userId),
      ChallengeService.getAllRewards(),
    ]);

    if (mounted) {
      setState(() {
        _userPoints = results[0].data ?? 0;
        _rewards = results[1].data ?? [];
        _isLoading = false;
      });
    }
  }

  Future<void> _claimReward(int rewardId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");

    if (userId == null) return;

    LoadingIndicator.show(context);
    final response = await ChallengeService.claimReward(userId, rewardId);
    if (mounted) LoadingIndicator.hide(context);

    if (response.success) {
      showModernToast(context, "Reward claimed successfully!", type: 'success');
      _loadData(); // Refresh the points and the list!
    } else {
      showModernToast(context, response.message.isNotEmpty ? response.message : "Failed to claim reward", type: 'error');
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : _rewards.isEmpty
          ? const Center(child: Text("No rewards available at the moment.", style: TextStyle(color: Colors.grey)))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _rewards.length,
        itemBuilder: (context, index) {
          final reward = _rewards[index];
          final costPoints = reward['costPoints'] as int? ?? 0;
          final hasEnoughPoints = _userPoints >= costPoints;

          return RewardCard(
            title: reward['name'] ?? "Reward",
            points: costPoints,
            description: reward['description'] ?? "",
            icon: Icons.card_giftcard, // You can make this dynamic if your API returns icon types later
            iconColor: Colors.teal,
            hasEnoughPoints: hasEnoughPoints,
            onClaim: () => _claimReward(reward['rewardId']),
          );
        },
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
        child: Row(
          children: [
            const Icon(Icons.stars_rounded, color: Colors.redAccent, size: 18),
            const SizedBox(width: 4),
            Text(
              "$_userPoints",
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
  final VoidCallback onClaim; // Added to handle the button tap

  const RewardCard({
    super.key,
    required this.title,
    required this.points,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.hasEnoughPoints,
    required this.onClaim,
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
        border: !hasEnoughPoints ? Border.all(color: const Color(0xFF3B82F6), width: 1) : null,
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
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(color: AppColors.textSub, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: hasEnoughPoints ? onClaim : null, // Uses the callback if they have points
              style: ElevatedButton.styleFrom(
                backgroundColor: hasEnoughPoints ? AppColors.primary : AppColors.secondary,
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

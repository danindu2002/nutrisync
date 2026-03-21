import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';
import '../../widgets/common_widgets.dart';
import '../../services/challenge_service.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  bool isShowingActive = true;
  bool _isLoading = true;

  int _userPoints = 0;
  List<dynamic> _activeChallenges = [];
  List<dynamic> _availableChallenges = [];

  // Tracks which userChallengeIds have been logged during this app session
  final Set<int> _loggedTodayIds = {};

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  String _getTodayDateString() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");

    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }

    // Load locally saved logged IDs for TODAY
    final todayKey = "logged_challenges_${_getTodayDateString()}";
    final savedLoggedIds = prefs.getStringList(todayKey) ?? [];

    // Convert the saved String list back to a Set of Ints
    _loggedTodayIds.clear();
    _loggedTodayIds.addAll(savedLoggedIds.map((id) => int.parse(id)));

    // Fetch all 3 endpoints concurrently for better performance
    final results = await Future.wait([
      ChallengeService.getUserPoints(userId),
      ChallengeService.getActiveChallenges(userId),
      ChallengeService.getAvailableChallenges(userId),
    ]);

    if (mounted) {
      setState(() {
        _userPoints = results[0].data ?? 0;
        _activeChallenges = results[1].data ?? [];
        _availableChallenges = results[2].data ?? [];
        _isLoading = false;
      });
    }
  }

  Future<void> _handleJoinChallenge(int challengeId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId") ?? 0;

    LoadingIndicator.show(context);
    final response = await ChallengeService.joinChallenge(userId, challengeId);
    if (mounted) LoadingIndicator.hide(context);

    if (response.success) {
      showModernToast(context, "Successfully joined challenge!", type: 'success');
      _loadAllData(); // Refresh lists and points
      setState(() => isShowingActive = true); // Switch to active tab to see it
    } else {
      showModernToast(context, response.message, type: 'error');
    }
  }

  Future<void> _handleLogProgress(int userChallengeId) async {
    LoadingIndicator.show(context);
    final response = await ChallengeService.logProgress(userChallengeId);
    if (mounted) LoadingIndicator.hide(context);

    if (response.success) {
      showModernToast(context, "Progress logged! Keep it up!", type: 'success');

      // Save the ID to SharedPreferences for TODAY
      final prefs = await SharedPreferences.getInstance();
      final todayKey = "logged_challenges_${_getTodayDateString()}";

      // Get existing list, add the new one, and save it back
      final savedLoggedIds = prefs.getStringList(todayKey) ?? [];
      savedLoggedIds.add(userChallengeId.toString());
      await prefs.setStringList(todayKey, savedLoggedIds);

      setState(() {
        _loggedTodayIds.add(userChallengeId); // Disable button locally
      });

      _loadAllData(); // Refresh to get updated daysLeft and progress %
    } else {
      showModernToast(context, response.message, type: 'error');
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Challenges",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        actions: [
          _buildPointsBadge(),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildFigmaTabSwitcher(),
          ),
          const SizedBox(height: 25),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
                : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                if (isShowingActive)
                  ..._buildActiveChallenges()
                else
                  ..._buildAvailableChallenges(),
                const SizedBox(height: 20),
              ],
            ),
          ),
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
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
    if (_activeChallenges.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(child: Text("No active challenges. Join one today!", style: TextStyle(color: Colors.grey))),
        )
      ];
    }

    return _activeChallenges.map((challenge) {
      final userChallengeId = challenge['userChallengeId'] as int;
      final isLoggedToday = _loggedTodayIds.contains(userChallengeId);

      return ChallengeCard(
        title: challenge['challengeName'] ?? "Challenge",
        subtitle: challenge['description'] ?? "",
        daysLeft: challenge['daysLeft'] ?? 0,
        points: challenge['pointsReward'] ?? 0,
        progress: (challenge['progressPercentage'] ?? 0.0) / 100.0,
        dayCount: "${challenge['completedDays']}/${challenge['durationDays']}",
        icon: Icons.emoji_events, // Default icon
        iconColor: Colors.orange,
        isAvailableView: false,
        isActionDisabled: isLoggedToday, // Disable if logged today
        buttonText: isLoggedToday ? "Logged Today" : "Log Progress",
        onActionTap: () => _handleLogProgress(userChallengeId),
      );
    }).toList();
  }

  List<Widget> _buildAvailableChallenges() {
    if (_availableChallenges.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Center(child: Text("No new challenges available right now.", style: TextStyle(color: Colors.grey))),
        )
      ];
    }

    return _availableChallenges.map((challenge) {
      final challengeId = challenge['challengeId'] as int;

      return ChallengeCard(
        title: challenge['name'] ?? "Challenge",
        subtitle: challenge['description'] ?? "",
        daysLeft: challenge['durationDays'] ?? 0,
        points: challenge['pointsReward'] ?? 0,
        icon: Icons.local_fire_department, // Default icon
        iconColor: Colors.deepPurple,
        isAvailableView: true,
        isActionDisabled: false,
        buttonText: "Join Challenge",
        onActionTap: () => _handleJoinChallenge(challengeId),
      );
    }).toList();
  }
}

class ChallengeCard extends StatelessWidget {
  final String title, subtitle, buttonText;
  final String? dayCount;
  final int daysLeft, points;
  final double? progress;
  final IconData icon;
  final Color iconColor;
  final bool isAvailableView;
  final bool isActionDisabled;
  final VoidCallback onActionTap;

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
    required this.isActionDisabled,
    required this.buttonText,
    required this.onActionTap,
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
              _info(Icons.access_time_filled, "$daysLeft days ${isAvailableView ? 'duration' : 'left'}", AppColors.primary),
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

          // Custom button styling to handle Disabled State smoothly
          GestureDetector(
            onTap: isActionDisabled ? null : onActionTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isActionDisabled ? Colors.grey.shade300 : AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                buttonText,
                style: TextStyle(
                  color: isActionDisabled ? Colors.grey.shade600 : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
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
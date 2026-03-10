import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _continue(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', true);

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/questionnaire/welcome.jpg',
            fit: BoxFit.cover,
          ),
          // Dark Overlay (Optional: helps text readability if the image is bright)
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Colors.white70,
                ),
                const SizedBox(height: 24),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Welcome To\n",
                        style: AppTextStyles.welcomeText,
                      ),
                      TextSpan(
                        text: "Nutri",
                        style: AppTextStyles.welcomeText,
                      ),
                      TextSpan(
                        text: "Sync",
                        style: AppTextStyles.welcomeTextRed,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Your personal fitness AI Assistant",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: PrimaryButton(
                    onTap: () => _continue(context),
                    text: "Let's Go",
                    isRed: true,
                  ),
                ),
                // Bottom spacing for better visual balance
                const SizedBox(height: 60),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
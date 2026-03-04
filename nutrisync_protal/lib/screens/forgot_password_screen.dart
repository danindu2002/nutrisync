import 'package:NutriSync/screens/submit_code_screen.dart';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/common_widgets.dart';
import 'confirm_email_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendResetLink() async {
    FocusScope.of(context).unfocus();

    if (_emailController.text.trim().isEmpty) {
      showModernToast(
        context,
        "Please enter your email",
        type: 'error',
      );
      return;
    }

    setState(() => _isLoading = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    await Future.delayed(const Duration(seconds: 2)); // TODO: API call

    if (!mounted) return;

    Navigator.pop(context);
    setState(() => _isLoading = false);

    showModernToast(
      context,
      "Reset link sent successfully!",
      type: 'success',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmEmailScreen(
          email: _emailController.text.trim(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AuthHeader(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Forgot\nPassword",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),
                    Container(width: 40, height: 3, color: Colors.red),

                    const SizedBox(height: 16),

                    const Text(
                      "Enter the email address you used to register",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 24),

                    const InputLabel("Email"),
                    InputField(
                      controller: _emailController,
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _sendResetLink,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Send Reset Link",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Back to Login",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
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

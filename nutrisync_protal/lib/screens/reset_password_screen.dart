import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _changePassword() async {
    FocusScope.of(context).unfocus();

    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      showModernToast(context, "Please fill all fields", type: 'error');
      return;
    }

    if (newPass != confirmPass) {
      showModernToast(context, "Passwords do not match", type: 'error');
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
      "Password changed successfully!",
      type: 'success',
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
                      "Reset\nPassword",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),
                    Container(width: 40, height: 3, color: Colors.red),

                    const SizedBox(height: 16),

                    const Text(
                      "Enter the new password for your account",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 24),

                    const InputLabel("New Password"),
                    InputField(
                      controller: _newPasswordController,
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    const SizedBox(height: 16),

                    const InputLabel("Confirm New Password"),
                    InputField(
                      controller: _confirmPasswordController,
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
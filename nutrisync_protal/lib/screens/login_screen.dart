import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/login_dto.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';
import 'onboarding_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> _submitData() async {
    FocusScope.of(context).unfocus();

    final loginDTO = LoginDTO(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      rememberMe: _rememberMe,
    );

    if (loginDTO.username.isEmpty || loginDTO.password.isEmpty) {
      showModernToast(
        context,
        "Please enter username and password",
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

    // final bool success = await ApiService.onSubmitLogin(loginDTO);
    final bool success = true;

    if (!mounted) return;

    Navigator.pop(context);
    setState(() => _isLoading = false);

    if (success) {
      showModernToast(
        context,
        "Login successfully!",
        type: 'success',
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else {
      showModernToast(
        context,
        "Failed to login. Please try again.",
        type: 'error',
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
              const _LoginHeader(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(width: 40, height: 3, color: Colors.red),

                    const SizedBox(height: 24),

                    /// Username
                    const _InputLabel("Username"),
                    _InputField(
                      controller: _usernameController,
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 16),

                    /// Password
                    const _InputLabel("Password"),
                    _InputField(
                      controller: _passwordController,
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    const SizedBox(height: 12),

                    /// Remember + Forgot
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          activeColor: Colors.red,
                          onChanged: (v) {
                            setState(() => _rememberMe = v ?? false);
                          },
                        ),
                        const Text("Remember Me"),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// Google Sign In
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.g_mobiledata, size: 28),
                      label: const Text("Sign in with Google"),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Login Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Sign Up
                    Center(
                      child: RichText(
                        text: const TextSpan(
                          text: "Don't have an Account? ",
                          style: TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _BottomCurveClipper(),
      child: Container(
        height: 300,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/authentication/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _InputLabel extends StatelessWidget {
  final String text;
  const _InputLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }
}

class _InputField extends StatefulWidget {
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;

  const _InputField({
    required this.icon,
    required this.controller,
    this.isPassword = false,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscure : false,
      decoration: InputDecoration(
        prefixIcon: Icon(widget.icon),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        )
            : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}

class _BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start top-left
    path.lineTo(0, size.height - 20);

    // 🔼 First half curve (upwards)
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height - 80,
      size.width * 0.5,
      size.height - 40,
    );

    // 🔽 Second half curve (downwards)
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height,
      size.width,
      size.height - 20,
    );

    // Finish shape
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}



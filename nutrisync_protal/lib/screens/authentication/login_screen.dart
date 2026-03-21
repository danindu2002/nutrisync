import 'package:NutriSync/screens/authentication/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';
import '../../models/login_dto.dart';
import '../../services/auth_service.dart';
import '../../widgets/common_widgets.dart';
import 'forgot_password_screen.dart';
import '../home/main_navigation_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;

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

    try {
      LoadingIndicator.show(context);

      final ApiResponse response = await AuthService.onSubmitLogin(loginDTO);

      if(mounted) LoadingIndicator.hide(context);

      if (response.status == 200) {
        final token = response.data["accessToken"]["access_token"];
        final userId = response.data["userId"];

        /// Decode JWT
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        final prefs = await SharedPreferences.getInstance();

        /// Save login state
        await prefs.setBool('isLoggedIn', true);
        await prefs.setBool('rememberMe', _rememberMe);

        /// Save token and userId
        await prefs.setString('accessToken', token);
        await prefs.setInt('userId', userId);

        /// Save user info from JWT
        await prefs.setString('name', decodedToken['name'] ?? "");
        await prefs.setString('email', decodedToken['email'] ?? "");
        await prefs.setString('username', decodedToken['preferred_username'] ?? "");

        /// Navigate to dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        );
      } else {
        showModernToast(context, response.message, type: 'error');
      }
    } catch (e) {
      Logger.error("Error occurred: $e");
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
              const AuthHeader(),

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
                    const InputLabel("Username"),
                    InputField(
                      controller: _usernameController,
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 16),

                    /// Password
                    const InputLabel("Password"),
                    InputField(
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            );
                          },
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
                      onPressed: _submitData,
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
                        text: TextSpan(
                          text: "Don't have an Account? ",
                          style: const TextStyle(color: Colors.grey),
                          children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SignUpScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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

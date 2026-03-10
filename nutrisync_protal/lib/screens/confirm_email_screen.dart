import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../services/auth_service.dart';
import '../widgets/common_widgets.dart';
import 'submit_code_screen.dart';

class ConfirmEmailScreen extends StatefulWidget {
  final String email;

  const ConfirmEmailScreen({
    super.key,
    required this.email,
  });

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 30;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  Future<void> _sendResetLink() async {
    FocusScope.of(context).unfocus();

    try {
      LoadingIndicator.show(context);

      final ApiResponse response = await AuthService.sendPasswordResetLink(
        widget.email.trim(),
      );

      if(mounted) LoadingIndicator.hide(context);

      if (response.status == 200) {
        showModernToast(context, response.message, type: 'success');
      } else {
        showModernToast(context, response.message, type: 'error');
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    }
  }

  String _maskEmail(String email) {
    final parts = email.split("@");
    if (parts.length != 2) return email;

    String name = parts[0];
    String domain = parts[1];

    if (name.length <= 2) return email;

    return "${name.substring(0, 2)}****@$domain";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maskedEmail = _maskEmail(widget.email);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.mark_email_read_outlined,
                    color: Colors.green,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Confirm Your Email",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "We’ve sent a one time password to\n$maskedEmail",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 25),

                ElevatedButton(
                  onPressed: _secondsRemaining == 0
                      ? () {
                    _startTimer();
                    _sendResetLink();
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _secondsRemaining == 0
                        ? "Re-Send Password"
                        : "Resend in $_secondsRemaining s",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            SubmitCodeScreen(email: widget.email),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Submit Code",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
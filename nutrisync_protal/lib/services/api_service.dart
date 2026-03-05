import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/login_dto.dart';
import '../models/onboarding_dto.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      // Web works with localhost
      return "http://localhost:8081/api/v1";
    } else if (Platform.isAndroid) {
      // Android Emulator uses 10.0.2.2 to reach the host computer
      return "http://10.0.2.2:8081/api/v1";
    } else {
      // iOS Simulator or other platforms usually support localhost
      return "http://localhost:8081/api/v1";
    }
  }

  static Future<bool> submitOnboardingData(OnboardingDTO data) async {
    final url = Uri.parse('$baseUrl/user/register');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Error: ${response.body}");
        return true;
      }
    } catch (e) {
      print("Exception: $e");
      return true;
    }
  }

  static Future<bool> onSubmitLogin(LoginDTO data) async {
    final url = Uri.parse('$baseUrl/user/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        debugPrint("Login error: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Login exception: $e");
      return false;
    }
  }
}
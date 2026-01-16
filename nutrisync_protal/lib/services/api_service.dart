import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/onboarding_dto.dart';

class ApiService {
  static const String baseUrl = "http://localhost:8081/api/v1";

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
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }
}
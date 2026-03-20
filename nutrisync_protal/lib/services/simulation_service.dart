import 'dart:convert';
import '../core/constants.dart';
import '../widgets/common_widgets.dart';

class SimulationService {
  // Fetch the user's BMI from the backend
  static Future<ApiResponse> getUserBMI(int userId) async {
    try {
      final response = await ApiClient.get("/impact-simulator/userBMI/$userId");
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      Logger.error("Error fetching BMI: $e");
      return ApiResponse(status: 500, message: "Unexpected error occurred", data: 0.0);
    }
  }

  // Simulate the impact of dietary changes on the user's BMI over a specified number of months
  static Future<ApiResponse> simulateImpact(int userId, int months) async {
    try {
      final response = await ApiClient.get("/impact-simulator/simulateImpact/$userId?months=$months");
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      Logger.error("Error fetching simulation: $e");
      return ApiResponse(status: 500, message: "Unexpected error occurred", data: 0.0);
    }
  }
}
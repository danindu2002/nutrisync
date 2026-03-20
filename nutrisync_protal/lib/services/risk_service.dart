import 'dart:convert';
import '../core/constants.dart';
import '../models/login_dto.dart';
import '../models/onboarding_dto.dart';
import '../widgets/common_widgets.dart';

class RiskService {
  static Future<ApiResponse> getRiskPrediction(int userId, int years) async {
    try {
      final response = await ApiClient.post(
        "/risk-predictor/predict-risk/$userId?years=$years",
        null,
      );

      final body = jsonDecode(response.body);
      Logger.info("Response: $body");
      return ApiResponse.fromJson(body);
    } catch (e) {
      Logger.error("An error occurred: $e");
      return ApiResponse(
        status: 500,
        message: "Unexpected error occurred",
        data: null,
      );
    }
  }

  static Future<ApiResponse> getUserData(int userId) async {
    try {
      final response = await ApiClient.get("/user/userDetails/$userId");

      final body = jsonDecode(response.body);
      Logger.info("Response: $body");
      return ApiResponse.fromJson(body);
    } catch (e) {
      Logger.error("An error occurred: $e");
      return ApiResponse(status: 500, message: "An error occurred", data: null);
    }
  }
}

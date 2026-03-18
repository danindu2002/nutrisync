import 'dart:convert';
import '../core/constants.dart';
import '../widgets/common_widgets.dart';

class DashboardService {
  static Future<ApiResponse> getCaloriesChart({
    required int userId,
    required String range,
  }) async {
    try {
      final response = await ApiClient.get(
        "/dashboard/calories?userId=$userId&range=$range",
      );

      final body = jsonDecode(response.body);
      Logger.info("Calories Chart Response: $body");
      return ApiResponse.fromJson(body);
    } catch (e) {
      Logger.error("An error occurred while fetching calories chart: $e");
      return ApiResponse(
        status: 500,
        message: "Unexpected error occurred",
        data: null,
      );
    }
  }
}
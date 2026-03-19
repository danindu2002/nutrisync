import 'dart:io';
import 'dart:convert';
import '../core/constants.dart';
import '../models/update_meal_dto.dart';
import '../widgets/common_widgets.dart';

class MealService {
  // This method sends the image file to the backend for meal identification
  static Future<ApiResponse> identifyMeal(File imageFile) async {
    try {
      // Note: "file" is the key the backend expects for the image file
      final response = await ApiClient.multipartUpload(
        "/meal/identify",
        imageFile,
        "image",
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

  // This method logs the meal with the image and additional data
  static Future<ApiResponse> logMeal(File imageFile, Map<String, dynamic> dataJson) async {
    try {
      final response = await ApiClient.multipartUpload(
          "/meal/log",
          imageFile,
          "image",
          fields: {
            "data": jsonEncode(dataJson)
          }
      );
      final body = jsonDecode(response.body);
      Logger.info("Add Meal Response: $body");
      return ApiResponse.fromJson(body);
    } catch (e) {
      Logger.error("An error occurred logging meal: $e");
      return ApiResponse(
        status: 500,
        message: "Unexpected error occurred",
        data: null,
      );
    }
  }

  // This method fetches meal logs for a specific user on a specific date
  static Future<ApiResponse> getMealLogs(int userId, String date) async {
    try {
      final response = await ApiClient.get("/meal/getLogs?userId=$userId&date=$date");

      final body = jsonDecode(response.body);

      return ApiResponse.fromJson(body);
    } catch (e) {
      Logger.error("An error occurred fetching meal logs: $e");
      return ApiResponse(
        status: 500,
        message: "Unexpected error occurred",
        data: [],
      );
    }
  }

  // This method deletes a meal log by its logId
  static Future<ApiResponse> deleteMealLog(int logId) async {
    try {
      final response = await ApiClient.delete(
        "/meal/delete",
        data: {
          "logId": logId,
        },
      );

      final body = jsonDecode(response.body);
      Logger.info("Delete Meal Log Response: $body");

      return ApiResponse.fromJson(body);
    } catch (e) {
      Logger.error("An error occurred deleting meal: $e");
      return ApiResponse(
        status: 500,
        message: "Unexpected error occurred",
        data: null,
      );
    }
  }
    
  static Future<ApiResponse> updateMealNutrition(UpdateMealDto data) async {
    try {
      final response = await ApiClient.put(
        "/meal/updateNutrition",
        data.toJson(),
        requiresAuth: true,
      );
      final body = jsonDecode(response.body);
      Logger.info("Meal Update Response: $body");
      return ApiResponse.fromJson(body);
    } catch (e) {
      Logger.error("Meal Update Error: $e");
      return ApiResponse(
        status: 500,
        message: "An unexpected error occurred while updating the meal.",
        data: null,
      );
    }
  }
}

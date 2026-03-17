import 'dart:convert';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../models/update_meal_dto.dart';
import '../widgets/common_widgets.dart';

class MealService {
  static Future<ApiResponse> updateMealNutrition(UpdateMealDto data) async {
    try {
      final response = await ApiClient.put(
        "/meal/updateNutrition",
        data.toJson(),
        requiresAuth: true,
      );
      final body = jsonDecode(response.body);
      debugPrint("Meal Update Response: $body");
      return ApiResponse.fromJson(body);
    } catch (e) {
      debugPrint("Meal Update Error: $e");
      return ApiResponse(
        status: 500,
        message: "An unexpected error occurred while updating the meal.",
        data: null,
      );
    }
  }
}

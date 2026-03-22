import 'dart:convert';
import '../core/constants.dart';
import '../widgets/common_widgets.dart';
import 'pexels_image_service.dart'; // Import the new service!

class DietPlanService {

  static Future<ApiResponse> getDietPlans(int? userId) async {
    try {
      final response = await ApiClient.get('/diet-plan/user/$userId');
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ApiResponse(status: 500, message: "Failed to load diet plans");
    }
  }

  // Generate Preview & Fetch Pexels Images
  static Future<ApiResponse> generatePlanPreview(int userId) async {
    try {
      final response = await ApiClient.post('/diet-plan/preview?userId=$userId', {});
      final apiRes = ApiResponse.fromJson(jsonDecode(response.body));

      if (apiRes.success && apiRes.data != null) {
        var weeklyPlan = apiRes.data['weeklyPlan'] as List<dynamic>? ?? [];

        PexelsImageService.resetAvailability();

        for (var day in weeklyPlan) {
          var meals = day['meals'] as List<dynamic>? ?? [];
          for (var meal in meals) {

            if (PexelsImageService.isUnavailable) {
              meal['mealImageUrl'] = "https://via.placeholder.com/150";
              continue;
            }

            String rawTerm = meal['imageSearchTerm'] ?? meal['recipeName'] ?? 'healthy food';
            String optimizedTerm = _sanitizeForPexels(rawTerm);
            String? pexelsUrl = await PexelsImageService.fetchImage(optimizedTerm);

            meal['mealImageUrl'] = pexelsUrl ?? "https://via.placeholder.com/150";
          }
        }
      }
      return apiRes;
    } catch (e) {
      Logger.error("Error generating plan preview: $e");
      return ApiResponse(status: 500, message: "Error generating plan");
    }
  }

  static String _sanitizeForPexels(String query) {
    String cleanQuery = query.replaceAll(RegExp(r'[^a-zA-Z\s]'), '').trim();
    List<String> words = cleanQuery.split(RegExp(r'\s+'));
    String shortTerm = words.take(3).join(' ').toLowerCase();

    if (shortTerm.contains('chicken') || shortTerm.contains('beef') || shortTerm.contains('pork') || shortTerm.contains('fish')) {
      shortTerm = "${words[0]} meal";
    }

    if (shortTerm.isEmpty || shortTerm.length < 3) {
      return 'healthy meal';
    }
    return shortTerm;
  }

  static Future<ApiResponse> saveDietPlan(Map<String, dynamic> planData) async {
    try {
      final response = await ApiClient.post('/diet-plan/save', planData);
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ApiResponse(status: 500, message: "Failed to save plan");
    }
  }

  static Future<ApiResponse> updatePlanMetadata(int planId, Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.put('/diet-plan/$planId', data);
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ApiResponse(status: 500, message: "Failed to update plan");
    }
  }

  static Future<ApiResponse> getDietPlanDetails(int planId) async {
    try {
      final response = await ApiClient.get('/diet-plan/$planId');
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ApiResponse(status: 500, message: "Failed to load plan details");
    }
  }

  static Future<ApiResponse> deleteDietPlan(int planId) async {
    try {
      final response = await ApiClient.delete('/diet-plan/$planId');
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      Logger.error("Error deleting diet plan: $e");
      return ApiResponse(status: 500, message: "Failed to delete plan");
    }
  }
}
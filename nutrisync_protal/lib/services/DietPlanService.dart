import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../widgets/common_widgets.dart';

class DietPlanService {
  static const String pexelsApiKey = "tMcRzsieU3qRFOycTM3hUDQQ2S2sNYixEKB9W6aqh9wj6FKeGmAXkL7q";

  static Future<ApiResponse> getDietPlans(int? userId) async {
    try {
      final response = await ApiClient.get('/diet-plan/user/$userId');
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return ApiResponse(status: 500, message: "Failed to load diet plans");
    }
  }

  // 2. Generate Preview & Fetch Pexels Images (NOW RUNS IN PARALLEL)
  static Future<ApiResponse> generatePlanPreview(int userId) async {
    try {
      final response = await ApiClient.post('/diet-plan/preview?userId=$userId', {});
      final apiRes = ApiResponse.fromJson(jsonDecode(response.body));

      if (apiRes.success && apiRes.data != null) {
        var weeklyPlan = apiRes.data['weeklyPlan'] as List<dynamic>? ?? [];

        // List to hold all our async image fetch operations
        List<Future<void>> pexelsTasks = [];

        for (var day in weeklyPlan) {
          var meals = day['meals'] as List<dynamic>? ?? [];
          for (var meal in meals) {

            // Add the fetch task to the list INSTEAD of waiting for it sequentially
            pexelsTasks.add((() async {
              String searchTerm = meal['imageSearchTerm'] ?? meal['recipeName'] ?? 'healthy food';
              String? pexelsUrl = await _fetchPexelsImage(searchTerm);
              meal['mealImageUrl'] = pexelsUrl ?? "https://via.placeholder.com/150";
            })());

          }
        }

        // Wait for ALL image requests to finish concurrently (takes ~1 second total instead of 15 seconds)
        await Future.wait(pexelsTasks);
      }
      return apiRes;
    } catch (e) {
      Logger.error("Error generating plan preview: $e");
      return ApiResponse(status: 500, message: "Error generating plan");
    }
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

  // --- Private Helper for Pexels ---
  static Future<String?> _fetchPexelsImage(String query) async {
    try {
      // Added a strict timeout to ensure the UI NEVER hangs endlessly on a bad connection
      final response = await http.get(
        Uri.parse('https://api.pexels.com/v1/search?query=$query&per_page=1'),
        headers: {'Authorization': pexelsApiKey},
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['photos'] != null && data['photos'].isNotEmpty) {
          return data['photos'][0]['src']['medium'];
        }
      }
    } catch (e) {
      Logger.error("Pexels fetch error: $e");
    }
    return null;
  }
}
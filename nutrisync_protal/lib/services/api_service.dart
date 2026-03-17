import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/login_dto.dart';
import '../models/onboarding_dto.dart';
import '../models/risk_model.dart';

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

  static Future<List<RiskModel>> predictRisk(int userId, int years) async {
    final url = Uri.parse(
      '$baseUrl/risk-predictor/predict-risk/$userId?years=$years',
    );

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // The API wraps the risks in an object, but based on the example
        // it seems to return an array at a specific key OR it's a list.
        // Looking at the top of the User's sample:
        // {
        //   "data": { ... list of items in some property or directly it's "data": [ ... ] }
        //   "message": "Risk Predicted Successfully",
        //   "status": 200
        // }

        if (decoded['status'] == 200) {
          var data = decoded['data'];
          // The top level data object seems to have a list of risks as an array or inside a field?
          // The sample was:
          // [
          //   { "predictedRisk": ... }
          // ], mealSwapList:[]
          // Let's assume `data` is a map with a `riskPredictList` or it just sends back an array directly in data if it's not a map

          List<dynamic> listToParse = [];
          if (data is Map<String, dynamic>) {
            if (data.containsKey('riskPredictList')) {
              listToParse = data['riskPredictList'];
            } else if (data.containsKey('risks')) {
              listToParse = data['risks'];
            } else {
              var possibleList = data.values.firstWhere(
                (v) => v is List,
                orElse: () => null,
              );
              if (possibleList != null) {
                listToParse = possibleList as List;
              }
            }
          } else if (data is List) {
            listToParse = data;
          }

          return listToParse.map((json) => RiskModel.fromJson(json)).toList();
        } else {
          debugPrint(
            "Predict risk error: ${response.statusCode} - ${response.body}",
          );
        }
        return [];
      }
      return [];
    } catch (e) {
      if (kIsWeb) {
        debugPrint(
          "Predict risk exception: $e. "
          "If this is a 'Failed to fetch' error, it's likely a CORS issue. "
          "Try running with: flutter run -d chrome --web-browser-flag \"--disable-web-security\"",
        );
      } else {
        debugPrint("Predict risk exception: $e");
      }
      return [];
    }
  }
}

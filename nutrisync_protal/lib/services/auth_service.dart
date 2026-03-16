import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../core/constants.dart';
import '../models/login_dto.dart';
import '../models/onboarding_dto.dart';
import '../widgets/common_widgets.dart';

class AuthService {

  static Future<ApiResponse> submitOnboardingData(OnboardingDTO data) async {
    try {
      final response = await ApiClient.post(
        "/user/register",
        data.toJson(),
        requiresAuth: false,
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

  static Future<ApiResponse> onSubmitLogin(LoginDTO data) async {
    try {
      final response = await ApiClient.post(
        "/user/login",
        data.toJson(),
        requiresAuth: false,
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

  static Future<ApiResponse> getUserProfile(int userId) async {
    try {
      final response = await ApiClient.get("/user/getProfile/$userId");

      final body = jsonDecode(response.body);
      Logger.info("Response: $body");
      return ApiResponse.fromJson(body);
    } catch (e) {
      Logger.error("An error occurred: $e");
      return ApiResponse(
        status: 500,
        message: "An error occurred",
        data: null,
      );
    }
  }

  static Future<ApiResponse> sendPasswordResetLink(String email) async {
    try {
      final response = await ApiClient.post(
        "/user/forgotPassword?email=$email", null);

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

  static Future<ApiResponse> validateResetToken(dynamic data) async {
    try {
      final response = await ApiClient.post("/user/validateForgotPwdOtp", data);

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

  static Future<ApiResponse> resetPassword(dynamic data) async {
    try {
      final response = await ApiClient.post("/user/resetForgotPwd", data);

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

  static Future<ApiResponse> subscribe(int userId, int daysCount) async {
    try {
      final response = await ApiClient.post(
        "/user/subscribePremium",
        {
          "userId": userId,
          "daysCount": daysCount,
        },
        requiresAuth: false,
      );
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      Logger.error("Error subscribing: $e");
      return ApiResponse(status: 500, message: "Unexpected error occurred");
    }
  }
}


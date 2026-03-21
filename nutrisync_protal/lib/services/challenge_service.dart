import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../widgets/common_widgets.dart';

class ChallengeService {
  // Fetch all active challenges for the user
  static Future<ApiResponse> getActiveChallenges(int userId) async {
    try {
      final response = await ApiClient.get("/challenges/active/$userId");
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      Logger.error("Error fetching active challenges: $e");
      return ApiResponse(status: 500, message: "Error fetching data");
    }
  }

  // Fetch all available challenges that the user can join
  static Future<ApiResponse> getAvailableChallenges(int userId) async {
    try {
      final response = await ApiClient.get("/challenges/available/$userId");
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      Logger.error("Error fetching available challenges: $e");
      return ApiResponse(status: 500, message: "Error fetching data");
    }
  }

  // Fetch user's current points
  static Future<ApiResponse> getUserPoints(int userId) async {
    try {
      final response = await ApiClient.get("/challenges/user-points/$userId");
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      Logger.error("Error fetching points: $e");
      return ApiResponse(status: 500, message: "Error fetching data", data: 0);
    }
  }

  // Join a specific challenge
  static Future<ApiResponse> joinChallenge(int userId, int challengeId) async {
    try {
      final response = await ApiClient.post(
        "/challenges/join",
        {"userId": userId, "challengeId": challengeId},
      );
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      Logger.error("Error joining challenge: $e");
      return ApiResponse(status: 500, message: "Unexpected error occurred");
    }
  }

  // Log progress for a specific challenge
  static Future<ApiResponse> logProgress(int userChallengeId) async {
    try {
      final response = await ApiClient.post(
        "/challenges/log-progress",
        {"userChallengeId": userChallengeId},
      );
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      Logger.error("Error logging progress: $e");
      return ApiResponse(status: 500, message: "Unexpected error occurred");
    }
  }

  // Fetch all available rewards
  static Future<ApiResponse> getAllRewards() async {
    try {
      final response = await ApiClient.get("/rewards/all");
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      debugPrint("Error fetching rewards: $e");
      return ApiResponse(status: 500, message: "Error fetching rewards");
    }
  }

  // Claim a specific reward
  static Future<ApiResponse> claimReward(int userId, int rewardId) async {
    try {
      final response = await ApiClient.post(
        "/rewards/claim",
        {
          "userId": userId,
          "rewardId": rewardId,
        },
      );
      return ApiResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      debugPrint("Error claiming reward: $e");
      return ApiResponse(status: 500, message: "Unexpected error occurred");
    }
  }
}
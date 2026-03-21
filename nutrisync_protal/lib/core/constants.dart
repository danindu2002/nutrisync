import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/authentication/login_screen.dart';
import '../screens/home/main_navigation_screen.dart';

// API Constants to handle different environments (web, Android, iOS)
class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      /// Local Environment Base URL
      return "http://localhost:8081/api/v1";
      /// Production Environment Base URL
      // return "http://213.35.115.255:8081/api/v1";
    } else if (Platform.isAndroid) {
      return "http://10.0.2.2:8081/api/v1";
    } else {
      return "http://localhost:8081/api/v1";
    }
  }
}

// A simple API client to handle HTTP requests
class ApiClient {
  static Future<Map<String, String>> getHeaders({
    bool requiresAuth = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");

    final headers = {"Content-Type": "application/json"};

    if (requiresAuth && token != null) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  /// Handle token expiration by clearing stored credentials and navigating to login screen
  static Future<void> _handleTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("accessToken");
    await prefs.setBool("rememberMe", false);

    final context = NavigationService.navigatorKey.currentContext;

    if (context != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
      );
    }
    debugPrint("Token expired → user logged out");
  }

  /// GET
  static Future<http.Response> get(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse("${ApiConstants.baseUrl}$endpoint");

    final response = await http.get(
      url,
      headers: await getHeaders(requiresAuth: requiresAuth),
    );
    // TOKEN EXPIRED
    if (response.statusCode == 405) {
      await _handleTokenExpired();
    }
    return response;
  }

  /// POST
  static Future<http.Response> post(
      String endpoint,
      dynamic data, {
        bool requiresAuth = true,
      }) async {
    final url = Uri.parse("${ApiConstants.baseUrl}$endpoint");

    final headers = await getHeaders(requiresAuth: requiresAuth);
    final response = await http.post(
      url,
      headers: headers,
      body: data != null ? jsonEncode(data) : null,
    );
    // TOKEN EXPIRED
    if (response.statusCode == 405) {
      await _handleTokenExpired();
    }
    return response;
  }

  /// PUT
  static Future<http.Response> put(
    String endpoint,
    dynamic data, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse("${ApiConstants.baseUrl}$endpoint");

    final response = await http.put(
      url,
      headers: await getHeaders(requiresAuth: requiresAuth),
      body: jsonEncode(data),
    );
    // TOKEN EXPIRED
    if (response.statusCode == 405) {
      await _handleTokenExpired();
    }
    return response;
  }

  /// DELETE
  static Future<http.Response> delete(
      String endpoint, {
        dynamic data,
        bool requiresAuth = true,
      }) async {
    final url = Uri.parse("${ApiConstants.baseUrl}$endpoint");

    final response = await http.delete(
      url,
      headers: await getHeaders(requiresAuth: requiresAuth),
      body: data != null ? jsonEncode(data) : null,
    );

    // TOKEN EXPIRED
    if (response.statusCode == 405) {
      await _handleTokenExpired();
    }
    return response;
  }

  /// MULTIPART (For File Uploads)
  static Future<http.Response> multipartUpload(
      String endpoint,
      File file,
      String fileField, {
        Map<String, String>? fields,
        bool requiresAuth = true,
        String method = "POST",
      }) async {
    final url = Uri.parse("${ApiConstants.baseUrl}$endpoint");

    final request = http.MultipartRequest(method, url);

    final headers = await getHeaders(requiresAuth: requiresAuth);
    headers.remove("Content-Type");
    request.headers.addAll(headers);

    request.files.add(
      await http.MultipartFile.fromPath(fileField, file.path),
    );
    if (fields != null) {
      request.fields.addAll(fields);
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 405) {
      await _handleTokenExpired();
    }
    return response;
  }
}

// A simple API response model to standardize responses from the server
class ApiResponse {
  final int status;
  final String message;
  final dynamic data;

  ApiResponse({required this.status, required this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  bool get success => status >= 200 && status < 300;
}

// A centralized class to manage all app colors for consistency across the app
class AppColors {
  static const Color primary = Color(0xFFEF4444); // Red
  static const Color secondary = Color(0xFF393C43); // Dark Grey
  static const Color background = Color(0xFFFFFFFF); // White
  static const Color cardBg = Color(0xFFF4F4F4); // Light grey
  static const Color textMain = Color(0xFF1F2937);
  static const Color textSub = Color(0xFF6B7280);
}

// A centralized class to manage all text styles for consistency across the app
class AppTextStyles {
  static final TextStyle header = GoogleFonts.workSans(
    fontSize: 26,
    letterSpacing: -0.5,
    fontWeight: FontWeight.bold,
    color: AppColors.textMain,
  );

  static final TextStyle welcomeText = GoogleFonts.workSans(
    fontSize: 32,
    letterSpacing: -0.5,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle welcomeTextRed = GoogleFonts.workSans(
    fontSize: 32,
    letterSpacing: -0.5,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static final TextStyle subHeader = GoogleFonts.workSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSub,
  );

  static final TextStyle buttonText = GoogleFonts.workSans(
    fontSize: 18,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );
}

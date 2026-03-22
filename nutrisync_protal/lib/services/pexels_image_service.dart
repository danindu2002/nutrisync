import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/common_widgets.dart';

class PexelsImageService {
  static const String _pexelsApiKey = "tMcRzsieU3qRFOycTM3hUDQQ2S2sNYixEKB9W6aqh9wj6FKeGmAXkL7q";

  // 1. Persistent HTTP Client: Reuses the same network socket for all requests.
  // This completely stops the Android emulator from dropping connections.
  static final http.Client _httpClient = http.Client();

  // 2. Short-Circuit Flag: If Pexels blocks us or times out, we instantly stop spamming it.
  static bool _pexelsUnavailable = false;

  // Getter so other services can check if they should skip fetching
  static bool get isUnavailable => _pexelsUnavailable;

  // Reset the flag before a new batch of requests (e.g., when generating a new plan)
  static void resetAvailability() {
    _pexelsUnavailable = false;
  }

  static Future<String?> fetchImage(String query) async {
    try {
      // Increased timeout to 10 seconds. 3 seconds is too fast for an emulator.
      final response = await _httpClient.get(
        Uri.parse('https://api.pexels.com/v1/search?query=$query&per_page=1'),
        headers: {'Authorization': _pexelsApiKey},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['photos'] != null && data['photos'].isNotEmpty) {
          return data['photos'][0]['src']['medium'];
        }
      } else if (response.statusCode == 429) {
        // HTTP 429 = Too Many Requests. You hit the 200/hr limit!
        Logger.error("Pexels Blocked Us! Rate Limit Hit (429).");
        _pexelsUnavailable = true; // Trigger short-circuit
      } else {
        Logger.error("Pexels returned an error code: ${response.statusCode}");
      }
    } catch (e) {
      Logger.error("Pexels fetch error: $e");
      _pexelsUnavailable = true;
    }
    return null;
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../models/resume_result.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000"; // change to Render URL later

  static Future<ResumeResult?> analyzeCV({
    required PlatformFile file,
    String? jobDescription,
    String? keywords,
    String? weights,
  }) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse("$baseUrl/upload-resume"));

      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          file.bytes!,
          filename: file.name,
        ),
      );

      if (jobDescription != null && jobDescription.trim().isNotEmpty) {
        request.fields["job_description"] = jobDescription;
      }

      if (keywords != null && keywords.trim().isNotEmpty) {
        // Backend expects keywords_json if sending keywords directly
        var keywordsList = keywords.split(",").map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        var keywordsMap = {for (var kw in keywordsList) kw: 1}; // default weight 1
        request.fields["keywords_json"] = jsonEncode(keywordsMap);
      }

      if (weights != null && weights.trim().isNotEmpty) {
        var weightsMap = _parseWeights(weights);
        request.fields["custom_weights"] = jsonEncode(weightsMap);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return ResumeResult.fromJson(jsonDecode(response.body), file.name);
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  static Map<String, int> _parseWeights(String weights) {
    var map = <String, int>{};
    var entries = weights.split(",");
    for (var entry in entries) {
      var parts = entry.split(":");
      if (parts.length == 2) {
        var key = parts[0].trim();
        var value = int.tryParse(parts[1].trim()) ?? 1;
        map[key] = value;
      }
    }
    return map;
  }
}

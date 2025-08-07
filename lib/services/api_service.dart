import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import '../models/resume_result.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class ApiService {
  static final String baseUrl = kIsWeb
  ? 'https://resume-scanner-backend-4jef.onrender.com'
  : dotenv.env['API_URL'] ?? 'http://localhost:8000';


  static Future<ResumeResult?> analyzeCV({
    required PlatformFile file,
    String? jobDescription,
    String? keywords,
    String? weights,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload-resume'),
      );

      // Attach CV file depending on platform
      if (kIsWeb) {
        // Web → Use bytes
        if (file.bytes == null) {
          print("❌ Error: File bytes are null on Web.");
          return null;
        }
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          file.bytes as Uint8List,
          filename: file.name,
        ));
      } else {
        // Mobile/Desktop → Use path
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path!,
          filename: file.name,
        ));
      }

      // Optional fields
      if (jobDescription != null && jobDescription.trim().isNotEmpty) {
        request.fields['job_description'] = jobDescription;
      }
      if (keywords != null && keywords.trim().isNotEmpty) {
        // Convert CSV keywords to JSON { "keyword": weight }
        final keywordList = keywords.split(',').map((e) => e.trim()).toList();
        final Map<String, int> keywordMap = {
          for (var k in keywordList) k: 3
        };
        request.fields['keywords_json'] = jsonEncode(keywordMap);
      }
      if (weights != null && weights.trim().isNotEmpty) {
        // Expecting "python: 3, sql: 2"
        final Map<String, int> weightMap = {};
        weights.split(',').forEach((pair) {
          var parts = pair.split(':');
          if (parts.length == 2) {
            weightMap[parts[0].trim()] = int.tryParse(parts[1].trim()) ?? 1;
          }
        });
        request.fields['custom_weights'] = jsonEncode(weightMap);
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return ResumeResult.fromJson(jsonData, file.name);
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }
}


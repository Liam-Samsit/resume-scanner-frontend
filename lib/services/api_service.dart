import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/resume_analysis.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static final String baseUrl = kDebugMode
      ? "http://127.0.0.1:8000"
      : "https://your-backend.onrender.com";

  static Future<ResumeAnalysis> uploadResume({
    required Uint8List fileBytes,
    required String fileName,
    String jobDescription = "",
    String keywords = "",
    String customWeights = "",
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload-resume'),
    );

    // File
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: fileName,
      contentType: MediaType(
        fileName.toLowerCase().endsWith('.pdf') ? 'application' : 'application',
        fileName.toLowerCase().endsWith('.pdf')
            ? 'pdf'
            : 'vnd.openxmlformats-officedocument.wordprocessingml.document',
      ),
    ));

    // Job description (optional)
    if (jobDescription.isNotEmpty) {
      request.fields['job_description'] = jobDescription;
    }

    // Keywords JSON (optional) - backend expects a dict, so we wrap in {}
    if (keywords.isNotEmpty) {
      List<String> words = keywords
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      Map<String, List<String>> keywordMap = {"keywords": words};
      request.fields['keywords_json'] = jsonEncode(keywordMap);
    }

    // Custom weights (optional, already formatted in upload_screen)
    if (customWeights.isNotEmpty) {
      request.fields['custom_weights'] = customWeights;
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return ResumeAnalysis.fromJson(jsonDecode(response.body));
    } else {
      String backendMessage;
      try {
        backendMessage = jsonDecode(response.body)['error'] ?? "Unknown error";
      } catch (_) {
        backendMessage = response.body;
      }
      throw Exception(backendMessage);
    }
  }
}

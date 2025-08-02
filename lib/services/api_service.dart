import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../models/resume_analysis.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart'; // <-- import for kDebugMode

class ApiService {
  static final String baseUrl = kDebugMode
      ? "http://127.0.0.1:8000" // Local FastAPI during dev
      : "https://your-backend.onrender.com"; // Change to Render URL when deployed

  static Future<ResumeAnalysis> uploadResume({
    required Uint8List fileBytes,
    required String fileName,
    required String jobDescription,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload-resume'),
    );

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

    request.fields['job_description'] = jobDescription;

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return ResumeAnalysis.fromJson(jsonDecode(response.body));
    } else {
      // Pass backend error message to frontend
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

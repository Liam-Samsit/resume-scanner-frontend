import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/api_service.dart';
import '../models/resume_analysis.dart';
import 'results_screen.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  PlatformFile? pickedFile;
  String jobDescription = "";
  bool isLoading = false;
  String? errorMessage;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
      withData: true, // Important: ensure file bytes are included
    );

    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
    }
  }

  Future<void> uploadData() async {
  if (pickedFile == null || jobDescription.trim().isEmpty) {
    setState(() {
      errorMessage = "Please select a resume and enter a job description.";
    });
    return;
  }

  setState(() {
    isLoading = true;
    errorMessage = null;
  });

  try {
    ResumeAnalysis analysis = await ApiService.uploadResume(
      fileBytes: pickedFile!.bytes as Uint8List,
      fileName: pickedFile!.name,
      jobDescription: jobDescription,
    );

    setState(() {
      isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsScreen(analysis: analysis),
      ),
    );
  } catch (e) {
    setState(() {
      isLoading = false;
      errorMessage = e.toString().replaceFirst("Exception: ", ""); // clean message
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resume Scanner"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: Text(
                pickedFile == null
                    ? "Pick Resume File"
                    : "Selected: ${pickedFile!.name}",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: "Job Description",
                border: OutlineInputBorder(),
              ),
              minLines: 4,
              maxLines: 8,
              onChanged: (value) => jobDescription = value,
            ),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Color.fromARGB(255, 80, 60, 59)),
              ),
            const SizedBox(height: 16),
            isLoading
                ? const SpinKitCircle(
                    color: Colors.blue,
                    size: 50.0,
                  )
                : ElevatedButton(
                    onPressed: uploadData,
                    child: const Text("Upload & Analyze"),
                  ),
          ],
        ),
      ),
    );
  }
}


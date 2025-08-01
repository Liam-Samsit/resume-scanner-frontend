import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResumeUploadScreen(),
    );
  }
}

class ResumeUploadScreen extends StatefulWidget {
  @override
  State<ResumeUploadScreen> createState() => _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends State<ResumeUploadScreen> {
  String? status;

  Future<void> uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      var fileBytes = result.files.first.bytes;
      var fileName = result.files.first.name;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:8000/upload-resume'),
      );
      request.files.add(http.MultipartFile.fromBytes('file', fileBytes!, filename: fileName));

      var response = await request.send();
      if (response.statusCode == 200) {
        setState(() {
          status = "Upload successful";
        });
      } else {
        setState(() {
          status = "Upload failed";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resume Scanner')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: uploadFile,
              child: const Text('Upload Resume'),
            ),
            if (status != null) Text(status!),
          ],
        ),
      ),
    );
  }
}


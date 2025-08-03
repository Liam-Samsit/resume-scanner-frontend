import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  List<PlatformFile> uploadedCVs = [];

  void pickCV() async {
    if (uploadedCVs.length >= 5) return;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );

    if (result != null) {
      setState(() {
        uploadedCVs.add(result.files.first);
      });
    }
  }

  void removeCV(int index) {
    setState(() {
      uploadedCVs.removeAt(index);
    });
  }

  void goToNext() {
    if (uploadedCVs.isEmpty) return;
    Navigator.pushNamed(context, '/job-info', arguments: uploadedCVs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkPurple,
      appBar: AppBar(
        backgroundColor: AppColors.darkPurple,
        title: Text("Upload CVs", style: AppTextStyles.heading),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: uploadedCVs.isEmpty ? _buildEmptyState() : _buildCVList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickCV,
        backgroundColor: uploadedCVs.length < 5 ? AppColors.nodeBackground : Colors.grey,
        child: const Icon(Icons.add, color: AppColors.wheatBeige),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: uploadedCVs.isNotEmpty ? AppColors.nodeBackground : Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: uploadedCVs.isNotEmpty ? goToNext : null,
          child: Text("Next", style: AppTextStyles.body),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.2,
            child: Image.asset("assets/icons/empty.png", height: 120),
          ),
          const SizedBox(height: 16),
          Text("You need to upload a CV", style: AppTextStyles.body),
        ],
      ),
    );
  }

  Widget _buildCVList() {
    return ListView.builder(
      itemCount: uploadedCVs.length,
      itemBuilder: (context, index) {
        final cv = uploadedCVs[index];
        return Card(
          color: AppColors.nodeBackground,
          child: ListTile(
            title: Text(cv.name, style: AppTextStyles.body),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => removeCV(index),
            ),
          ),
        );
      },
    );
  }
}

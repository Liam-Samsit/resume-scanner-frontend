import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';
import '../services/api_service.dart';
import '../models/resume_analysis.dart';
import 'results_screen.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen>
    with TickerProviderStateMixin {
  PlatformFile? pickedFile;

  // Separate controllers for job description & keywords
  final TextEditingController jobDescController = TextEditingController();
  final TextEditingController keywordsController = TextEditingController();
  final TextEditingController weightsController = TextEditingController();

  bool isLoading = false;
  bool useJobDescription = true;
  bool showWeights = false;

  late AnimationController _formAnimController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();

    _formAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimations = List.generate(3, (index) {
      return CurvedAnimation(
        parent: _formAnimController,
        curve: Interval(index * 0.2, 1.0, curve: Curves.easeOut),
      );
    });

    _slideAnimations = List.generate(3, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _formAnimController,
        curve: Interval(index * 0.2, 1.0, curve: Curves.easeOut),
      ));
    });

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _bounceController.reverse();
        }
      });
  }

  @override
  void dispose() {
    jobDescController.dispose();
    keywordsController.dispose();
    weightsController.dispose();
    _formAnimController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
      _formAnimController.forward(from: 0);
    }
  }

  bool get canAnalyze {
    if (pickedFile == null) return false;
    if (jobDescController.text.trim().isEmpty &&
        keywordsController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  double get progress {
    double value = 0;
    if (pickedFile != null) value += 0.4;
    if (jobDescController.text.trim().isNotEmpty) value += 0.3;
    if (keywordsController.text.trim().isNotEmpty) value += 0.3;
    if (weightsController.text.trim().isNotEmpty) value += 0.3;
    return value.clamp(0.0, 1.0);
  }

  // Convert "python: 3, sql: 5" into valid JSON for backend
  String formatWeightsToJson(String input) {
    if (input.trim().isEmpty) return "";
    final Map<String, int> weightMap = {};
    final entries = input.split(',');
    for (var entry in entries) {
      final parts = entry.split(':');
      if (parts.length == 2) {
        final key = parts[0].trim();
        final value = int.tryParse(parts[1].trim()) ?? 1;
        if (key.isNotEmpty) weightMap[key] = value;
      }
    }
    return weightMap.isEmpty ? "" : weightMap.toString().replaceAll("'", '"');
  }

  Future<void> uploadData() async {
    if (!canAnalyze) return;
    setState(() => isLoading = true);

    try {
      ResumeAnalysis analysis = await ApiService.uploadResume(
        fileBytes: pickedFile!.bytes as Uint8List,
        fileName: pickedFile!.name,
        jobDescription: jobDescController.text.trim(),
        keywords: keywordsController.text.trim(),
        customWeights: formatWeightsToJson(weightsController.text.trim()),
      );

      setState(() => isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(analysis: analysis),
        ),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst("Exception: ", "")),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Widget buildInitialUploadView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/icons/empty.png", height: 150),
        const SizedBox(height: 16),
        Text(
          "Upload your resume to get started",
          style: AppTextStyles.heading2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: pickFile,
          child: const Text("Upload Resume"),
        ),
      ],
    );
  }

  Widget buildAnimatedField({required int index, required Widget child}) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: child,
        ),
      ),
    );
  }

  Widget buildFormFields() {
    return Column(
      children: [
        buildAnimatedField(
          index: 0,
          child: Column(
            children: [
              Row(
                children: [
                  Text("Selected: ${pickedFile?.name}", style: AppTextStyles.body),
                ],
              ),
              const SizedBox(height: 16),
              ToggleButtons(
                isSelected: [useJobDescription, !useJobDescription],
                onPressed: (index) {
                  setState(() {
                    useJobDescription = index == 0;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Job Description"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Keywords"),
                  ),
                ],
              ),
            ],
          ),
        ),
        buildAnimatedField(
          index: 1,
          child: useJobDescription
              ? buildInputField("Job Description", jobDescController)
              : buildInputField("Keywords", keywordsController),
        ),
        buildAnimatedField(
          index: 2,
          child: Column(
            children: [
              if (showWeights)
                buildInputField("Custom Weights", weightsController,
                    hint: "python: 3, sql: 5"),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() => showWeights = !showWeights),
                child: Text(showWeights ? "Hide Weights" : "Add Weights"),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? Lottie.asset('assets/animations/loading.json', height: 120)
                  : AnimatedBuilder(
                      animation: _bounceController,
                      builder: (context, child) {
                        double scale = 1 - _bounceController.value;
                        return Transform.scale(
                          scale: scale,
                          child: ElevatedButton.icon(
                            onPressed: canAnalyze
                                ? () {
                                    _bounceController.forward();
                                    uploadData();
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  canAnalyze ? AppColors.primary : Colors.grey,
                            ),
                            icon: const Icon(Icons.search),
                            label: const Text("Analyze"),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildInputField(String label, TextEditingController controller,
      {String hint = "Type here..."}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.heading2),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hint,
          ),
          minLines: 3,
          maxLines: 6,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resume Scanner"),
        backgroundColor: AppColors.primary,
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: pickedFile == null
                ? buildInitialUploadView()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: buildFormFields(),
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 8,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: progress >= 0.7
                        ? AppColors.primary
                        : Colors.orangeAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

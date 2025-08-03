import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../services/api_service.dart';
import '../models/resume_result.dart';

class JobInfoScreen extends StatefulWidget {
  final List uploadedCVs;

  const JobInfoScreen({Key? key, required this.uploadedCVs}) : super(key: key);

  @override
  State<JobInfoScreen> createState() => _JobInfoScreenState();
}

class _JobInfoScreenState extends State<JobInfoScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController jobDescController = TextEditingController();
  final TextEditingController keywordsController = TextEditingController();
  final TextEditingController weightsController = TextEditingController();

  bool showWeightsField = false;
  bool isLoading = false;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  bool get isFormValid {
    return jobDescController.text.trim().isNotEmpty ||
        keywordsController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    _bounceController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _bounceAnimation = Tween<double>(begin: 1, end: 1.15)
        .chain(CurveTween(curve: Curves.elasticOut))
        .animate(_bounceController);

    jobDescController.addListener(_onFieldChange);
    keywordsController.addListener(_onFieldChange);
  }

  void _onFieldChange() {
    if (isFormValid && !_bounceController.isAnimating) {
      _bounceController.forward(from: 0);
    }
    setState(() {});
  }

  @override
  void dispose() {
    jobDescController.removeListener(_onFieldChange);
    keywordsController.removeListener(_onFieldChange);
    _bounceController.dispose();
    super.dispose();
  }

  void analyzeCVs() async {
    if (!isFormValid) return;

    setState(() => isLoading = true);
    List<ResumeResult> results = [];

    for (var cv in widget.uploadedCVs) {
      var result = await ApiService.analyzeCV(
        file: cv,
        jobDescription: jobDescController.text,
        keywords: keywordsController.text,
        weights: weightsController.text,
      );
      if (result != null) results.add(result);
    }

    setState(() => isLoading = false);

    Navigator.pushNamed(context, '/results', arguments: results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkPurple,
      appBar: AppBar(
        backgroundColor: AppColors.darkPurple,
        title: Text("Job Info", style: AppTextStyles.heading),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLabeledField(
              label: "Job Description",
              tooltip: "Paste the full job posting here.",
              controller: jobDescController,
              hint: "Enter job description...",
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            _buildLabeledField(
              label: "Keywords",
              tooltip: "List keywords instead of a job description.",
              controller: keywordsController,
              hint: "Enter keywords, separated by commas...",
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            _buildWeightsField(),
            const SizedBox(height: 30),
            ScaleTransition(
              scale: _bounceAnimation,
              child: ElevatedButton(
                onPressed: isFormValid && !isLoading ? analyzeCVs : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid ? AppColors.nodeBackground : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.wheatBeige, strokeWidth: 2),
                      )
                    : Text("Analyze", style: AppTextStyles.body),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required String tooltip,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTextStyles.heading.copyWith(fontSize: 18)),
            const SizedBox(width: 8),
            Tooltip(
              message: tooltip,
              child: const Icon(Icons.info_outline, size: 18, color: AppColors.wheatBeige),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: AppColors.inputField,
          ),
        ),
      ],
    );
  }

  Widget _buildWeightsField() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() => showWeightsField = !showWeightsField);
          },
          child: Row(
            children: [
              Icon(showWeightsField ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: AppColors.wheatBeige),
              Text("Custom Weights (optional)",
                  style: AppTextStyles.heading.copyWith(fontSize: 16)),
            ],
          ),
        ),
        if (showWeightsField)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextField(
              controller: weightsController,
              maxLines: 3,
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: "Example: python: 3, sql: 2",
                hintStyle: AppTextStyles.hint,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: AppColors.inputField,
              ),
            ),
          ),
      ],
    );
  }
}

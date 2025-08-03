import 'package:flutter/material.dart';
import '../models/resume_result.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class CVDetailsScreen extends StatelessWidget {
  final ResumeResult result;

  const CVDetailsScreen({Key? key, required this.result}) : super(key: key);

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: AppTextStyles.heading.copyWith(fontSize: 18)),
    );
  }

  Widget _buildKeywordList(List<String> keywords, {Color? color}) {
    if (keywords.isEmpty) {
      return const Text("None");
    }
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: keywords
          .map((kw) => Chip(
                label: Text(kw),
                backgroundColor: color ?? Colors.grey[200],
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(
        backgroundColor: AppColors.burgundy,
        title: Text(result.fileName, style: const TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score
            Center(
              child: Text("${result.score}%", style: AppTextStyles.heading.copyWith(fontSize: 28)),
            ),
            const SizedBox(height: 20),

            // Technical Skills
            _buildSectionTitle("Technical Skills"),
            Text("Matched:", style: AppTextStyles.body),
            _buildKeywordList(List<String>.from(result.technicalSkills["matched"]), color: Colors.green[100]!),
            const SizedBox(height: 8),
            Text("Missing:", style: AppTextStyles.body),
            _buildKeywordList(List<String>.from(result.technicalSkills["missing"]), color: Colors.red[100]!),

            const SizedBox(height: 20),

            // Soft Skills
            _buildSectionTitle("Soft Skills"),
            Text("Matched:", style: AppTextStyles.body),
            _buildKeywordList(List<String>.from(result.softSkills["matched"]), color: Colors.green[100]!),
            const SizedBox(height: 8),
            Text("Missing:", style: AppTextStyles.body),
            _buildKeywordList(List<String>.from(result.softSkills["missing"]), color: Colors.red[100]!),

            const SizedBox(height: 20),

            // Missing by Priority
            _buildSectionTitle("Missing Keywords by Priority"),
            Text("🔥 High Priority", style: const TextStyle(color: Colors.red)),
            _buildKeywordList(result.missingRanked["high_priority"] ?? []),
            const SizedBox(height: 8),
            Text("⚡ Medium Priority", style: const TextStyle(color: Colors.orange)),
            _buildKeywordList(result.missingRanked["medium_priority"] ?? []),
            const SizedBox(height: 8),
            Text("📎 Low Priority", style: const TextStyle(color: Colors.grey)),
            _buildKeywordList(result.missingRanked["low_priority"] ?? []),

            const SizedBox(height: 20),

            // Suggestions
            _buildSectionTitle("Suggestions"),
            result.suggestions.isEmpty
                ? const Text("No suggestions")
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: result.suggestions
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text("• $s", style: AppTextStyles.body),
                            ))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}

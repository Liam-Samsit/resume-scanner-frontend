import 'package:flutter/material.dart';
import '../models/resume_result.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class CVDetailsScreen extends StatelessWidget {
  final ResumeResult result;

  const CVDetailsScreen({Key? key, required this.result}) : super(key: key);

  static final Color matchedChipColor =
      AppColors.darkPurple.withOpacity(0.9).withGreen(70);
  static final Color missingChipColor =
      AppColors.darkPurple.withOpacity(0.9).withRed(70);

  final Map<String, String> categoryDisplayNames = const {
    "programming_languages": "Programming Languages",
    "frameworks_libraries": "Frameworks & Libraries",
    "databases": "Databases",
    "tools_platforms": "Tools & Platforms",
    "dev_concepts": "Development Concepts",
    "data_ai": "Data & AI",
    "cybersecurity": "Cybersecurity",
    "soft_skills": "Soft Skills",
  };

  List<String> _safeStringList(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return [];
  }

  String _formatCategoryName(String key) {
    if (categoryDisplayNames.containsKey(key)) {
      return categoryDisplayNames[key]!;
    }
    return key
        .replaceAll("_", " ")
        .split(" ")
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : "")
        .join(" ");
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: AppTextStyles.heading.copyWith(fontSize: 18)),
    );
  }

  Widget _buildKeywordList(List<String> keywords, {Color? color}) {
    if (keywords.isEmpty) {
      return Text("None", style: AppTextStyles.body);
    }
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: keywords
          .map(
            (kw) => Chip(
              label: Text(
                kw,
                style: const TextStyle(color: AppColors.wheatBeige),
              ),
              backgroundColor: color ?? AppColors.nodeBackground,
            ),
          )
          .toList(),
    );
  }

  Widget _buildCategorySection(Map<String, List<String>> categories, String type) {
    if (categories.isEmpty) {
      return Text("None", style: AppTextStyles.body);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatCategoryName(entry.key),
              style: AppTextStyles.body
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            _buildKeywordList(
              _safeStringList(entry.value),
              color: type == "matched" ? matchedChipColor : missingChipColor,
            ),
            const SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkPurple,
      appBar: AppBar(
        backgroundColor: AppColors.darkPurple,
        title: Text(result.fileName,
            style: const TextStyle(color: AppColors.wheatBeige)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text("${result.score}%",
                  style: AppTextStyles.heading.copyWith(fontSize: 28)),
            ),
            const SizedBox(height: 20),

            _buildSectionTitle("Matched Skills by Category"),
            _buildCategorySection(result.matchedByCategory, "matched"),
            const SizedBox(height: 20),
            _buildSectionTitle("Missing Skills by Category"),
            _buildCategorySection(result.missingByCategory, "missing"),
            const SizedBox(height: 20),

            _buildSectionTitle("Technical Skills"),
            Text("Matched:", style: AppTextStyles.body),
            _buildKeywordList(
              _safeStringList(result.technicalSkills["matched"]),
              color: matchedChipColor,
            ),
            const SizedBox(height: 8),
            Text("Missing:", style: AppTextStyles.body),
            _buildKeywordList(
              _safeStringList(result.technicalSkills["missing"]),
              color: missingChipColor,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle("Soft Skills"),
            Text("Matched:", style: AppTextStyles.body),
            _buildKeywordList(
              _safeStringList(result.softSkills["matched"]),
              color: matchedChipColor,
            ),
            const SizedBox(height: 8),
            Text("Missing:", style: AppTextStyles.body),
            _buildKeywordList(
              _safeStringList(result.softSkills["missing"]),
              color: missingChipColor,
            ),
            const SizedBox(height: 20),

            _buildSectionTitle("Missing Keywords by Priority"),
            Text("🔥 High Priority",
                style: const TextStyle(color: Colors.redAccent)),
            _buildKeywordList(
                _safeStringList(result.missingRanked["high_priority"])),
            const SizedBox(height: 8),
            Text("⚡ Medium Priority",
                style: const TextStyle(color: Colors.orangeAccent)),
            _buildKeywordList(
                _safeStringList(result.missingRanked["medium_priority"])),
            const SizedBox(height: 8),
            Text("📎 Low Priority", style: const TextStyle(color: Colors.grey)),
            _buildKeywordList(
                _safeStringList(result.missingRanked["low_priority"])),
            const SizedBox(height: 20),

            _buildSectionTitle("Suggestions"),
            result.suggestions.isEmpty
                ? Text("No suggestions", style: AppTextStyles.body)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: result.suggestions
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text("• $s", style: AppTextStyles.body),
                          ),
                        )
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }
}


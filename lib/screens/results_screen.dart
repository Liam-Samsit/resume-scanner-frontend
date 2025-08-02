import 'package:flutter/material.dart';
import '../models/resume_analysis.dart';

class ResultsScreen extends StatelessWidget {
  final ResumeAnalysis analysis;

  const ResultsScreen({super.key, required this.analysis});

  Widget buildSkillList(String title, List<String> items, Color color) {
    if (items.isEmpty) {
      return const Text("None", style: TextStyle(color: Colors.grey));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: items
              .map((e) => Chip(
                    label: Text(e),
                    backgroundColor: color.withOpacity(0.1),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final overall = analysis.overall;
    final tech = analysis.technicalSkills;
    final soft = analysis.softSkills;
    final missingRanked = analysis.missingRanked;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analysis Results"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall score
            Text("Overall Score: ${overall.score}%",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: overall.score / 100,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
              minHeight: 10,
            ),
            const SizedBox(height: 16),

            // Technical skills
            Text("Technical Skills (${tech.score}%)",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            buildSkillList("Matched", tech.matched, Colors.green),
            buildSkillList("Missing", tech.missing, Colors.red),

            // Soft skills
            Text("Soft Skills (${soft.score}%)",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            buildSkillList("Matched", soft.matched, Colors.green),
            buildSkillList("Missing", soft.missing, Colors.red),

            const Divider(height: 32),

            // Missing ranked
            Text("Missing Skills by Priority",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            buildSkillList("🔥 High Priority", missingRanked.highPriority, Colors.red),
            buildSkillList("⚡ Medium Priority", missingRanked.mediumPriority, Colors.orange),
            buildSkillList("📎 Low Priority", missingRanked.lowPriority, Colors.blueGrey),

            const Divider(height: 32),

            // Suggestions
            const Text("Suggestions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (analysis.suggestions.isEmpty)
              const Text("No suggestions", style: TextStyle(color: Colors.grey))
            else
              ...analysis.suggestions.map((s) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text("• $s"),
                  )),
          ],
        ),
      ),
    );
  }
}

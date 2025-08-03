import 'package:flutter/material.dart';
import '../models/resume_result.dart';
import '../utils/app_colors.dart';
import '../widgets/animated_score_circle.dart';
//import 'cv_details_screen.dart';

class ResultsScreen extends StatelessWidget {
  final List<ResumeResult> results;

  const ResultsScreen({Key? key, required this.results}) : super(key: key);

  String _scoreMessage(int score) {
    if (score <= 20) return "Maybe you're not fit for the job";
    if (score <= 40) return "Needs significant improvement";
    if (score <= 60) return "Some good matches, but room for growth";
    if (score <= 80) return "Strong match";
    return "They should hire you ASAP";
  }

  @override
  Widget build(BuildContext context) {
    final sortedResults = [...results]..sort((a, b) => b.score.compareTo(a.score));

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(
        backgroundColor: AppColors.burgundy,
        title: const Text("Ranking"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedResults.length,
        itemBuilder: (context, index) {
          final r = sortedResults[index];
          final isTop = index == 0;

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/cv-details',
                arguments: r,
              );
            },

            child: Card(
              elevation: isTop ? 8 : 3,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (isTop) AnimatedScoreCircle(score: r.score, size: 120),
                    if (isTop) const SizedBox(height: 10),
                    Text(r.fileName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    if (isTop)
                      Text(_scoreMessage(r.score), textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
                    if (!isTop)
                      Text("${r.score}%", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

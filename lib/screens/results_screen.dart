import 'package:flutter/material.dart';
import '../models/resume_result.dart';
import '../utils/app_colors.dart';
import '../widgets/animated_score_circle.dart';

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
      backgroundColor: AppColors.darkPurple,
      appBar: AppBar(
        backgroundColor: AppColors.darkPurple,
        title: const Text("Ranking", style: TextStyle(color: AppColors.wheatBeige)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedResults.length,
        itemBuilder: (context, index) {
          final r = sortedResults[index];
          return TweenAnimationBuilder(
            tween: Tween<double>(begin: 50, end: 0),
            duration: Duration(milliseconds: 400 + (index * 100)),
            curve: Curves.easeOut,
            builder: (context, double offset, child) {
              return Transform.translate(
                offset: Offset(0, offset),
                child: Opacity(
                  opacity: offset == 0 ? 1 : 0,
                  child: child,
                ),
              );
            },
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/cv-details', arguments: r);
              },
              child: _buildRankingCard(r, index == 0),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRankingCard(ResumeResult r, bool isTop) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.nodeBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isTop)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScoreCircle(
                  score: r.score,
                  size: 100,
                  fontSize: 40,
                  boldText: true,
                ),
              ],
            ),
          if (!isTop)
            Text(
              "${r.score}%",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.wheatBeige,
              ),
            ),
          const SizedBox(height: 10),
          Text(
            r.fileName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.wheatBeige,
            ),
            textAlign: TextAlign.center,
          ),
          if (isTop) ...[
            const SizedBox(height: 10),
            Text(
              _scoreMessage(r.score),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.wheatBeige,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

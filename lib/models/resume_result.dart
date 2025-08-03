class ResumeResult {
  final String fileName;
  final int score;
  final int totalKeywords;
  final int matchedKeywords;
  final int missingKeywords;
  final Map<String, dynamic> technicalSkills;
  final Map<String, dynamic> softSkills;
  final Map<String, List<String>> missingRanked;
  final List<String> matchedInOrder;
  final List<String> missingInOrder;
  final List<String> suggestions;

  ResumeResult({
    required this.fileName,
    required this.score,
    required this.totalKeywords,
    required this.matchedKeywords,
    required this.missingKeywords,
    required this.technicalSkills,
    required this.softSkills,
    required this.missingRanked,
    required this.matchedInOrder,
    required this.missingInOrder,
    required this.suggestions,
  });

  factory ResumeResult.fromJson(Map<String, dynamic> json, String fileName) {
    return ResumeResult(
      fileName: fileName,
      score: json["overall"]["score"],
      totalKeywords: json["overall"]["total_keywords"],
      matchedKeywords: json["overall"]["matched_keywords"],
      missingKeywords: json["overall"]["missing_keywords"],
      technicalSkills: Map<String, dynamic>.from(json["technical_skills"]),
      softSkills: Map<String, dynamic>.from(json["soft_skills"]),
      missingRanked: Map<String, List<String>>.from(json["missing_ranked"].map(
        (k, v) => MapEntry(k, List<String>.from(v)),
      )),
      matchedInOrder: List<String>.from(json["matched_in_order"]),
      missingInOrder: List<String>.from(json["missing_in_order"]),
      suggestions: List<String>.from(json["suggestions"]),
    );
  }
}

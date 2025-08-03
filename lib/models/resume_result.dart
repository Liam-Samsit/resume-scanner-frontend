class ResumeResult {
  final String fileName;
  final int score;
  final Map<String, dynamic> overall;
  final Map<String, dynamic> technicalSkills;
  final Map<String, dynamic> softSkills;
  final Map<String, List<String>> matchedByCategory;
  final Map<String, List<String>> missingByCategory;
  final Map<String, dynamic> missingRanked;
  final List<String> matchedInOrder;
  final List<String> missingInOrder;
  final List<String> suggestions;

  ResumeResult({
    required this.fileName,
    required this.score,
    required this.overall,
    required this.technicalSkills,
    required this.softSkills,
    required this.matchedByCategory,
    required this.missingByCategory,
    required this.missingRanked,
    required this.matchedInOrder,
    required this.missingInOrder,
    required this.suggestions,
  });

  static Map<String, List<String>> _parseCategoryMap(dynamic raw) {
    if (raw is Map) {
      return raw.map<String, List<String>>((key, value) {
        if (value is List) {
          return MapEntry(key.toString(),
              value.map((e) => e.toString()).toList());
        }
        return MapEntry(key.toString(), []);
      });
    }
    return {};
  }

  factory ResumeResult.fromJson(Map<String, dynamic> json, String fileName) {
    return ResumeResult(
      fileName: fileName,
      score: json['overall']?['score'] ?? 0,
      overall: json['overall'] ?? {},
      technicalSkills: json['technical_skills'] ?? {},
      softSkills: json['soft_skills'] ?? {},
      matchedByCategory: _parseCategoryMap(json['matched_by_category']),
      missingByCategory: _parseCategoryMap(json['missing_by_category']),
      missingRanked: json['missing_ranked'] ?? {},
      matchedInOrder: List<String>.from(
          (json['matched_in_order'] ?? []).map((e) => e.toString())),
      missingInOrder: List<String>.from(
          (json['missing_in_order'] ?? []).map((e) => e.toString())),
      suggestions: List<String>.from(
          (json['suggestions'] ?? []).map((e) => e.toString())),
    );
  }
}


class SkillSection {
  final int score;
  final List<String> matched;
  final List<String> missing;

  SkillSection({
    required this.score,
    required this.matched,
    required this.missing,
  });

  factory SkillSection.fromJson(Map<String, dynamic> json) {
    return SkillSection(
      score: json['score'] ?? 0,
      matched: List<String>.from(json['matched'] ?? []),
      missing: List<String>.from(json['missing'] ?? []),
    );
  }
}

class MissingRanked {
  final List<String> highPriority;
  final List<String> mediumPriority;
  final List<String> lowPriority;

  MissingRanked({
    required this.highPriority,
    required this.mediumPriority,
    required this.lowPriority,
  });

  factory MissingRanked.fromJson(Map<String, dynamic> json) {
    return MissingRanked(
      highPriority: List<String>.from(json['high_priority'] ?? []),
      mediumPriority: List<String>.from(json['medium_priority'] ?? []),
      lowPriority: List<String>.from(json['low_priority'] ?? []),
    );
  }
}

class OverallStats {
  final int score;
  final int totalKeywords;
  final int matchedKeywords;
  final int missingKeywords;

  OverallStats({
    required this.score,
    required this.totalKeywords,
    required this.matchedKeywords,
    required this.missingKeywords,
  });

  factory OverallStats.fromJson(Map<String, dynamic> json) {
    return OverallStats(
      score: json['score'] ?? 0,
      totalKeywords: json['total_keywords'] ?? 0,
      matchedKeywords: json['matched_keywords'] ?? 0,
      missingKeywords: json['missing_keywords'] ?? 0,
    );
  }
}

class ResumeAnalysis {
  final OverallStats overall;
  final SkillSection technicalSkills;
  final SkillSection softSkills;
  final MissingRanked missingRanked;
  final List<String> matchedInOrder;
  final List<String> missingInOrder;
  final List<String> suggestions;

  ResumeAnalysis({
    required this.overall,
    required this.technicalSkills,
    required this.softSkills,
    required this.missingRanked,
    required this.matchedInOrder,
    required this.missingInOrder,
    required this.suggestions,
  });

  factory ResumeAnalysis.fromJson(Map<String, dynamic> json) {
    return ResumeAnalysis(
      overall: OverallStats.fromJson(json['overall']),
      technicalSkills: SkillSection.fromJson(json['technical_skills']),
      softSkills: SkillSection.fromJson(json['soft_skills']),
      missingRanked: MissingRanked.fromJson(json['missing_ranked']),
      matchedInOrder: List<String>.from(json['matched_in_order'] ?? []),
      missingInOrder: List<String>.from(json['missing_in_order'] ?? []),
      suggestions: List<String>.from(json['suggestions'] ?? []),
    );
  }
}

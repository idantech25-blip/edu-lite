class GradingResult {
  final int score;
  final int total;
  final List<GradingDetail> details;

  GradingResult({
    required this.score,
    required this.total,
    required this.details,
  });

  // Optional: percentage score getter
  double get percentageScore => total == 0 ? 0 : (score / total) * 100;

  // Convert from JSON
  factory GradingResult.fromJson(Map<String, dynamic> json) {
    return GradingResult(
      score: json['score'],
      total: json['total'],
      details: (json['details'] as List)
          .map((e) => GradingDetail.fromJson(e))
          .toList(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'score': score,
    'total': total,
    'details': details.map((e) => e.toJson()).toList(),
  };
}

class GradingDetail {
  final String studentAnswer;
  final String correctAnswer;
  final bool isCorrect;

  GradingDetail({
    required this.studentAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });

  // Convert from JSON
  factory GradingDetail.fromJson(Map<String, dynamic> json) {
    return GradingDetail(
      studentAnswer: json['studentAnswer'],
      correctAnswer: json['correctAnswer'],
      isCorrect: json['isCorrect'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => {
    'studentAnswer': studentAnswer,
    'correctAnswer': correctAnswer,
    'isCorrect': isCorrect,
  };
}

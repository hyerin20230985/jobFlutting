class InterviewQuestion {
  final String id;
  final String question;
  final String category;
  final List<String> keywords;
  final String difficulty;
  final String industry;

  InterviewQuestion({
    required this.id,
    required this.question,
    required this.category,
    required this.keywords,
    required this.difficulty,
    required this.industry,
  });

  factory InterviewQuestion.fromJson(Map<String, dynamic> json) {
    return InterviewQuestion(
      id: json['id'],
      question: json['question'],
      category: json['category'],
      keywords: List<String>.from(json['keywords']),
      difficulty: json['difficulty'],
      industry: json['industry'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'category': category,
      'keywords': keywords,
      'difficulty': difficulty,
      'industry': industry,
    };
  }
}

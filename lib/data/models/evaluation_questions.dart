class EvaluationQuestions {
  final Map<String, List<String>> questions;

  EvaluationQuestions({required this.questions});

  factory EvaluationQuestions.fromJson(Map<String, dynamic> json) {
    final questionsMap = json['evaluationQuestions'] as Map<String, dynamic>;
    return EvaluationQuestions(
      questions: questionsMap.map(
        (key, value) => MapEntry(
          key,
          (value as List).cast<String>(),
        ),
      ),
    );
  }
}

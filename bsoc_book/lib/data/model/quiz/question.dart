enum Type { multiple, boolean }

class Question {
  final Type? type;
  final String? question;
  final String? correctAnswer;
  final List<dynamic>? incorrectAnswers;

  Question(
      {this.type, this.question, this.correctAnswer, this.incorrectAnswers});

  Question.fromMap(Map<String, dynamic> data)
      : type = data["type"] == "multiple" ? Type.multiple : Type.boolean,
        question = data["question"],
        correctAnswer = data["correct_answer"],
        incorrectAnswers = data["incorrect_answers"];

  static List<Question> fromData(List<Map<String, dynamic>> data) {
    return data.map((question) => Question.fromMap(question)).toList();
  }
}

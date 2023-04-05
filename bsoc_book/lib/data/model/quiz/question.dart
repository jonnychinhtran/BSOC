enum Type { multiple, boolean }

class Question {
  final int? id;
  final Type? isMultiChoice;
  final String? content;
  final String? correctAnswer;
  final List<dynamic>? answers;

  Question(
      {this.id,
      this.isMultiChoice,
      this.content,
      this.correctAnswer,
      this.answers});

  Question.fromMap(Map<String, dynamic> data)
      : id = data["id"],
        isMultiChoice =
            data["isMultiChoice"] == "false" ? Type.multiple : Type.boolean,
        content = data["content"],
        correctAnswer = data["correct_answer"],
        answers = data["answers"];

  static List<Question> fromData(List<Map<String, dynamic>> data) {
    return data.map((question) => Question.fromMap(question)).toList();
  }
}

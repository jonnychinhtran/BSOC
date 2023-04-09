enum Type { multiple, boolean }

class Question {
  final int? id;
  final Type? isMultiChoice;
  final String? content;
  final String? correctAnswer;
  final List<Answers>?
      answers; // Change the data type of answers to List<Answers>?

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
        answers = data["answers"] != null
            ? (data["answers"] as List<dynamic>)
                .map((e) => Answers.fromJson(e))
                .toList()
            : null;

  static List<Question> fromData(List<Map<String, dynamic>> data) {
    return data.map((question) => Question.fromMap(question)).toList();
  }
}

class Answers {
  int? id;
  String? content;
  bool? isCorrect;

  Answers({this.id, this.content, this.isCorrect});

  Answers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    isCorrect = json['isCorrect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['isCorrect'] = this.isCorrect;
    return data;
  }
}

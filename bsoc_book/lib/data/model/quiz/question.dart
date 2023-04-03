// enum Type { multiple, boolean }

// class Question {
//   final Type? type;
//   final String? question;
//   final String? correctAnswer;
//   final List<dynamic>? incorrectAnswers;

//   Question(
//       {this.type, this.question, this.correctAnswer, this.incorrectAnswers});

//   Question.fromMap(Map<String, dynamic> data)
//       : type = data["type"] == "multiple" ? Type.multiple : Type.boolean,
//         question = data["question"],
//         correctAnswer = data["correct_answer"],
//         incorrectAnswers = data["incorrect_answers"];

//   static List<Question> fromData(List<Map<String, dynamic>> data) {
//     return data.map((question) => Question.fromMap(question)).toList();
//   }
// }

class Question {
  int? totalQuestion;
  int? duration;
  List<ListQuestion>? listQuestion;

  Question({this.totalQuestion, this.duration, this.listQuestion});

  Question.fromJson(Map<String, dynamic> json) {
    totalQuestion = json['totalQuestion'];
    duration = json['duration'];
    if (json['listQuestion'] != null) {
      listQuestion = <ListQuestion>[];
      json['listQuestion'].forEach((v) {
        listQuestion!.add(new ListQuestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalQuestion'] = this.totalQuestion;
    data['duration'] = this.duration;
    if (this.listQuestion != null) {
      data['listQuestion'] = this.listQuestion!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListQuestion {
  int? id;
  String? content;
  bool? isMultiChoice;
  int? totalAnswer;
  List<Answers>? answers;

  ListQuestion(
      {this.id,
      this.content,
      this.isMultiChoice,
      this.totalAnswer,
      this.answers});

  ListQuestion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    isMultiChoice = json['isMultiChoice'];
    totalAnswer = json['totalAnswer'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(new Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['isMultiChoice'] = this.isMultiChoice;
    data['totalAnswer'] = this.totalAnswer;
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    return data;
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

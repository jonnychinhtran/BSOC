// class Question {
//   final int? id;
//   final bool? isMultiChoice;
//   final String? content;
//   final String? correctAnswer;
//   final List<Answers>?
//       answers; // Change the data type of answers to List<Answers>?

//   Question(
//       {this.id,
//       this.isMultiChoice,
//       this.content,
//       this.correctAnswer,
//       this.answers});

//   Question.fromMap(Map<String, dynamic> data)
//       : id = data["id"],
//         isMultiChoice = data["isMultiChoice"],
//         content = data["content"],
//         correctAnswer = data["correct_answer"],
//         answers = data["answers"] != null
//             ? (data["answers"] as List<dynamic>)
//                 .map((e) => Answers.fromJson(e))
//                 .toList()
//             : null;

// static List<Question> fromData(List<Map<String, dynamic>> data) {
//   return data.map((question) => Question.fromMap(question)).toList();
// }
// }

class Question {
  int? id;
  String? content;
  bool? isMultiChoice;
  int? totalAnswer;
  List<Answers>? answers;

  Question(
      {this.id,
      this.content,
      this.isMultiChoice,
      this.totalAnswer,
      this.answers});

  Question.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        content = data['content'],
        isMultiChoice = data['isMultiChoice'],
        totalAnswer = data['totalAnswer'],
        answers = data['answers'] != null
            ? List<Answers>.from(
                data['answers'].map((x) => Answers.fromJson(x)))
            : null;

  static List<Question> fromData(List<Map<String, dynamic>> data) {
    return data.map((question) => Question.fromMap(question)).toList();
  }
}

class Answers {
  int? id;
  String? content;
  bool? isCorrect;
  bool? selected;

  Answers({this.id, this.content, this.isCorrect});

  Answers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    isCorrect = json['isCorrect'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['isCorrect'] = this.isCorrect;
    data['selected'] = this.selected;
    return data;
  }

  // bool contains(int? id) {
  //   return this.id == id;
  // }

  // void remove(int? id) {
  //   selected = false;
  // }

  // void add(int? id) {
  //   selected = true;
  // }
}

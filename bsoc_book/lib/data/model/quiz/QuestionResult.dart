class QuestionResult {
  int? questionId;
  int? answerId;

  QuestionResult({this.questionId, this.answerId});

  QuestionResult.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    answerId = json['answerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    data['answerId'] = this.answerId;
    return data;
  }
}

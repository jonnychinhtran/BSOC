import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:html_unescape/html_unescape.dart';

class CheckAnswersPage extends StatelessWidget {
  final List<Question> questions;
  final List<Answers?> answers;

  const CheckAnswersPage({
    Key? key,
    required this.questions,
    required this.answers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kiểm tra kết quả'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              height: 200,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: questions.length + 1,
            itemBuilder: _buildItem,
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == questions.length) {
      return ElevatedButton(
        child: Text("Về trang chủ"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    }
    Question question = questions[index];
    bool correct = answers[index]?.isCorrect == true;
    Answers? selectedAnswer = answers[index];

    // Find the correct answer for the current question
    Answers? correctAnswer =
        question.answers?.firstWhere((answer) => answer.isCorrect == true);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              HtmlUnescape().convert(question.content!),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            answers[index]?.content != null
                ? Text(
                    HtmlUnescape().convert("${answers[index]?.content}"),
                    style: TextStyle(
                        color: correct ? Colors.green : Colors.red,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  )
                : Text(
                    'Bạn chưa chọn đáp án nào',
                    style: TextStyle(
                        color: correct ? Colors.green : Colors.red,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
            SizedBox(height: 5.0),
            correct || correctAnswer == null
                ? Container()
                : Text.rich(
                    TextSpan(children: [
                      TextSpan(text: "Đáp án đúng: "),
                      TextSpan(
                          text: HtmlUnescape().convert(
                              answers[index]?.content != null
                                  ? "${correctAnswer.content}"
                                  : "Vui lòng làm bài thi"),
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]),
                    style: TextStyle(fontSize: 16.0),
                  )
          ],
        ),
      ),
    );
  }
}
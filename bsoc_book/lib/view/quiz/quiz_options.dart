import 'package:bsoc_book/data/model/quiz/category.dart';
import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:bsoc_book/data/network/api_question.dart';
import 'package:bsoc_book/view/quiz/quiz.dart';
import 'package:flutter/material.dart';

class QuizOptionsDialog extends StatefulWidget {
  final List<Question> questions;
  final Map<String, dynamic>? headquestion;
  final String? idPractice;
  const QuizOptionsDialog(
      {Key? key, required this.questions, this.headquestion, this.idPractice})
      : super(key: key);

  @override
  State<QuizOptionsDialog> createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  int? _noOfQuestions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(16.0),
              //   color: Colors.grey.shade200,
              //   child: Text(
              //     widget.idPractice.toString(),
              //     style: Theme.of(context).textTheme.headline6!.copyWith(),
              //   ),
              // ),
              // SizedBox(height: 10.0),
              Row(
                children: [
                  Text("Số câu hỏi: "),
                  Text(widget.headquestion!['totalQuestion'].toString()),
                ],
              ),

              SizedBox(height: 20.0),
              Row(
                children: [
                  Text("Thời gian thi: "),
                  Text(widget.headquestion!['duration'].toString() + ' phút'),
                ],
              ),

              SizedBox(height: 5.0),
              // processing
              //     ? CircularProgressIndicator()
              //     :
              ElevatedButton(
                  onPressed: () async {
                    _noOfQuestions = int.parse(widget.idPractice.toString());
                    print(_noOfQuestions);
                    List<Question> questions =
                        await getQuestions(_noOfQuestions);
                    if (headquestion!['totalQuestion'] == 0) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Thông báo"),
                            content: Text("Đề thi đang được cập nhật"),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuizPage(
                                    questions: questions,
                                    headquestion: headquestion,
                                  )));
                    }
                  },
                  child: Text('Bắt đầu thi')),
              SizedBox(height: 5.0),
            ],
          ),
        ),
      ),
    );
  }
}

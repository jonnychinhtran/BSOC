import 'package:bsoc_book/data/model/quiz/category.dart';
import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:bsoc_book/data/network/api_question.dart';
import 'package:bsoc_book/view/quiz/quiz.dart';
import 'package:flutter/material.dart';

class QuizOptionsDialog extends StatefulWidget {
  final Map<String, dynamic>? headquestions;
  final String? idPractice;
  final Map<String, dynamic>? data2;
  const QuizOptionsDialog(
      {Key? key, required this.headquestions, this.idPractice, this.data2})
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
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Số câu hỏi: ", style: TextStyle(fontSize: 16)),
                  Text(widget.headquestions!['totalQuestion'].toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),

              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Thời gian thi: ", style: TextStyle(fontSize: 16)),
                  Text(widget.headquestions!['duration'].toString() + ' phút',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
                    print('trang thi: $widget.headquestions');
                    if (widget.headquestions!['totalQuestion'] == null) {
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
                                    data2: data2,
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

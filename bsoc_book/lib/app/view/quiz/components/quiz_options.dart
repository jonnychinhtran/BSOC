import 'package:bsoc_book/app/models/quiz/list_question_model.dart';
import 'package:bsoc_book/app/models/quiz/subject_info_model.dart';
import 'package:bsoc_book/app/view/quiz/quiz_page_view.dart';
import 'package:bsoc_book/app/view/quiz/quiz_play.dart';
import 'package:bsoc_book/app/view_model/quiz_view_model.dart';
import 'package:flutter/material.dart';

class QuizOptionsDialog extends StatefulWidget {
  const QuizOptionsDialog(
      {super.key,
      required this.parentViewState,
      required this.quizViewModel,
      required this.headquestions,
      required this.idPractice,
      required this.selectedStandardName});

  final QuizPageViewState parentViewState;
  final QuizViewModel? quizViewModel;
  final SubjectInfoModel? headquestions;
  final String? idPractice;
  final String? selectedStandardName;

  @override
  State<QuizOptionsDialog> createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  late QuizViewModel _quizViewModel;
  int? _noOfQuestions;
  List<ListQuestionModel>? _listQuestionModel;

  @override
  void initState() {
    _quizViewModel = widget.quizViewModel!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Chủ đề: ",
                      style: TextStyle(fontSize: 16)), // Change the text
                  Text(
                      widget.selectedStandardName == null
                          ? ""
                          : widget.selectedStandardName
                              .toString(), // Use the selectedStandardName parameter

                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Số câu hỏi: ", style: TextStyle(fontSize: 16)),
                  Text('${widget.headquestions!.totalQuestion} câu',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Thời gian thi: ", style: TextStyle(fontSize: 16)),
                  Text('${widget.headquestions!.duration!} phút',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                  onPressed: () async {
                    _noOfQuestions = int.parse(widget.idPractice.toString());
                    // print(_noOfQuestions);
                    // List<Question> questions =
                    //     await getQuestions(_noOfQuestions);
                    // print('trang thi: $widget.headquestions');
                    if (widget.headquestions!.totalQuestion == 0) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Thông báo"),
                            content: const Text("Đề thi đang được cập nhật"),
                            actions: [
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      _quizViewModel
                          .getListQuestionQuiz(_noOfQuestions)
                          .then((value) => {
                                if (value != [])
                                  {
                                    _listQuestionModel = value,
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QuizPlayPage(
                                                  parentViewState:
                                                      widget.parentViewState,
                                                  quizViewModel: _quizViewModel,
                                                  listQuestions:
                                                      _listQuestionModel!,
                                                  timeQuiz: widget
                                                      .headquestions!.duration,
                                                )))
                                  }
                              });
                    }
                  },
                  child: const Text('Bắt đầu thi')),
              const SizedBox(height: 5.0),
            ],
          ),
        ),
      ),
    );
  }
}

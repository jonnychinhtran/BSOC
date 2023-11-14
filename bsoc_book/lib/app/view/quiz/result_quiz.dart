import 'package:bsoc_book/app/models/quiz/list_question_model.dart';
import 'package:bsoc_book/app/models/quiz/post_quiz_model.dart';
import 'package:bsoc_book/app/models/quiz/question_result_model.dart';
import 'package:bsoc_book/app/view/quiz/quiz_page_view.dart';
import 'package:bsoc_book/app/view_model/quiz_view_model.dart';
import 'package:bsoc_book/app/view/quiz/check_answers.dart';
import 'package:bsoc_book/app/view/quiz/practice.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ResultQuizPage extends StatefulWidget {
  const ResultQuizPage(
      {super.key,
      required this.questions,
      required this.answersPost,
      required this.quizResult});

  final List<ListQuestionModel> questions;
  final List<PostQuizModel>? answersPost;
  final QuestionResultModel quizResult;

  @override
  State<ResultQuizPage> createState() => _ResultQuizPageState();
}

class _ResultQuizPageState extends State<ResultQuizPage> {
  ConnectivityResult connectivity = ConnectivityResult.none;
  bool isLoading = true;
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    int correct = 0;

    final TextStyle titleStyle = TextStyle(
        color: Colors.black87, fontSize: 16.0, fontWeight: FontWeight.w500);
    final TextStyle trailingStyle = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold);

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.indigo.shade900,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Image.asset(
            'assets/images/logo-b4usolution.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
        body: Stack(children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg2.png'),
                  fit: BoxFit.cover,
                ),
              )),
          SafeArea(
              child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.01),
                    const Text(
                      'QUIZ RESULTS',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 90.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 245, 234, 217),
                            ),
                            height: 400,
                            width: double.infinity,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                              child: Image.asset('assets/images/ico2.png')),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 220.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 178, 10),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${widget.questions.length}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            const Text(
                                              'Câu hỏi',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 0, 172, 86),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${widget.quizResult.totalCorrect}/${widget.questions.length}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            const Text(
                                              'Câu đúng',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 250, 96, 37),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${widget.quizResult.totalWrong}/${widget.questions.length}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            const Text(
                                              'Câu sai',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 22.0, top: 340.0),
                          child: Column(children: [
                            SizedBox(height: size.height * 0.02),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 12.0, right: 16.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 2,
                                    backgroundColor: Colors.lightBlue[600],
                                    minimumSize: const Size.fromHeight(35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    widget.questions.clear();
                                    widget.answersPost!.clear();
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => QuizHomePage(
                                                  quizViewModel:
                                                      QuizViewModel(),
                                                  parentViewState:
                                                      QuizPageViewState(),
                                                )));
                                  },
                                  child: const Text('Trở về trang chủ đề thi'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 12.0, right: 16.0),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 2,
                                    backgroundColor: Colors.deepOrange[600],
                                    minimumSize: const Size.fromHeight(35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => CheckAnswersPage(
                                                questions: widget.questions,
                                                answersPost:
                                                    widget.answersPost)));
                                  },
                                  child: const Text('Kiểm tra lại đáp án'),
                                ),
                              ),
                            ),
                          ]),
                        )
                      ],
                    ),
                  ]),
            ),
          ))
        ])
        // )
        );
  }
}

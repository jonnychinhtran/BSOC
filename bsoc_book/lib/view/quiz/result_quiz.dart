import 'dart:async';
import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:bsoc_book/view/quiz/check_answers.dart';
import 'package:bsoc_book/view/quiz/practice.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';

class ResultQuizPage extends StatefulWidget {
  final List<Question> questions;
  final List<Answers?> answers;
  final Map<String, dynamic>? quizResult;

  ResultQuizPage(
      {Key? key,
      required this.questions,
      required this.answers,
      this.quizResult})
      : super(key: key);

  @override
  State<ResultQuizPage> createState() => _ResultQuizPageState();
}

class _ResultQuizPageState extends State<ResultQuizPage> {
  ConnectivityResult connectivity = ConnectivityResult.none;
  bool isLoading = true;
  int? correctAnswers;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    int correct = 0;
    // this.widget.answers.forEach((index, value) {
    //   // if (this.widget.questions[index].correctAnswer == value) correct++;
    // });
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
          // title: Text('Quản lý Coupon'),
          title: Image.asset(
            'assets/images/logo-b4usolution.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
        body:
            // OfflineBuilder(
            //     connectivityBuilder: (
            //       BuildContext context,
            //       ConnectivityResult connectivity,
            //       Widget child,
            //     ) {
            //       final connected = connectivity != ConnectivityResult.none;
            //       return Stack(
            //         fit: StackFit.expand,
            //         children: [
            //           child,
            //           Positioned(
            //             height: 0.0,
            //             left: 0.0,
            //             right: 0.0,
            //             child: AnimatedContainer(
            //               duration: const Duration(milliseconds: 350),
            //               color: connected
            //                   ? const Color(0xFF00EE44)
            //                   : const Color(0xFFEE4400),
            //               child: AnimatedSwitcher(
            //                 duration: const Duration(milliseconds: 350),
            //                 child: connected
            //                     ? const Text('ONLINE')
            //                     : Row(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: const <Widget>[
            //                           Text('OFFLINE'),
            //                           SizedBox(width: 8.0),
            //                           SizedBox(
            //                             width: 12.0,
            //                             height: 12.0,
            //                             child: CircularProgressIndicator(
            //                               strokeWidth: 2.0,
            //                               valueColor: AlwaysStoppedAnimation<Color>(
            //                                   Colors.white),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       );
            //     },
            //     child:
            Stack(children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
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
                    Text(
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
                            decoration: BoxDecoration(
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
                                          color:
                                              Color.fromARGB(255, 255, 178, 10),
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
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            Text(
                                              'Câu hỏi',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
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
                                              '${widget.quizResult!['totalCorrect']}/${widget.questions.length}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            Text(
                                              'Câu đúng',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
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
                                              '${widget.quizResult!['totalWrong']}/${widget.questions.length}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            Text(
                                              'Câu sai',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
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
                                    primary: Colors.lightBlue[600],
                                    minimumSize: const Size.fromHeight(35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(PracticePage());
                                  },
                                  child: Text('Trở về trang chủ'),
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
                                    primary: Colors.deepOrange[600],
                                    minimumSize: const Size.fromHeight(35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => CheckAnswersPage(
                                                  questions: widget.questions,
                                                  answers: widget.answers,
                                                )));
                                  },
                                  child: Text('Kiểm tra lại đáp án'),
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

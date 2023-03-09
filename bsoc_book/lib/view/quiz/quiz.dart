import 'dart:async';
import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:bsoc_book/view/quiz/result_quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  const QuizPage({Key? key, required this.questions}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  ConnectivityResult connectivity = ConnectivityResult.none;
  late AnimationController controller;
  bool isLoading = true;

  int seconds = 60;
  Timer? timer;

  Future<void> callback() async {
    if (connectivity == ConnectivityResult.none) {
      isLoading = true;
    } else {
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => QuizPage()),
      //     (Route<dynamic> route) => false);
    }
  }

  // startTimer() {
  //   timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (seconds > 0) {
  //         seconds--;
  //       } else {
  //         // gotoNextQuestion();
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    callback();
    super.initState();
    // startTimer();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.indigo.shade900,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          // title: Text('Quản lý Coupon'),
          title: Image.asset(
            'assets/images/logo-b4usolution.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
        body: OfflineBuilder(
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              if (connectivity == ConnectivityResult.none) {
                return Container(
                  color: Colors.white70,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Image.asset('assets/images/wifi.png'),
                          Text(
                            'Không có kết nối Internet',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Vui lòng kiểm tra kết nối internet và thử lại',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return child;
              }
            },
            child: Stack(children: [
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
                          'TIME FOR QUIZ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Stack(alignment: Alignment.center, children: [
                          Text(
                            seconds.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: seconds / 60,
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        ]),
                        SizedBox(height: size.height * 0.04),
                        Column(
                          children: [
                            Stack(children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 193, 255, 114),
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.green,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                height: 500,
                                width: double.infinity,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 22.0, top: 2.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: size.height * 0.02),
                                    Text(
                                      'What is the worlds longest venomous snake?',
                                      style: TextStyle(
                                          // color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12.0, right: 16.0),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'King Cobra',
                                            style: TextStyle(
                                                // color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12.0, right: 16.0),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Green Anaconda',
                                            style: TextStyle(
                                                // color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12.0, right: 16.0),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Inland Taipan',
                                            style: TextStyle(
                                                // color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 100.0, right: 16.0),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Yellow Bellied Sea Snake',
                                            style: TextStyle(
                                                // color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12.0, right: 16.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 140,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 2,
                                                primary: Colors.deepOrange[600],
                                                minimumSize:
                                                    const Size.fromHeight(35),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                // Navigator.pop(context, 'Không')
                                                // Get.to(ResultQuizPage());
                                              },
                                              child: Text('<< Câu trước'),
                                            ),
                                          ),
                                          Container(
                                            width: 140,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                elevation: 2,
                                                primary: Colors.deepOrange[600],
                                                minimumSize:
                                                    const Size.fromHeight(35),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              onPressed: () {
                                                // Navigator.pop(context, 'Không')
                                                // Get.to(ResultQuizPage());
                                              },
                                              child: Text('Câu tiếp theo >>'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ])));
  }
}

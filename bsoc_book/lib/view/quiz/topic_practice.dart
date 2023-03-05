import 'package:bsoc_book/view/quiz/quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';

class TopicPracticePage extends StatefulWidget {
  const TopicPracticePage({super.key});

  @override
  State<TopicPracticePage> createState() => _TopicPracticePageState();
}

class _TopicPracticePageState extends State<TopicPracticePage> {
  ConnectivityResult connectivity = ConnectivityResult.none;
  bool isLoading = true;

  Future<void> callback() async {
    if (connectivity == ConnectivityResult.none) {
      isLoading = true;
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => TopicPracticePage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    callback();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.indigo.shade900,
        appBar: AppBar(
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
                        SizedBox(height: size.height * 0.05),
                        Text(
                          'TOEIC PRACTICE',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: size.height * 0.04),
                        Text(
                          'PRACTIC READING',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: size.height * 0.04),
                        Container(
                          height: 420,
                          child: ListView(children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 45.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(QuizPage());
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color:
                                            Color.fromARGB(255, 193, 255, 114),
                                        border: Border(
                                          left: BorderSide(
                                            color: Colors.green,
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                      width: 60,
                                      height: 60,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'FUILL TEST - ALL PART 1',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                '200 QUESTIONS',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              // Stack(children: [
                                              //   Container(
                                              //     decoration: BoxDecoration(
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               10),
                                              //       color: Colors.white,
                                              //       border: Border(
                                              //         left: BorderSide(
                                              //           color: Colors.green,
                                              //           width: 3,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //     width: 100,
                                              //     height: 20,
                                              //   ),
                                              //   Padding(
                                              //     padding:
                                              //         const EdgeInsets.only(
                                              //             left: 22.0, top: 2.0),
                                              //     child: Text(
                                              //       'ETS 2019',
                                              //       style: TextStyle(
                                              //           color: Colors.black,
                                              //           fontSize: 13,
                                              //           fontWeight:
                                              //               FontWeight.w600),
                                              //     ),
                                              //   ),
                                              // ]),
                                              Stack(children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                    border: Border(
                                                      left: BorderSide(
                                                        color: Colors.green,
                                                        width: 3,
                                                      ),
                                                    ),
                                                  ),
                                                  width: 100,
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 22.0, top: 2.0),
                                                  child: Text(
                                                    'ETS 2019',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ]),
                                            ]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 45.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(QuizPage());
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color:
                                            Color.fromARGB(255, 193, 255, 114),
                                        border: Border(
                                          left: BorderSide(
                                            color: Colors.green,
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                      width: 60,
                                      height: 60,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'FUILL TEST - ALL PART 2',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                '200 QUESTIONS',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Stack(children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                    border: Border(
                                                      left: BorderSide(
                                                        color: Colors.green,
                                                        width: 3,
                                                      ),
                                                    ),
                                                  ),
                                                  width: 100,
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 22.0, top: 2.0),
                                                  child: Text(
                                                    'ETS 2019',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ]),
                                            ]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 45.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(QuizPage());
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color:
                                            Color.fromARGB(255, 193, 255, 114),
                                        border: Border(
                                          left: BorderSide(
                                            color: Colors.green,
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                      width: 60,
                                      height: 60,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'FUILL TEST - ALL PART 3',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                '200 QUESTIONS',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Stack(children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                    border: Border(
                                                      left: BorderSide(
                                                        color: Colors.green,
                                                        width: 3,
                                                      ),
                                                    ),
                                                  ),
                                                  width: 100,
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 22.0, top: 2.0),
                                                  child: Text(
                                                    'ETS 2019',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ]),
                                            ]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(QuizPage());
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color:
                                            Color.fromARGB(255, 193, 255, 114),
                                        border: Border(
                                          left: BorderSide(
                                            color: Colors.green,
                                            width: 3,
                                          ),
                                        ),
                                      ),
                                      width: 60,
                                      height: 60,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Container(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'FUILL TEST - ALL PART 4',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                '200 QUESTIONS',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Stack(children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                    border: Border(
                                                      left: BorderSide(
                                                        color: Colors.green,
                                                        width: 3,
                                                      ),
                                                    ),
                                                  ),
                                                  width: 100,
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 22.0, top: 2.0),
                                                  child: Text(
                                                    'ETS 2019',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ]),
                                            ]),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ])));
  }
}

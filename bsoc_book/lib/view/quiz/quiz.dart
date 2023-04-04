import 'dart:async';
import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:bsoc_book/view/quiz/result_quiz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  const QuizPage({Key? key, required this.questions}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);

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

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          // gotoNextQuestion();
        }
      });
    });
  }

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    callback();
    super.initState();
    // startTimer();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Question question = widget.questions[_currentIndex];
    final List<dynamic> options = question.answers!;
    if (!options.contains(question.correctAnswer)) {
      options.add(question.correctAnswer);
      options.shuffle();
    }

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
            child: WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                key: _key,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Center(child: Text('TOEIC PRACTICE')),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                ),
                body: Stack(
                  children: <Widget>[
                    // ClipPath(
                    //   clipper: WaveClipperTwo(),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         color: Theme.of(context).primaryColor),
                    //     height: 200,
                    //   ),
                    // ),
                    Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/bg2.png'),
                            fit: BoxFit.cover,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 200, left: 16.0, right: 16.0),
                      child: new LinearPercentIndicator(
                        width: 295,
                        animation: true,
                        animationDuration: 2000,
                        lineHeight: 20.0,
                        trailing: new Text(
                          "Thời gian",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        // trailing:  Text("right content"),
                        percent: 0.2,
                        // center: Text("20.0%"),
                        // linearStrokeCap: LinearStrokeCap.butt,
                        progressColor: Color.fromARGB(244, 193, 255, 114),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 260.0, left: 16.0, right: 16.0, bottom: 16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.white70,
                                child: Text("${_currentIndex + 1}"),
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Text(
                                  HtmlUnescape().convert(
                                      widget.questions[_currentIndex].content!),
                                  softWrap: true,
                                  style: MediaQuery.of(context).size.width > 800
                                      ? _questionStyle.copyWith(fontSize: 30.0)
                                      : _questionStyle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ...options.map((option) => RadioListTile(
                                      title: Text(
                                        HtmlUnescape().convert("$option"),
                                        style:
                                            MediaQuery.of(context).size.width >
                                                    800
                                                ? TextStyle(fontSize: 30.0)
                                                : null,
                                      ),
                                      groupValue: _answers[_currentIndex],
                                      value: option,
                                      onChanged: (dynamic value) {
                                        setState(() {
                                          _answers[_currentIndex] = option;
                                        });
                                      },
                                    )),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: _currentIndex == 0
                                      ? Container()
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    800
                                                ? const EdgeInsets.symmetric(
                                                    vertical: 20.0,
                                                    horizontal: 64.0)
                                                : null,
                                          ),
                                          child: Text(
                                            "Câu trước",
                                            style: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    800
                                                ? TextStyle(fontSize: 30.0)
                                                : null,
                                          ),
                                          onPressed: _backSubmit,
                                        ),
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding:
                                          MediaQuery.of(context).size.width >
                                                  800
                                              ? const EdgeInsets.symmetric(
                                                  vertical: 20.0,
                                                  horizontal: 64.0)
                                              : null,
                                    ),
                                    child: Text(
                                      _currentIndex ==
                                              (widget.questions.length - 1)
                                          ? "Gửi bài thi"
                                          : "Câu tiếp theo",
                                      style: MediaQuery.of(context).size.width >
                                              800
                                          ? TextStyle(fontSize: 30.0)
                                          : null,
                                    ),
                                    onPressed: _nextSubmit,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  void _backSubmit() {
    // if (_answers[_currentIndex] == (widget.questions.length + 1)) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text("You must select an answer to continue."),
    //   ));
    //   return;
    // }
    if (_currentIndex < (widget.questions.length + 1)) {
      setState(() {
        _currentIndex--;
      });
    }
    // else {
    // Navigator.of(context).pushReplacement(MaterialPageRoute(
    //     builder: (_) => ResultQuizPage(
    //         questions: widget.questions, answers: _answers)));
    // }
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Bạn phải chọn một câu trả lời để tiếp tục."),
      ));
      return;
    }
    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) =>
              ResultQuizPage(questions: widget.questions, answers: _answers)));
    }
  }

  Future<bool> _onWillPop() async {
    final resp = await showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
                "Bạn có chắc chắn muốn thoát khỏi bài kiểm tra không? Tất cả tiến trình của bạn sẽ bị mất."),
            title: Text("Cảnh báo!"),
            actions: <Widget>[
              TextButton(
                child: Text("Có"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              TextButton(
                child: Text("Không"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
    return resp ?? false;
  }
}

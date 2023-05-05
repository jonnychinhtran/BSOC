import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bsoc_book/data/model/quiz/QuestionResult.dart';
import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:bsoc_book/view/quiz/practice.dart';
import 'package:bsoc_book/view/quiz/result_quiz.dart';
import 'package:bsoc_book/view/rewards/rewards.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic>? quizResult;

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final Map<String, dynamic>? data2;
  const QuizPage({Key? key, required this.questions, this.data2})
      : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);
  late AnimationController controller;
  bool isLoading = true;
  bool isPlaying = false;
  bool _resultSent = false;
  double progress = 1.0;

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void notify() async {
    if (countText == '0:00:00' && !_resultSent) {
      _resultSent = true;
      String? token;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');

      var formData =
          _questionResults?.map((result) => result.toJson()).toList();

      final dio = Dio(); // Create Dio instance
      final response = await dio.post(
          'http://103.77.166.202/api/quiz/check-result',
          options: Options(
              contentType: 'application/json',
              headers: {'Authorization': 'Bearer $token'}),
          data: formData);
      quizResult = response.data;
      print(quizResult);

      if (quizResult?['totalCorrect'] == 0 && quizResult?['totalWrong'] == 0) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => ResultQuizPage(
                  questions: widget.questions,
                  answers: _answers,
                  quizResult: quizResult,
                )));
      } else if (quizResult?['totalWrong'] == 0) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          borderSide: const BorderSide(
            color: Colors.green,
            width: 2,
          ),
          width: 330,
          buttonsBorderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
          dismissOnTouchOutside: true,
          dismissOnBackKeyPress: false,
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'CHÚC MỪNG',
          desc: 'Bạn đã nhận được 01 điểm thưởng',
          btnCancelText: "Để sau",
          btnOkText: "Đổi sách",
          showCloseIcon: true,
          btnCancelOnPress: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => ResultQuizPage(
                      questions: widget.questions,
                      answers: _answers,
                      quizResult: quizResult,
                    )));
          },
          btnOkOnPress: () {
            Get.to(RewardsPage());
          },
        ).show();
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => ResultQuizPage(
                  questions: widget.questions,
                  answers: _answers,
                  quizResult: quizResult,
                )));
      }
    }
  }

  startTimer() {
    controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
    setState(() {
      isPlaying = true;
    });
  }

  int _currentIndex = 0;
  List<List<int>> _answers = [];
  List<QuestionResult>? _questionResults = [];
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    InternetPopup().initialize(context: context);
    super.initState();
    _answers = List.generate(widget.questions.length, (_) => []);
    print('Timer: ${widget.data2?['duration'].toString()}');
    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: widget.data2?['duration']),
    );
    controller.addListener(() async {
      final connectivityResult = await (Connectivity().checkConnectivity());
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
        if (connectivityResult == ConnectivityResult.none) {
          controller.stop();
          setState(() {
            isPlaying = false;
          });
        }
        if (connectivityResult != ConnectivityResult.wifi &&
            connectivityResult != ConnectivityResult.mobile) {
          controller.reverse(
              from: controller.value == 0 ? 1.0 : controller.value);
          setState(() {
            progress = controller.value;
            isPlaying = true;
          });
        }
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = true;
        });
      }
    });
    startTimer();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Question question = widget.questions[_currentIndex];
    final List<Answers>? options = question.answers;
    if (options != null && options.contains(question.answers)) {
      options.addAll(question.answers!);
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.indigo.shade900,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: GestureDetector(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Thông báo'),
                      content: Text(
                          'Bạn có chắc chắn muốn thoát khỏi bài kiểm tra không? Tất cả tiến trình của bạn sẽ bị mất.'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Không'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Có'),
                          onPressed: () {
                            Get.to(PracticePage());
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
          title: Image.asset(
            'assets/images/logo-b4usolution.png',
            fit: BoxFit.contain,
            height: 32,
          ),
        ),
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            key: _key,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // title: Center(child: Text('TOEIC PRACTICE')),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Stack(
              children: <Widget>[
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
                  padding: const EdgeInsets.only(top: 100, left: 18.0),
                  child: Container(
                    color: Color.fromARGB(255, 0, 79, 143),
                    child: Text('Time left: ' + countText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 130, left: 16.0, right: 16.0),
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (context, child) => LinearPercentIndicator(
                      width: 310,
                      animateFromLastPercent: true,
                      lineHeight: 7.0,
                      percent: progress,
                      progressColor: Color.fromARGB(244, 255, 251, 42),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 180.0, left: 16.0, right: 16.0, bottom: 16.0),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white70,
                            child: Text("${_currentIndex + 1}"),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  HtmlUnescape().convert(
                                      widget.questions[_currentIndex].content!),
                                  softWrap: true,
                                  style: MediaQuery.of(context).size.width > 800
                                      ? _questionStyle.copyWith(fontSize: 30.0)
                                      : _questionStyle,
                                ),
                                widget.questions[_currentIndex].isMultiChoice ==
                                        true
                                    ? Text(' (Chọn nhiều đáp án)',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white))
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ...options!
                                .map((answer) => widget.questions[_currentIndex]
                                            .isMultiChoice ==
                                        true
                                    ? CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        title: Text(
                                          HtmlUnescape()
                                              .convert("${answer.content}"),
                                          style: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? TextStyle(fontSize: 30.0)
                                              : null,
                                        ),
                                        value: answer.selected ?? false,
                                        onChanged: (val) {
                                          print(val);
                                          setState(() {
                                            answer.selected = val;
                                            if (_answers[_currentIndex]
                                                .contains(answer.id)) {
                                              _answers[_currentIndex]
                                                  .remove(answer.id);
                                            } else {
                                              _answers[_currentIndex]
                                                  .add(answer.id!);
                                            }
                                            print(_answers[_currentIndex]);
                                          });
                                        })
                                    : RadioListTile<int>(
                                        title: Text(
                                          HtmlUnescape()
                                              .convert("${answer.content}"),
                                          style: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  800
                                              ? TextStyle(fontSize: 30.0)
                                              : null,
                                        ),
                                        groupValue:
                                            _answers[_currentIndex].isNotEmpty
                                                ? _answers[_currentIndex][0]
                                                : null,
                                        value: answer.id!,
                                        onChanged: (int? value) {
                                          print(value);
                                          setState(() {
                                            _answers[_currentIndex] = [value!];
                                            print(_answers[_currentIndex]);
                                          });
                                        },
                                      ))
                                .toList(),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: _currentIndex == 0
                                ? Container()
                                : ElevatedButton(
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
                                      "Câu trước",
                                      style: MediaQuery.of(context).size.width >
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
                                padding: MediaQuery.of(context).size.width > 800
                                    ? const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 64.0)
                                    : null,
                              ),
                              child: Text(
                                _currentIndex == (widget.questions.length - 1)
                                    ? "Kết quả"
                                    : "Câu tiếp theo",
                                style: MediaQuery.of(context).size.width > 800
                                    ? TextStyle(fontSize: 30.0)
                                    : null,
                              ),
                              onPressed: _nextSubmit,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        )
        // )

        );
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

  void _nextSubmit() async {
    if (_answers[_currentIndex].isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Bạn phải chọn một câu trả lời để tiếp tục."),
      ));
      return;
    }

    final questionId = widget.questions[_currentIndex].id;
    print(questionId);
    final answerId = _answers[_currentIndex];
    print(answerId);
    final questionResult =
        QuestionResult(questionId: questionId, answerId: answerId);
    _questionResults?.add(questionResult);
    print(questionResult);

    if (_currentIndex < (widget.questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else if (!_resultSent) {
      _resultSent = true;
      String? token;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');

      var formData =
          _questionResults?.map((result) => result.toJson()).toList();
      print(formData);

      final dio = Dio(); // Create Dio instance
      final response = await dio.post(
          'http://103.77.166.202/api/quiz/check-result',
          options: Options(
              contentType: 'application/json',
              headers: {'Authorization': 'Bearer $token'}),
          data: formData);
      quizResult = response.data;
      print(quizResult);

      if (quizResult?['totalWrong'] == 0) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          borderSide: const BorderSide(
            color: Colors.green,
            width: 2,
          ),
          width: 330,
          buttonsBorderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
          dismissOnTouchOutside: true,
          dismissOnBackKeyPress: false,
          headerAnimationLoop: false,
          animType: AnimType.bottomSlide,
          title: 'CHÚC MỪNG',
          desc: 'Bạn đã nhận được 01 điểm thưởng',
          btnCancelText: "Để sau",
          btnOkText: "Đổi sách",
          showCloseIcon: false,
          btnCancelOnPress: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => ResultQuizPage(
                      questions: widget.questions,
                      answers: _answers,
                      quizResult: quizResult,
                    )));
          },
          btnOkOnPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RewardsPage()),
            );
          },
        ).show();
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => ResultQuizPage(
                  questions: widget.questions,
                  answers: _answers,
                  quizResult: quizResult,
                )));
      }
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

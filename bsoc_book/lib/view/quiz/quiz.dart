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

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  final TextStyle _questionStyle = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);

  ConnectivityResult connectivity = ConnectivityResult.none;
  late AnimationController controller;
  bool isLoading = true;
  bool isPlaying = false;
  // int seconds = 3600;
  // Timer? timer;

  double progress = 1.0;

  Future<void> callback() async {
    if (connectivity == ConnectivityResult.none) {
      isLoading = true;
    } else {}
  }

  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${controller.duration!.inHours}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void notify() {
    if (countText == '0:00:00') {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) =>
              ResultQuizPage(questions: widget.questions, answers: _answers)));
    }
  }

  startTimer() {
    controller.reverse(from: controller.value == 0 ? 1.0 : controller.value);
    setState(() {
      isPlaying = true;
    });
  }

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    callback();
    super.initState();

    // TÙY CHỈNH THỜI GIAN CÂU HỎI Ở PHẦN DURATION
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 180),
    );

    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
          // print(progress);
        });
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
    final List<dynamic> options = question.incorrectAnswers!;
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
              final connected = connectivity != ConnectivityResult.none;
              return Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  Positioned(
                    height: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      color: connected
                          ? const Color(0xFF00EE44)
                          : const Color(0xFFEE4400),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: connected
                            ? const Text('ONLINE')
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Text('OFFLINE'),
                                  SizedBox(width: 8.0),
                                  SizedBox(
                                    width: 12.0,
                                    height: 12.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              );
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
                          top: 200, left: 8.0, right: 16.0),
                      child: AnimatedBuilder(
                        animation: controller,
                        builder: (context, child) => LinearPercentIndicator(
                          width: 280,
                          animateFromLastPercent: true,
                          lineHeight: 20.0,
                          trailing: Text(
                            countText,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          percent: progress,
                          progressColor: Color.fromARGB(244, 193, 255, 114),
                        ),
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
                                  HtmlUnescape().convert(widget
                                      .questions[_currentIndex].question!),
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
    if (_currentIndex < (widget.questions.length + 1)) {
      setState(() {
        _currentIndex--;
      });
    }
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
      controller.reset();
      setState(() {
        isPlaying = false;
      });
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

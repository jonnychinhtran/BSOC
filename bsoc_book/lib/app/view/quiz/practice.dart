import 'package:bsoc_book/app/models/quiz/list_subject_model.dart';
import 'package:bsoc_book/app/view/quiz/quiz_page_view.dart';
import 'package:bsoc_book/app/view_model/quiz_view_model.dart';
import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/config/routes.dart';
import 'package:bsoc_book/app/view/quiz/components/quiz_options.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class QuizHomePage extends StatefulWidget {
  const QuizHomePage({
    super.key,
    required this.quizViewModel,
    required this.parentViewState,
  });

  final QuizViewModel quizViewModel;
  final QuizPageViewState parentViewState;

  @override
  State<QuizHomePage> createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  late QuizViewModel _quizViewModel;
  bool _loadingIsWaiting = false;

  int? _noOfQuestions;

  String? dropdownValue;

  List<ListSubjectModel>? categoryList;

  String? selectedStandardName;

  void goHome() {
    Application.router.navigateTo(context, Routes.app, clearStack: true);
  }

  @override
  void initState() {
    _quizViewModel = widget.quizViewModel;
    _quizViewModel.getListSubjectQuiz().then((value) {
      if (value != null) {
        setState(() {
          categoryList = value
            ..sort((a, b) => a.name.toString().compareTo(b.name.toString()));
        });
      }
    });

    _quizViewModel.subjectQuizModelSubjectStream.listen((value) {
      if (mounted) {
        setState(() {
          _loadingIsWaiting = value;
        });
      }
    });

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
          title: Image.asset(
            'assets/images/logo-b4usolution.png',
            fit: BoxFit.contain,
            height: 32,
          ),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                    Icons.arrow_back), // Put icon of your preference.
                onPressed: () {
                  goHome();
                },
              );
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            // fetchCategories();
          },
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: StreamBuilder<bool>(
                stream: _quizViewModel.subjectQuizModelSubjectStream,
                builder: (context, snapshot) {
                  if (categoryList != null) {
                    return Stack(children: [
                      Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/bg1.png'),
                              fit: BoxFit.cover,
                            ),
                          )),
                      SafeArea(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, left: 16.0, right: 16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Favorites of the',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: size.height * 0.02),
                                const Text(
                                  'B4U',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900),
                                ),
                                SizedBox(height: size.height * 0.01),
                                const Text(
                                  'BSOC APP',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900),
                                ),
                                SizedBox(height: size.height * 0.04),
                                Container(
                                    height: 100,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/icon1.png'),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    )),
                                SizedBox(height: size.height * 0.03),
                                const Text(
                                  'LỰA CHỌN CHỦ ĐỀ:',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                ),
                                SizedBox(height: size.height * 0.03),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16.0),
                                    child: DropdownButton<String>(
                                      dropdownColor: Colors.white,
                                      isExpanded: true,
                                      value: dropdownValue,
                                      hint: dropdownValue == null
                                          ? const Text('Chọn đề thi')
                                          : null,
                                      icon: const Icon(
                                        Icons.arrow_downward,
                                        color: Color.fromARGB(255, 226, 66, 66),
                                      ),
                                      underline: Container(
                                        height: 0,
                                      ),
                                      iconSize: 24,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 226, 66, 66),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      items: categoryList!
                                          .map<DropdownMenuItem<String>>(
                                              (ListSubjectModel standard) {
                                        return DropdownMenuItem<String>(
                                          value: standard.id.toString(),
                                          child: Text(standard.name.toString()),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) async {
                                        setState(() {
                                          dropdownValue = newValue!;
                                          selectedStandardName = categoryList!
                                              .firstWhere((standard) =>
                                                  standard.id.toString() ==
                                                  dropdownValue)
                                              .name
                                              .toString();
                                        });
                                        _noOfQuestions =
                                            int.parse(dropdownValue.toString());
                                        // print('No OF QUESTION ${_noOfQuestions}');
                                        _quizViewModel
                                            .getSubjectInfoBottom(
                                                _noOfQuestions)
                                            .then((value) => {
                                                  if (value != null)
                                                    {
                                                      setState(() {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          builder:
                                                              (sheetContext) =>
                                                                  BottomSheet(
                                                            builder: (_) =>
                                                                Container(
                                                              height: 190,
                                                              child:
                                                                  QuizOptionsDialog(
                                                                parentViewState:
                                                                    widget
                                                                        .parentViewState,
                                                                quizViewModel:
                                                                    _quizViewModel,
                                                                idPractice:
                                                                    dropdownValue,
                                                                headquestions:
                                                                    value,
                                                                selectedStandardName:
                                                                    selectedStandardName,
                                                              ),
                                                            ),
                                                            onClosing: () {},
                                                          ),
                                                        );
                                                      }),
                                                      // print(
                                                      //     'Subject Info Model: ${value}')
                                                    }
                                                });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]);
                  } else {
                    return Center(
                        child: LoadingAnimationWidget.discreteCircle(
                      color: const Color.fromARGB(255, 138, 175, 52),
                      secondRingColor: Colors.black,
                      thirdRingColor: Colors.purple,
                      size: 30,
                    ));
                  }
                }),
          ),
        )
        // )
        );
  }
}

import 'dart:convert';

import 'package:bsoc_book/app/models/quiz/list_subject_model.dart';
import 'package:bsoc_book/app/view/quiz/quiz_page_view.dart';
import 'package:bsoc_book/app/view_model/quiz_view_model.dart';
import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/config/routes.dart';
import 'package:bsoc_book/data/model/quiz/question2.dart';
import 'package:bsoc_book/data/network/api_subject_infor.dart';
import 'package:bsoc_book/app/view/quiz/components/quiz_options.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bsoc_book/data/model/quiz/category.dart';
import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:bsoc_book/data/network/api_question.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // final CategoryController categoryController = Get.put(CategoryController());
  // final AuthController authController = Get.find();
  // ConnectivityResult connectivity = ConnectivityResult.none;
  // bool isLoading = true;
  // String? token;
  int? _noOfQuestions;
  // Future<void> callback() async {
  //   if (connectivity == ConnectivityResult.none) {
  //     isLoading = true;
  //   } else {
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) => QuizHomePage()),
  //         (Route<dynamic> route) => false);
  //   }
  // }

  String? dropdownValue;

  List<ListSubjectModel>? categoryList = [];

  // Future<void> fetchCategories() async {
  //   try {
  //     // final prefs = await SharedPreferences.getInstance();
  //     // token = prefs.getString('accessToken');
  //     final box = GetStorage();
  //     token = box.read('accessToken');
  //     print('Token Category Question: $token');
  //     var response = await Dio().get(
  //         'http://103.77.166.202/api/quiz/list-subject',
  //         options: Options(headers: {'Authorization': 'Bearer $token'}));
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = (response.data);
  //       setState(() {
  // categoryList = data.map((json) => Category.fromJson(json)).toList()
  //   ..sort((a, b) => a.name.toString().compareTo(b.name.toString()));
  //         print(categoryList);
  //         // dropdownValue = categoryList[0].id.toString();
  //         isLoading = false;
  //       });
  //     } else {
  //       Get.snackbar("Lỗi", "Lấy dữ liệu thất bại. Thử lại.");
  //     }
  //     print("res: ${response.data}");
  //   } catch (e) {
  //     // Get.snackbar("error", e.toString());
  //     print(e);
  //   }
  // }

  String? selectedStandardName;

  void goHome() {
    Application.router.navigateTo(context, Routes.app, clearStack: true);
  }

  @override
  void initState() {
    _quizViewModel = widget.quizViewModel;
    // callback();
    // fetchCategories();
    _quizViewModel.getListSubjectQuiz().then((value) {
      print('List Subject Quiz: $value');
      if (value != null) {
        // setState(() {
        categoryList = (value)
          ..sort((a, b) => a.name.toString().compareTo(b.name.toString()));
        print('Category List Quiz  $categoryList');
        // dropdownValue = categoryList[0].id.toString();
        // selectedStandardName = categoryList[0].name.toString();
        // });
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

    // InternetPopup().initialize(context: context);
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
          child: Stack(children: [
            Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg1.png'),
                    fit: BoxFit.cover,
                  ),
                )),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, left: 16.0, right: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Favorites of the',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        'B4U',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        'BSOC APP',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: size.height * 0.04),
                      Container(
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/icon1.png'),
                              fit: BoxFit.fitHeight,
                            ),
                          )),
                      SizedBox(height: size.height * 0.03),
                      Text(
                        'LỰA CHỌN CHỦ ĐỀ:',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: DropdownButton<String>(
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            value: dropdownValue,
                            hint: dropdownValue == null
                                ? Text('Chọn đề thi')
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
                            items: categoryList!.map<DropdownMenuItem<String>>(
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
                                        standard.id.toString() == dropdownValue)
                                    .name
                                    .toString();
                              });
                              _noOfQuestions =
                                  int.parse(dropdownValue.toString());
                              print('No OF QUESTION ${_noOfQuestions}');

                              await getSubject2(_noOfQuestions);
                              showModalBottomSheet(
                                context: context,
                                builder: (sheetContext) => BottomSheet(
                                  builder: (_) => Container(
                                    height: 190,
                                    child: QuizOptionsDialog(
                                      idPractice: dropdownValue,
                                      headquestions: headquestions,
                                      selectedStandardName:
                                          selectedStandardName,
                                    ),
                                  ),
                                  onClosing: () {},
                                ),
                              );
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
          ]),
        )
        // )
        );
  }
}

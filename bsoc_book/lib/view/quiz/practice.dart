import 'dart:convert';

import 'package:bsoc_book/data/model/quiz/question2.dart';
import 'package:bsoc_book/data/network/api_subject_infor.dart';
import 'package:bsoc_book/view/quiz/quiz_options.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:bsoc_book/data/model/quiz/category.dart';
import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:bsoc_book/data/network/api_question.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bsoc_book/controller/authen/authen_controller.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? dropdownValue;

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  // final CategoryController categoryController = Get.put(CategoryController());
  final AuthController authController = Get.find();
  ConnectivityResult connectivity = ConnectivityResult.none;
  bool isLoading = true;
  String? token;
  int? _noOfQuestions;
  Future<void> callback() async {
    if (connectivity == ConnectivityResult.none) {
      isLoading = true;
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PracticePage()),
          (Route<dynamic> route) => false);
    }
  }

  List<Category> categoryList = <Category>[];

  Future<void> fetchCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      var response = await Dio().get(
          'http://103.77.166.202/api/quiz/list-subject',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          categoryList = data.map((json) => Category.fromJson(json)).toList();

          print(categoryList);
          dropdownValue = categoryList[0].id.toString();
          isLoading = false;
        });
      } else {
        Get.snackbar("Lỗi", "Lấy dữ liệu thất bại. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      // Get.snackbar("error", e.toString());
      print(e);
    }
  }

  @override
  void initState() {
    callback();
    fetchCategories();
    super.initState();
    InternetPopup().initialize(context: context);
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
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                },
              );
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            fetchCategories();
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
                          height: 150,
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
                      Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            // color: Colors.white,
                            decoration: BoxDecoration(
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
                                value: dropdownValue == null
                                    ? "Chọn đề thi"
                                    : dropdownValue, // create a variable named dropdownValue and set in onChange function
                                icon: const Icon(
                                  Icons.arrow_downward,
                                  color: Color.fromARGB(255, 226, 66, 66),
                                ),
                                hint: Text('Chọn đề thi'),
                                iconSize: 24,
                                elevation: 1,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 226, 66, 66),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                items: categoryList
                                    .map<DropdownMenuItem<String>>(
                                        (Category standard) {
                                  return DropdownMenuItem<String>(
                                    value: standard.id.toString(),
                                    child: Text(standard.name.toString()),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) async {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                  _noOfQuestions =
                                      int.parse(dropdownValue.toString());
                                  print(_noOfQuestions);

                                  await getSubject2(_noOfQuestions);
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (sheetContext) => BottomSheet(
                                      builder: (_) => QuizOptionsDialog(
                                        idPractice: dropdownValue,
                                        headquestions: headquestions,
                                      ),
                                      onClosing: () {},
                                    ),
                                  );
                                },
                              ),
                            ),
                          )),
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

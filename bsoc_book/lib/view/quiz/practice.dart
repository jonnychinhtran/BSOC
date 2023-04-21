import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:bsoc_book/controller/quiz/category_controller.dart';
import 'package:bsoc_book/data/model/quiz/category.dart';
import 'package:bsoc_book/data/model/quiz/question.dart';
import 'package:bsoc_book/data/network/api_question.dart';
import 'package:bsoc_book/view/quiz/quiz.dart';
import 'package:bsoc_book/view/quiz/topic_practice.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:bsoc_book/view/widgets/alert_dailog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:bsoc_book/controller/authen/authen_controller.dart';
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
          'http://103.77.166.202:9999/api/quiz/list-subject',
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
      Get.snackbar("error", e.toString());
      print(e);
    }
  }

  @override
  void initState() {
    callback();
    fetchCategories();
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
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                },
              );
            },
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
                  image: AssetImage('assets/images/bg1.png'),
                  fit: BoxFit.cover,
                ),
              )),
          SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(height: size.height * 0.08),
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
                        padding: const EdgeInsets.all(16.0),
                        child: DropdownButton<String>(
                          value: dropdownValue == null
                              ? ""
                              : dropdownValue, // create a variable named dropdownValue and set in onChange function
                          icon: const Icon(Icons.arrow_downward,
                              color: Colors.white),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 226, 66, 66),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: categoryList.map<DropdownMenuItem<String>>(
                              (Category standard) {
                            return DropdownMenuItem<String>(
                              value: standard.id.toString(),
                              child: Text(standard.name.toString()),
                            );
                          }).toList(),
                        )),
                    SizedBox(height: size.height * 0.01),
                    ElevatedButton(
                        onPressed: () async {
                          _noOfQuestions = int.parse(dropdownValue.toString());
                          print(_noOfQuestions);
                          List<Question> questions =
                              await getQuestions(_noOfQuestions);
                          if (headquestion!['totalQuestion'] == 0) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Thông báo"),
                                  content: Text("Đề thi đang được cập nhật"),
                                  actions: [
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QuizPage(
                                          questions: questions,
                                          headquestion: headquestion,
                                        )));
                          }
                        },
                        child: Text('Bắt đầu thi')),
                  ],
                ),
              ),
            ),
          )
        ])
        // )
        );
  }
}

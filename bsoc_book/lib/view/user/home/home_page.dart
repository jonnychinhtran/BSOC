import 'dart:async';
import 'dart:convert';
import 'package:auto_reload/auto_reload.dart';
import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/data/model/books/book_model.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/quiz/practice.dart';
import 'package:bsoc_book/view/quiz/quiz.dart';
import 'package:bsoc_book/view/search/search_page.dart';
import 'package:bsoc_book/view/user/book/book_detail_page.dart';
import 'package:bsoc_book/view/widgets/menu_aside.dart';
import 'package:bsoc_book/view/widgets/updatedialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:social_media_flutter/social_media_flutter.dart';

String? demo;
Map? mapDemo;
Map? demoReponse;
List? listReponse;
List? listTop;

enum RequestStatus {
  success,
  error,
}

enum Content {
  success,
  error,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConnectivityResult connectivity = ConnectivityResult.none;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = true;
  List<Content> id = [];

  Future<void> getAllBooks() async {
    String? token;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      var response = await Dio().get('http://103.77.166.202/api/book/all-book',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        mapDemo = response.data;
        listReponse = mapDemo!['content'];
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        Get.offAll(LoginPage());
      }
      print("res: ${response.data}");
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        // Get.dialog(DialogError());
      } else {
        // Get.snackbar("error", e.toString());
        print(e);
        rethrow;
      }
    }
  }

  Future<void> getTopBook() async {
    String? token;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      var response = await Dio().get('http://103.77.166.202/api/book/top-book',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        setState(() {
          listTop = response.data;
          print('topbok: $listTop ');
          isLoading = false;
        });
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        Get.offAll(LoginPage());
      }
      print("res: ${response.data}");
    } on DioError catch (e) {
      if (e.isNoConnectionError) {
        // Get.dialog(DialogError());
      } else {
        // Get.snackbar("error", e.toString());
        print(e);
        rethrow;
      }
    }
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') ?? '';
  }

  final _autoRequestManager = AutoRequestManager(minReloadDurationSeconds: 5);
  final _autoRequestManager2 = AutoRequestManager(minReloadDurationSeconds: 5);
  late List<RequestStatus> _requestStatuses;
  late List<Content> _requestApi;

  @override
  void initState() {
    getAllBooks();
    getTopBook();

    _requestStatuses = List.generate(5, (idx) {
      _autoRequestManager.autoReload(
        id: idx.toString(),
        toReload: getTopBook,
      );
      return RequestStatus.error;
    });

    _requestApi = List.generate(5, (idx) {
      _autoRequestManager2.autoReload(
        id: idx.toString(),
        toReload: getAllBooks,
      );
      return Content.error;
    });

    final newVersion = NewVersion(
      iOSId: 'com.b4usolution.app.bsoc',
      androidId: 'com.b4usolution.b4u_bsoc',
    );
    checkNewVersion(newVersion);
    super.initState();
  }

  void checkNewVersion(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      if (status.canUpdate) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return UpdateDialog(
              allowDismissal: true,
              description: status.releaseNotes!,
              version: status.storeVersion,
              appLink: status.appStoreLink,
            );
          },
        );
      }
      print(status.appStoreLink);
      print(status.storeVersion);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          drawer: MenuAside(),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 138, 175, 52),
            centerTitle: true,
            title: const Text('B4U BSOC'),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                },
              ),
              Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.white,
                    iconTheme: IconThemeData(color: Colors.white),
                    textTheme: TextTheme().apply(bodyColor: Colors.white),
                  ),
                  child: PopupMenuButton<int>(
                      color: Colors.white,
                      itemBuilder: (context) => [
                            PopupMenuItem<int>(
                              value: 0,
                              child: SocialWidget(
                                placeholderText: 'B4U Solution',
                                iconData: SocialIconsFlutter.facebook_box,
                                link:
                                    'https://www.facebook.com/groups/376149517873940',
                                iconColor: Color.fromARGB(255, 0, 170, 255),
                                placeholderStyle: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: SocialWidget(
                                placeholderText: 'B4U Solution',
                                iconData: SocialIconsFlutter.linkedin_box,
                                link:
                                    'https://www.linkedin.com/in/b4usolution-b16383128/',
                                iconColor: Colors.blueGrey,
                                placeholderStyle: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: SocialWidget(
                                placeholderText: 'B4U Solution',
                                iconData: SocialIconsFlutter.youtube,
                                link:
                                    'https://www.youtube.com/channel/UC1UDTdvGiei6Lc4ei7VzL_A',
                                iconColor: Colors.red,
                                placeholderStyle: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 3,
                              child: SocialWidget(
                                placeholderText: 'B4U Solution',
                                iconData: SocialIconsFlutter.twitter,
                                iconColor: Colors.lightBlue,
                                link: 'https://twitter.com/b4usolution',
                                placeholderStyle: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 4,
                              child: SocialWidget(
                                placeholderText: 'B4U Solution',
                                iconData: Icons.people,
                                iconColor: Colors.lightBlue,
                                link: 'https://www.slideshare.net/b4usolution/',
                                placeholderStyle: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ])),
            ],
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
              child: isLoading
                  ? Center(
                      child: LoadingAnimationWidget.discreteCircle(
                      color: Color.fromARGB(255, 138, 175, 52),
                      secondRingColor: Colors.black,
                      thirdRingColor: Colors.purple,
                      size: 30,
                    ))
                  : RefreshIndicator(
                      onRefresh: () async {
                        getAllBooks();
                        getTopBook();
                      },
                      child: SafeArea(
                        child: SingleChildScrollView(
                          physics: ScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: size.height * 0.02),
                              Padding(
                                padding: const EdgeInsets.only(left: 13.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Top 5 sách hay',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 200,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        listTop == null ? 0 : listTop!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            final SharedPreferences? prefs =
                                                await _prefs;
                                            await prefs?.setString(
                                                'idbook',
                                                listTop![index]['id']
                                                    .toString());

                                            print(
                                                'idBook: ${listTop![index]['id'].toString()}');

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailBookPage(
                                                            id: listTop![index]
                                                                    ['id']
                                                                .toString())));
                                          },
                                          child: SizedBox(
                                            child: Image.network(
                                                listTop![index]['image'] == null
                                                    ? "Đang tải..."
                                                    : 'http://103.77.166.202' +
                                                        listTop![index]
                                                            ['image']),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              SizedBox(height: size.height * 0.04),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 14.0, right: 14.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Luyện thi IELTS - TOEIC - IT',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PracticePage()));
                                        },
                                        child: Text(
                                          'Xem thêm',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             QuizPage()));
                                          },
                                          child: Container(
                                            width: 150,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(0, 1),
                                                  blurRadius: 5,
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                Offset(0, 1),
                                                            blurRadius: 1,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: AssetImage(
                                                                "assets/images/luyenthi.jpg"))),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.01),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Color.fromARGB(
                                                                255, 213, 247, 250),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    6.0)),
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    6.0),
                                                            child: Text("IELTS",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        8.0,
                                                                    fontWeight:
                                                                        FontWeight.w500)))),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.01),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        'FUILL TEST - ALL PART 1',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text('200 Questions',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text('ETS 2019',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             QuizPage()));
                                          },
                                          child: Container(
                                            width: 150,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(0, 1),
                                                  blurRadius: 5,
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                Offset(0, 1),
                                                            blurRadius: 5,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: AssetImage(
                                                                "assets/images/luyenthi.jpg"))),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.01),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Color.fromARGB(
                                                                255, 213, 247, 250),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    6.0)),
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    6.0),
                                                            child: Text("IELTS",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        8.0,
                                                                    fontWeight:
                                                                        FontWeight.w500)))),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.01),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        'FUILL TEST - ALL PART 1',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text('200 Questions',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text('ETS 2019',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             QuizPage()));
                                          },
                                          child: Container(
                                            width: 150,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(0, 1),
                                                  blurRadius: 5,
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 70,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            offset:
                                                                Offset(0, 1),
                                                            blurRadius: 5,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            image: AssetImage(
                                                                "assets/images/luyenthi.jpg"))),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.01),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Color.fromARGB(
                                                                255, 213, 247, 250),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    6.0)),
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    6.0),
                                                            child: Text("IELTS",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        8.0,
                                                                    fontWeight:
                                                                        FontWeight.w500)))),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.01),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        'FUILL TEST - ALL PART 1',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text('200 Questions',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text('ETS 2019',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.02),
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Thư viện sách',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: listReponse == null
                                        ? 0
                                        : listReponse!.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 2 / 3.7),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    listReponse![index]['id']
                                                        .toString();
                                                    final SharedPreferences?
                                                        prefs = await _prefs;
                                                    await prefs?.setString(
                                                        'idbook',
                                                        listReponse![index]
                                                                ['id']
                                                            .toString());

                                                    print(
                                                        'idBook: ${listReponse![index]['id'].toString()}');
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                DetailBookPage(
                                                                    id: listReponse![index]
                                                                            [
                                                                            'id']
                                                                        .toString())));
                                                  },
                                                  child: Container(
                                                    height: size.height * 0.25,
                                                    width: size.width * 0.4,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            image: NetworkImage(
                                                              listReponse?[index]
                                                                          [
                                                                          'image'] ==
                                                                      null
                                                                  ? "Đang tải..."
                                                                  : 'http://103.77.166.202' +
                                                                      listReponse?[
                                                                              index]
                                                                          [
                                                                          'image'],
                                                            ))),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: size.height * 0.02),
                                                Container(
                                                  child: Text(
                                                    listReponse?[index]
                                                                ['bookName'] ==
                                                            null
                                                        ? "Đang tải..."
                                                        : listReponse?[index]
                                                            ['bookName'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 4,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text(
                                                  listReponse?[index]
                                                              ['author'] ==
                                                          null
                                                      ? "Đang tải..."
                                                      : 'bởi :' +
                                                          listReponse?[index]
                                                              ['author'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ]),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.grey.shade800,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                      child: Column(
                                    children: [
                                      Text(
                                        "© B4USOLUTION. All Rights Reserved.",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        "Privacy Policy Designed by B4USOLUTION",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      )
                                    ],
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
        ));
  }
}

class DialogLogout extends StatelessWidget {
  DialogLogout({super.key});
  final userdata = GetStorage();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thông báo'),
      content: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Lỗi tải hệ thống, vui lòng đăng nhập lại'),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              primary: Colors.blueAccent,
              minimumSize: const Size.fromHeight(35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('accessToken');
              await prefs.clear();
              userdata.write('isLogged', false);
              Get.offAll(LoginPage());
            },
            child: Text('Đăng nhập lại'),
          ),
        ],
      )),
    );
  }
}

class DialogError extends StatelessWidget {
  DialogError({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thông báo'),
      content: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Mất kết nối mạng internet/4G, vui lòng thử lại'),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              primary: Colors.blueAccent,
              minimumSize: const Size.fromHeight(35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Thoát'),
          ),
        ],
      )),
    );
  }
}

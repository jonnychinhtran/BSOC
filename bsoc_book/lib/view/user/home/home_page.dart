import 'dart:async';
import 'package:bsoc_book/controller/authen/authen_controller.dart';
import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/data/model/books/allbook_model.dart';
import 'package:bsoc_book/data/model/books/topbook_model.dart';
import 'package:bsoc_book/view/banner/company_page.dart';
import 'package:bsoc_book/view/banner/job_page.dart';
import 'package:bsoc_book/view/infor/infor_page.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/quiz/practice.dart';
import 'package:bsoc_book/view/search/search_page.dart';
import 'package:bsoc_book/view/user/book/book_detail_page.dart';
import 'package:bsoc_book/view/widgets/alert_dailog.dart';
import 'package:bsoc_book/view/widgets/menu_aside.dart';
import 'package:bsoc_book/view/widgets/updatedialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_flutter/social_media_flutter.dart';

Map? databook;
List? bookList;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController authController = Get.find();
  ConnectivityResult connectivity = ConnectivityResult.none;
  List<AllBookModel> listbook = [];
  List<TopbookModel> topbook = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = true;

  @override
  void initState() {
    InternetPopup().initialize(context: context);
    callback();
    getAllBooks();
    getTopBook();
    super.initState();

    final newVersion = NewVersion(
      iOSId: 'com.b4usolution.app.bsoc',
      androidId: 'com.b4usolution.b4u_bsoc',
    );
    checkNewVersion(newVersion);
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
        final List<dynamic> data = response.data['content'];
        setState(() {
          listbook = data.map((json) => AllBookModel.fromJson(json)).toList();
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
        Get.snackbar("error", e.toString());
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
        List<dynamic> data = response.data;
        setState(() {
          topbook = data.map((json) => TopbookModel.fromJson(json)).toList();
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
        Get.snackbar("error", e.toString());
        print(e);
        rethrow;
      }
    }
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') ?? '';
  }

  Future<void> callback() async {
    if (connectivity == ConnectivityResult.none) {
      isLoading = true;
    } else {
      getAllBooks();
      getTopBook();
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'B4U BSOC',
              style: TextStyle(color: Colors.black),
            ),
            leading: IconButton(
              icon: Icon(Icons.person_outline_rounded),
              color: Colors.black,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InforPage()));
              },
            ),
            actions: [
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
          body: callback == 0 && topbook.length == 0
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
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              height: 40,
                              child: TextField(
                                showCursor: true,
                                readOnly: true,
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchPage()));
                                },
                                decoration: InputDecoration(
                                  hintText: "Tìm kiếm sách",
                                  fillColor: Colors.grey[300],
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 12),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  focusedBorder: InputBorder.none,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CompanyPage()));
                                },
                                child: Container(
                                    // width: 160,
                                    child: Image.asset(
                                        'assets/images/banner1.png',
                                        fit: BoxFit.fill)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => JobPage()));
                                },
                                child: Container(
                                    // width: 160,
                                    child: Image.asset(
                                        'assets/images/banner2.png',
                                        fit: BoxFit.fill)),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (authController.isLoggedIn.value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PracticePage()));
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertPageDialog(),
                                  );
                                }
                              },
                              child: Image.asset('assets/images/practice2.png'),
                            ),
                          ),
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
                                itemCount: topbook.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final SharedPreferences? prefs =
                                            await _prefs;
                                        await prefs?.setString('idbook',
                                            topbook[index].id.toString());

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailBookPage(
                                                        id: topbook[index]
                                                            .id
                                                            .toString())));
                                      },
                                      child: SizedBox(
                                        child: Image.network(
                                            topbook[index].image == null
                                                ? "Đang tải..."
                                                : 'http://103.77.166.202' +
                                                    topbook[index]
                                                        .image
                                                        .toString()),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(height: size.height * 0.04),
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
                                itemCount: listbook.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 2 / 3.3),
                                itemBuilder: (BuildContext context, int index) {
                                  final book = listbook[index];
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
                                                final SharedPreferences? prefs =
                                                    await _prefs;
                                                await prefs?.setString('idbook',
                                                    book.id.toString());
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailBookPage(
                                                                id: book.id
                                                                    .toString())));
                                              },
                                              child: Container(
                                                height: size.height * 0.25,
                                                width: size.width * 0.4,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.fitHeight,
                                                        image: NetworkImage(
                                                          book.image == null
                                                              ? "Đang tải..."
                                                              : 'http://103.77.166.202' +
                                                                  book.image
                                                                      .toString(),
                                                        ))),
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.02),
                                            Container(
                                              child: Text(
                                                book.bookName == null
                                                    ? "Đang tải..."
                                                    : book.bookName.toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            Text(
                                              book.author == null
                                                  ? "Đang tải..."
                                                  : 'bởi :' +
                                                      book.author.toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style:
                                                  const TextStyle(fontSize: 12),
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
      // )
    );
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

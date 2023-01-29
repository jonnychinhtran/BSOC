import 'dart:async';
import 'dart:convert';
import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/data/model/books/book_model.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/search/search_page.dart';
import 'package:bsoc_book/view/user/book/book_detail_page.dart';
import 'package:bsoc_book/view/widgets/menu_aside.dart';
import 'package:bsoc_book/view/widgets/updatedialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:social_media_flutter/social_media_flutter.dart';

String? demo;
Map? mapDemo;
Map? demoReponse;
List? listReponse;
List? listTop;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = true;
  List<Content> id = [];

  Future<void> getAllBooks() async {
    String? token;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      var response = await Dio()
          .get('http://103.77.166.202/api/book/all-book',
              options: Options(headers: {
                'Authorization': 'Bearer $token',
              }))
          .timeout(Duration(seconds: 2));
      if (response.statusCode == 200) {
        setState(() {
          mapDemo = response.data;
          listReponse = mapDemo!['content'];
          isLoading = false;
        });
      } else if (response.statusCode == 400) {
        Get.dialog(DialogLogout());
      } else if (response.statusCode == 401) {
        Get.offAll(LoginPage());
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
      print("res: ${response.data}");
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        Get.dialog(DialogLogout());
      }
      if (e.response?.statusCode == 401) {
        Get.offAll(LoginPage());
      }
      if (e.isNoConnectionError) {
        Get.dialog(DialogLogout());
      } else {
        Get.snackbar("error", e.toString());
        print(e);
        rethrow;
      }
    }
  }

  Future<void> getTopBook() async {
    String? token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    var url = Uri.parse('http://103.77.166.202/api/book/top-book');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      setState(() {
        listTop = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
        isLoading = false;
      });
    } else {
      throw Exception('Lỗi tải hệ thống');
    }
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') ?? '';
  }

  @override
  void initState() {
    getAllBooks();
    getTopBook();

    final newVersion = NewVersion(
      iOSId: 'com.b4usolution.app.bsoc',
      androidId: 'com.b4usolution.b4u_bsoc',
    );
    checkNewVersion(newVersion);
    // Timer(const Duration(seconds: 2), () {

    // });
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
    isLoading
        ? LoadingAnimationWidget.discreteCircle(
            color: Colors.blue,
            secondRingColor: Colors.black,
            thirdRingColor: Colors.purple,
            size: 50,
          )
        : Text(listReponse?.toString() ?? "");
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
                              placeholderStyle:
                                  TextStyle(color: Colors.black, fontSize: 20),
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
                              placeholderStyle:
                                  TextStyle(color: Colors.black, fontSize: 20),
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
                              placeholderStyle:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 3,
                            child: SocialWidget(
                              placeholderText: 'B4U Solution',
                              iconData: SocialIconsFlutter.twitter,
                              iconColor: Colors.lightBlue,
                              link: 'https://twitter.com/b4usolution',
                              placeholderStyle:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                          PopupMenuItem<int>(
                            value: 4,
                            child: SocialWidget(
                              placeholderText: 'B4U Solution',
                              iconData: Icons.people,
                              iconColor: Colors.lightBlue,
                              link: 'https://www.slideshare.net/b4usolution/',
                              placeholderStyle:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ])),
          ],
        ),
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                ),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.02),
                      Center(
                        child: Text(
                          'TOP 5 SÁCH HAY',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: listTop == null ? 0 : listTop!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    final SharedPreferences? prefs =
                                        await _prefs;
                                    await prefs?.setString('idbook',
                                        listTop![index]['id'].toString());

                                    print(
                                        'idBook: ${listTop![index]['id'].toString()}');

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailBookPage(
                                                    id: listTop![index]['id']
                                                        .toString())));
                                  },
                                  child: SizedBox(
                                    child: Image.network(
                                        'http://103.77.166.202' +
                                            listTop?[index]['image']),
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(height: size.height * 0.04),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 4),
                          child: Center(
                            child: Text(
                              'THƯ VIỆN SÁCH',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Container(
                        // height: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                listReponse == null ? 0 : listReponse!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.8,
                                    crossAxisSpacing: 35,
                                    mainAxisSpacing: 40),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          listReponse![index]['id'].toString();
                                          final SharedPreferences? prefs =
                                              await _prefs;
                                          await prefs?.setString(
                                              'idbook',
                                              listReponse![index]['id']
                                                  .toString());

                                          print(
                                              'idBook: ${listReponse![index]['id'].toString()}');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailBookPage(
                                                          id: listReponse![
                                                                  index]['id']
                                                              .toString())));
                                        },
                                        child: Center(
                                          child: SizedBox(
                                            height: 155,
                                            width: 120,
                                            child: Image.network(
                                              'http://103.77.166.202' +
                                                  listReponse?[index]['image'],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Center(
                                        child: Text(
                                          listReponse?[index]['bookName'],
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            'bởi ${listReponse?[index]['author']}',
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ]),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 80,
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
      ),
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

import 'dart:convert';
import 'package:bsoc_book/view/search/search_page.dart';
import 'package:bsoc_book/view/user/book/book_detail_page.dart';
import 'package:bsoc_book/view/widgets/menu_aside.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bsoc_book/data/network/api_client.dart';
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

  Future<void> getAllBooks() async {
    String? token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getAllBook);
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/pdf'
    });

    if (response.statusCode == 200) {
      await prefs.setString('accessToken', token!);
      var datau = prefs.getString('accessToken');
      print(datau);
      setState(() {
        mapDemo = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
        listReponse = mapDemo?['content'];
        isLoading = false;
      });
    } else {
      throw Exception('Lỗi tải hệ thống');
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
      listTop = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
      // demoReponse = _map;
      // print(listTop[image].toString());
      // listTop =
      setState(() {
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
    super.initState();
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
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: listTop == null ? 0 : listTop?.length,
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
                                                const DetailBookPage()));
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
                        height: 500,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                            itemCount:
                                listReponse == null ? 0 : listReponse?.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.8,
                                    crossAxisSpacing: 35,
                                    mainAxisSpacing: 40),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                child: Hero(
                                  tag: listReponse![index]['id'].toString(),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
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
                                                        const DetailBookPage()));
                                          },
                                          child: Center(
                                            child: SizedBox(
                                              height: 155,
                                              width: 120,
                                              child: Image.network(
                                                'http://103.77.166.202' +
                                                    listReponse?[index]
                                                        ['image'],
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
                                              'by ${listReponse?[index]['author']}',
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        color: Colors.grey.shade800,
                        child: Center(
                            child: Column(
                          children: [
                            SizedBox(height: size.height * 0.03),
                            Text(
                              "© B4USOLUTION. All Rights Reserved.",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Privacy Policy Designed by B4USOLUTION",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        )),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}


// {BuildContext? context,
//       AppVersionResult? appVersionResult,
//       bool? mandatory = false,
//       String? title = 'New version available',
//       TextStyle titleTextStyle =
//           const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
//       String? content = 'Would you like to update your application?',
//       TextStyle contentTextStyle =
//           const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
//       ButtonStyle? cancelButtonStyle = const ButtonStyle(
//           backgroundColor: MaterialStatePropertyAll(Colors.redAccent)),
//       ButtonStyle? updateButtonStyle = const ButtonStyle(
//           backgroundColor: MaterialStatePropertyAll(Colors.green)),
//       String? cancelButtonText = 'UPDATE LATER',
//       String? updateButtonText = 'UPDATE',
//       TextStyle? cancelTextStyle = const TextStyle(color: Colors.white),
//       TextStyle? updateTextStyle = const TextStyle(color: Colors.white),
//       Color? backgroundColor = Colors.white}
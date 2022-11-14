import 'dart:convert';
import 'package:bsoc_book/routes/app_routes.dart';
import 'package:bsoc_book/view/contact/contact_page.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bsoc_book/data/network/api_client.dart';
import 'package:http/http.dart' as http;

String? demo;
Map? mapDemo;
Map? demoReponse;
List? listReponse;

class MenuAside extends StatefulWidget {
  const MenuAside({Key? key}) : super(key: key);

  @override
  State<MenuAside> createState() => _MenuAsideState();
}

class _MenuAsideState extends State<MenuAside> {
  Future<void> getInforUser() async {
    String? token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    var url =
        Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.inforUser);
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      mapDemo = jsonDecode(response.body);
      demoReponse = mapDemo;
    } else {
      throw Exception('Failed to load Infor');
    }
  }

  @override
  void initState() {
    getInforUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: <Color>[Colors.lightBlue, Colors.blue])),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      elevation: 10,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image.asset("assets/images/logo-b4usolution.png",
                            height: 60, width: 60),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      demoReponse == null
                          ? 'Data is loading'
                          : demoReponse!['username'].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(height: 5),
                    Text(
                      demoReponse == null
                          ? 'Data is loading'
                          : demoReponse!['email'].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade400))),
              child: InkWell(
                splashColor: Colors.blueGrey,
                onTap: () {
                  Get.to(MainIndexPage());
                },
                child: ListTile(
                  leading: const Icon(Icons.bookmark_added_outlined),
                  title: const Text(
                    'Thư viện sách',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.assessment_outlined),
          //   title: const Text('Rao vặt'),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade400))),
              child: InkWell(
                splashColor: Colors.blueGrey,
                onTap: () {
                  Get.to(ContactPage());
                },
                child: ListTile(
                  leading: const Icon(Icons.bookmark_added_outlined),
                  title: const Text(
                    'Liên hệ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade400))),
              child: InkWell(
                splashColor: Colors.blueGrey,
                onTap: () {
                  Get.to(ContactPage());
                },
                child: ListTile(
                  leading: const Icon(Icons.bookmark_added_outlined),
                  title: const Text(
                    'Liên hệ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade400))),
              child: InkWell(
                splashColor: Colors.blueGrey,
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('accessToken');
                  Get.offAll(LoginPage());
                },
                child: ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text(
                    'Đăng xuất',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

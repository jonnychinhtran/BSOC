import 'dart:convert';
import 'package:bsoc_book/routes/app_routes.dart';
import 'package:bsoc_book/view/login/login_page.dart';
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
      // var Data = jsonDecode(response.body);
      setState(() {
        // demo = response.body;
        mapDemo = json.decode(response.body);
        demoReponse = mapDemo;
      });

      // print(Data);
    } else {
      throw Exception('Failed to load Infor');
    }
  }

  Future<bool> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove('accessToken');
  }

  @override
  void initState() {
    getInforUser();
    logout();
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
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
                accountName: demoReponse == null
                    ? Text('Data is loading')
                    : Text(demoReponse!['username'].toString()),
                accountEmail: demoReponse == null
                    ? Text('Data is loading')
                    : Text(demoReponse!['email'].toString()),
              )),
          ListTile(
            leading: const Icon(Icons.bookmark_added_outlined),
            title: const Text('Thư viện sách'),
            onTap: () {
              // Get.toNamed(Routes.home);
            },
          ),
          ListTile(
            leading: const Icon(Icons.assessment_outlined),
            title: const Text('Rao vặt'),
          ),
          ListTile(
            leading: const Icon(Icons.contacts_outlined),
            title: const Text('Liên hệ'),
          ),
          TextButton(
              onPressed: () async {
                logout();
                Get.offAll(LoginPage());
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.only(left: -10))),
              child: const ListTile(
                leading: Icon(Icons.logout_outlined),
                title: Text('Đăng xuất'),
              )),
        ],
      ),
    );
  }
}

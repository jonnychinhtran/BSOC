import 'package:bsoc_book/data/core/infrastructure/dio_extensions.dart';
import 'package:bsoc_book/view/about/about_page.dart';
import 'package:bsoc_book/view/contact/contact_page.dart';
import 'package:bsoc_book/view/infor/infor_page.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/terms/terms_page.dart';
import 'package:bsoc_book/view/update/uploadavt_page.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isLoading = true;
  String? token;

  Future<void> getUserDetail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      var response = await Dio()
          .get('http://103.77.166.202/api/user/infor',
              options: Options(headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              }))
          .timeout(Duration(seconds: 2));
      if (response.statusCode == 200) {
        mapDemo = response.data;
        var phoneuser = mapDemo!['phone'].toString();
        var fullname = mapDemo!['fullname'].toString();
        final SharedPreferences? prefs = await _prefs;
        await prefs?.setString('phoneUser', phoneuser);

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
        Get.snackbar("error", e.toString());
        print(e);
        rethrow;
      }
    }
  }

  @override
  void initState() {
    getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Color.fromARGB(255, 138, 175, 52),
                Color.fromARGB(255, 138, 175, 52)
              ])),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UploadAvatar()));
                      },
                      child: mapDemo == null
                          ? const CircleAvatar(
                              radius: 50.0,
                              backgroundImage:
                                  AssetImage('assets/images/avatar.png'),
                              backgroundColor: Colors.transparent,
                            )
                          : CircleAvatar(
                              radius: 60.0,
                              backgroundImage: NetworkImage(
                                  'http://103.77.166.202' +
                                      mapDemo!['avatar'].toString()),
                              backgroundColor: Colors.transparent,
                            ),
                    )),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            'Xin chào,',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              final SharedPreferences? prefs = await _prefs;
                              await prefs?.setString(
                                  'id', mapDemo!['id'].toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InforPage()));
                            },
                            child: Text(
                              mapDemo == null
                                  ? 'Đang tải dữ liệu'
                                  : mapDemo!['fullname'],
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            )),
                      ],
                    ),
                  ],
                ),
              )),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400))),
                  child: InkWell(
                    splashColor: Colors.blueGrey,
                    onTap: () {
                      Get.to(HomePage());
                    },
                    child: ListTile(
                      leading: const Icon(Icons.my_library_books),
                      title: const Text(
                        'Thư viện sách',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
                  Get.to(AboutPage());
                },
                child: ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text(
                    'Giới thiệu',
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
                  Get.to(ContactPage());
                },
                child: ListTile(
                  leading: const Icon(Icons.contact_page),
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
                  Get.to(TermsPage());
                },
                child: ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text(
                    'Điều khoản sử dụng',
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
                  // SharedPreferences prefs =
                  //     await SharedPreferences.getInstance();
                  // await prefs.remove('accessToken');
                  // Get.offAll(LoginPage());
                  showDialog(
                    context: context,
                    builder: (context) => DialogLogout(),
                  );
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.logout_outlined,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Đăng xuất',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: Text('Phiên bản: 1.0.9')),
            ),
          ),
        ],
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
          Text('Bạn có chắc chắn muốn thoát khỏi ứng dụng?'),
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
            child: Text('Có'),
          ),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () => Navigator.pop(context, 'Không'),
              child: Text(
                'Không',
                style: TextStyle(color: Colors.black),
              )),
        ],
      )),
    );
  }
}

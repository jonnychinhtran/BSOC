import 'package:bsoc_book/controller/infor/infor_controller.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuAside extends StatefulWidget {
  const MenuAside({Key? key}) : super(key: key);

  @override
  State<MenuAside> createState() => _MenuAsideState();
}

class _MenuAsideState extends State<MenuAside> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final InforUserController _inforUser = Get.put(InforUserController());

  @override
  void initState() {
    _inforUser.getInforuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.bookmark_added_outlined),
              title: Text('Thư viện sách'),
            ),
            const ListTile(
              leading: Icon(Icons.assessment_outlined),
              title: Text('Rao vặt'),
            ),
            const ListTile(
              leading: Icon(Icons.contacts_outlined),
              title: Text('Liên hệ'),
            ),
            TextButton(
                onPressed: () async {
                  final SharedPreferences? prefs = await _prefs;
                  prefs?.clear();
                  Get.offAll(LoginPage());
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.only(left: -10))),
                child: const ListTile(
                  leading: Icon(Icons.logout_outlined),
                  title: Text('Đăng xuất'),
                ))
          ],
        ),
      ),
    );
  }
}

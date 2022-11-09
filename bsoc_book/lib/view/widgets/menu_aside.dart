import 'package:bsoc_book/view/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuAside extends StatelessWidget {
  const MenuAside({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: TextButton(
                  onPressed: () async {
                    final SharedPreferences? prefs = await _prefs;
                    prefs?.clear();
                    Get.offAll(LoginPage());
                  },
                  child: const Text(
                    'logout',
                    style: TextStyle(color: Colors.white),
                  ))),
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
        ],
      ),
    );
  }
}

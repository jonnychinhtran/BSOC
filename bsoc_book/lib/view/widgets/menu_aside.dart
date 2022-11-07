import 'package:flutter/material.dart';

class MenuAside extends StatelessWidget {
  const MenuAside({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          DrawerHeader(child: Text('Login/Signup')),
          ListTile(
            leading: Icon(Icons.bookmark_added_outlined),
            title: Text('Thư viện sách'),
          ),
          ListTile(
            leading: Icon(Icons.assessment_outlined),
            title: Text('Rao vặt'),
          ),
          ListTile(
            leading: Icon(Icons.contacts_outlined),
            title: Text('Liên hệ'),
          ),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map? datauser;

class InforPage extends StatefulWidget {
  const InforPage({super.key});

  @override
  State<InforPage> createState() => _InforPageState();
}

class _InforPageState extends State<InforPage> {
  bool isLoading = true;
  String? token;
  Future<void> getUserDetail() async {
    // final dio = Dio();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    print(token);

    var url = Uri.parse('http://103.77.166.202/api/user/infor');
    http.Response response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      // await prefs.setString('token', response.body);
      // print(prefs.getString('token'));
      datauser = jsonDecode(response.body);
      // listReponse = mapDemo!['chapters'];
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load Infor');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 138, 175, 52),
          centerTitle: true,
          title: Text('Cài đặt tài khoản'),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: Text('Thông tin'),
              tiles: [
                SettingsTile(
                  title: Text('Tên đăng nhập:'),
                  value: Text(datauser!['username']),
                ),
                SettingsTile(
                  title: Text('Email:'),
                  value: Text(datauser!['email']),
                ),
                SettingsTile(
                  title: Text('Số điện thoại:'),
                  value: Text('0' + datauser!['phone']),
                ),
              ],
            ),
            SettingsSection(title: Text('Cài đặt chung'), tiles: [
              SettingsTile.navigation(
                title: Text('Đổi mật khẩu'),
                leading: Icon(CupertinoIcons.exclamationmark_shield),
                // description: Text('UI created to show plugin\'s possibilities'),
                onPressed: (context) {},
              ),
              SettingsTile.navigation(
                title: Text('Cập nhật thông tin'),
                leading: Icon(CupertinoIcons.info),
                // description: Text('UI created to show plugin\'s possibilities'),
                onPressed: (context) {},
              ),
              SettingsTile.navigation(
                title: Text(
                  'Đăng xuất',
                  style: TextStyle(color: Colors.red),
                ),
                leading: Icon(
                  CupertinoIcons.clear_circled,
                  color: Colors.red,
                ),
                // description: Text('UI created to show plugin\'s possibilities'),
                onPressed: (context) {},
              ),
            ]),
          ],
        ));
  }
}

// child: Text(datauser.toString())

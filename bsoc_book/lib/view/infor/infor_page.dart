import 'dart:convert';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
                onPressed: (context) async {
                  // SharedPreferences prefs =
                  //     await SharedPreferences.getInstance();
                  // await prefs.remove('accessToken');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePassword()));
                },
              ),
              SettingsTile.navigation(
                title: Text('Cập nhật thông tin'),
                leading: Icon(CupertinoIcons.info),
                // description: Text('UI created to show plugin\'s possibilities'),
                onPressed: (context) async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UpdateUser()));
                },
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
                onPressed: (context) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('accessToken');
                  Get.offAll(LoginPage());
                },
              ),
            ]),
          ],
        ));
  }
}

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 175, 52),
        centerTitle: true,
        title: Text('Đổi mật khẩu'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: SizedBox(
                  width: size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width * 0.85,
                      child: SingleChildScrollView(
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: size.height * 0.04),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0, bottom: 4),
                                child: Text(
                                  'Mật khẩu hiện tại',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              // controller: resetController.emailController,
                              obscureText: true,
                              validator: (value) {
                                return (value == null || value.isEmpty)
                                    ? 'Vui lòng nhập mật khẩu hiện tại'
                                    : null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Mật khẩu hiện tại",
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0, bottom: 4),
                                child: Text(
                                  'Mật khẩu mới',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              // controller: resetController.emailController,
                              obscureText: true,
                              validator: (value) {
                                return (value == null || value.isEmpty)
                                    ? 'Vui lòng nhập mật khẩu hiện tại'
                                    : null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Mật khẩu mới",
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(height: size.height * 0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => {
                                      if (_formKey.currentState!.validate())
                                        {
                                          // resetController.Resetpassword(),
                                        }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 153, 195, 59),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 15)),
                                    child: const Text(
                                      "Cập nhật",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 138, 175, 52),
        centerTitle: true,
        title: Text('Cập nhật thông tin'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: SizedBox(
                  width: size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width * 0.85,
                      child: SingleChildScrollView(
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: size.height * 0.02),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0, bottom: 4),
                                child: Text(
                                  'Tên đăng nhập',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              // controller: registerController.usernameController,
                              validator: (value) {
                                return (value == null || value.isEmpty)
                                    ? 'Vui lòng nhập Username'
                                    : null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Tên đăng nhập",
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(height: size.height * 0.02),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0, bottom: 4),
                                child: Text(
                                  'Email',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              // controller: registerController.emailController,
                              validator: (value) =>
                                  EmailValidator.validate(value!)
                                      ? null
                                      : "Vui lòng nhập email",
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(height: size.height * 0.02),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0, bottom: 4),
                                child: Text(
                                  'Số điện thoại',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              // controller: registerController.phoneController,
                              validator: (value) {
                                return (value == null || value.isEmpty)
                                    ? 'Vui lòng nhập Số điện thoại'
                                    : null;
                              },
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: "Số điện thoại",
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            SizedBox(height: size.height * 0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => {
                                      if (_formKey.currentState!.validate())
                                        {
                                          // resetController.Resetpassword(),
                                        }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromARGB(255, 153, 195, 59),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 15)),
                                    child: const Text(
                                      "Cập nhật",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

import 'package:bsoc_book/controller/changepass/changepass_controller.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/update/update_infor.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
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
    try {
      setState(() {
        isLoading = true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');
      var response = await Dio().get('http://103.77.166.202/api/user/infor',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      if (response.statusCode == 200) {
        datauser = response.data;
        await prefs.setString('username', datauser!['username']);
        await prefs.setString('avatar', datauser!['avatar']);
        // print(datauser);
        setState(() {
          isLoading = false;
        });
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }

  @override
  void initState() {
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
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                ),
              )
            : SettingsList(
                sections: [
                  SettingsSection(
                    title: Text('Thông tin'),
                    tiles: [
                      SettingsTile(
                        title: Text('Họ Tên:'),
                        value: Text(datauser!['fullname']),
                      ),
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
                      title: Text('Cập nhật thông tin'),
                      leading: Icon(CupertinoIcons.info),
                      onPressed: (context) async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UpdateUser()));
                      },
                    ),
                    SettingsTile.navigation(
                      title: Text('Đổi mật khẩu'),
                      leading: Icon(CupertinoIcons.exclamationmark_shield),
                      onPressed: (context) async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChangePassword()));
                      },
                    ),
                    SettingsTile.navigation(
                      title: Text('Xóa tài khoản'),
                      leading: Icon(CupertinoIcons.delete),
                      onPressed: (context) async {
                        showDialog(
                          context: context,
                          builder: (context) => DialogDelete(),
                        );
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
                      onPressed: (context) async {
                        showDialog(
                          context: context,
                          builder: (context) => DialogLogout(),
                        );
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
  ChangepassConntroller changepass = Get.put(ChangepassConntroller());

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
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
                              controller: changepass.currentpasswordController,
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
                              controller: changepass.newpasswordController,
                              obscureText: true,
                              validator: (value) {
                                return (value == null || value.isEmpty)
                                    ? 'Vui lòng nhập mật khẩu mới'
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
                                          changepass.changepassUser(),
                                          Navigator.of(context).pop(),
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

class DialogDelete extends StatefulWidget {
  const DialogDelete({super.key});

  @override
  State<DialogDelete> createState() => _DialogDeleteState();
}

class _DialogDeleteState extends State<DialogDelete> {
  String? token;
  Future<void> deleteUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('accessToken');

      var response = await Dio().post('http://103.77.166.202/api/user/delete',
          options: Options(
              headers: {'accept': '*/*', 'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('accessToken');
        Get.offAll(LoginPage());
      } else {
        Get.snackbar("lỗi", "Xóa tải khoản lỗi. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Thông báo'),
      content: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Bạn có chắc chắn muốn xóa tài khoản này?'),
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
              deleteUser();
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

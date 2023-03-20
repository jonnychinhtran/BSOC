import 'package:bsoc_book/controller/authen/authen_controller.dart';
import 'package:bsoc_book/controller/changepass/changepass_controller.dart';
import 'package:bsoc_book/view/about/about_page.dart';
import 'package:bsoc_book/view/contact/contact_page.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:bsoc_book/view/terms/terms_page.dart';
import 'package:bsoc_book/view/update/update_infor.dart';
import 'package:bsoc_book/view/user/home/home_page.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map? datauser;

class InforPage extends StatefulWidget {
  const InforPage({super.key});

  @override
  State<InforPage> createState() => _InforPageState();
}

class _InforPageState extends State<InforPage> {
  final AuthController authController = Get.find();

  ConnectivityResult connectivity = ConnectivityResult.none;
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
        setState(() {
          isLoading = false;
        });
      } else {
        Get.snackbar("lỗi", "Dữ liệu lỗi. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      // Get.snackbar("error", e.toString());
      print(e);
    }
  }

  Future<void> callback() async {
    if (connectivity == ConnectivityResult.none) {
      isLoading = true;
    } else {
      getUserDetail();
    }
  }

  @override
  void initState() {
    callback();
    getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 138, 175, 52),
          centerTitle: true,
          title: Text('Cài đặt tài khoản'),
        ),
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final connected = connectivity != ConnectivityResult.none;
            return Stack(
              fit: StackFit.expand,
              children: [
                child,
                Positioned(
                  height: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    color: connected
                        ? const Color(0xFF00EE44)
                        : const Color(0xFFEE4400),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: connected
                          ? const Text('ONLINE')
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text('OFFLINE'),
                                SizedBox(width: 8.0),
                                SizedBox(
                                  width: 12.0,
                                  height: 12.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
          child: callback == ConnectivityResult.none
              ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                  color: Color.fromARGB(255, 138, 175, 52),
                  secondRingColor: Colors.black,
                  thirdRingColor: Colors.purple,
                  size: 30,
                ))
              : Obx(() => authController.isLoggedIn.value
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thông tin',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Card(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Mã tài khoản:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    trailing: Text(datauser == null
                                        ? ""
                                        : datauser!['id'].toString()),
                                  ),
                                  Divider(
                                    height: 2,
                                    endIndent: 0,
                                    color: Color.fromARGB(255, 87, 87, 87),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Họ Tên:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    trailing: Text(datauser == null
                                        ? ""
                                        : datauser!['fullname'].toString()),
                                  ),
                                  Divider(
                                    height: 2,
                                    endIndent: 0,
                                    color: Color.fromARGB(255, 87, 87, 87),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Tên đăng nhập:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    trailing: Text(datauser == null
                                        ? ""
                                        : datauser!['username'].toString()),
                                  ),
                                  Divider(
                                    height: 2,
                                    endIndent: 0,
                                    color: Color.fromARGB(255, 87, 87, 87),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Email:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    trailing: Text(datauser == null
                                        ? ""
                                        : datauser!['email'].toString()),
                                  ),
                                  Divider(
                                    height: 2,
                                    endIndent: 0,
                                    color: Color.fromARGB(255, 87, 87, 87),
                                  ),
                                  ListTile(
                                    title: Text(
                                      'Số điện thoại:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    trailing: Text(datauser == null
                                        ? ""
                                        : datauser!['phone'].toString()),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.04),
                            Text(
                              'Cài đặt chung',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Card(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.info),
                                    title: Text(
                                      'Cập nhật thông tin',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    trailing: Icon(Icons.keyboard_arrow_right),
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const UpdateUser()));
                                    },
                                  ),
                                  Divider(
                                    height: 2,
                                    endIndent: 0,
                                    color: Color.fromARGB(255, 87, 87, 87),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.shield),
                                    title: Text(
                                      'Đổi mật khẩu',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    trailing: Icon(Icons.keyboard_arrow_right),
                                    onTap: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ChangePassword()));
                                    },
                                  ),
                                  Divider(
                                    height: 2,
                                    endIndent: 0,
                                    color: Color.fromARGB(255, 87, 87, 87),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text(
                                      'Xóa tài khoản',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    trailing: Icon(Icons.keyboard_arrow_right),
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) => DialogDelete(),
                                      );
                                    },
                                  ),
                                  Divider(
                                    height: 2,
                                    endIndent: 0,
                                    color: Color.fromARGB(255, 87, 87, 87),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade400))),
                                    child: ListTile(
                                      title: Text('Giới thiệu'),
                                      trailing: Icon(Icons.arrow_right),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AboutPage()),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade400))),
                                    child: ListTile(
                                      title: Text('Liên hệ'),
                                      trailing: Icon(Icons.arrow_right),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ContactPage()),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: ListTile(
                                      title: Text('Điều khoản sử dụng'),
                                      trailing: Icon(Icons.arrow_right),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TermsPage()),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Center(
                              child: Text(
                                '1.0.11',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => DialogLogout(),
                                  );
                                },
                                child: Text(
                                  'Đăng xuất',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  minimumSize: Size(double.infinity, 50),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 50, bottom: 50, left: 16, right: 16),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                child: Text(
                                  'Bạn cần đăng nhập hoặc đăng ký để xem thông tin tài khoản.',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: size.height * 0.02),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Text(
                                    'Đăng nhập/đăng ký',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade400))),
                          child: ListTile(
                            title: Text('Giới thiệu'),
                            trailing: Icon(Icons.arrow_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutPage()),
                              );
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade400))),
                          child: ListTile(
                            title: Text('Liên hệ'),
                            trailing: Icon(Icons.arrow_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactPage()),
                              );
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: ListTile(
                            title: Text('Điều khoản sử dụng'),
                            trailing: Icon(Icons.arrow_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TermsPage()),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Center(
                          child: Text(
                            '1.0.12',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    )),
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
  final AuthController authController = Get.put(AuthController());
  final box = GetStorage();

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
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              // await prefs.remove('accessToken');
              // await prefs.clear();
              // box.write('isLoggedIn', false);
              authController.logout();
              Get.offAll(HomePage());
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

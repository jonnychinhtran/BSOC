import 'package:bsoc_book/view/infor/infor_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();
  // UpdateUserConntroller updateuser = Get.put(UpdateUserConntroller());
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? token;
  String? idUser;
  String? username;
  String? emailUser;
  String? phoneUser;
  String? avatar;
  Future<void> updateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');
    idUser = prefs.getString('idInforUser');
    username = prefs.getString('username');
    emailUser = prefs.getString('emailuser');
    phoneUser = prefs.getString('phoneUser');
    // int value1 = int.parse(phoneController.text);

    var formData = FormData.fromMap(
      {
        "userId": idUser.toString(),
        "fullname": fullnameController.text,
        "username": username,
        "email": emailController.text,
        "phone": phoneController.text,
      },
    );

    var response = await Dio().post('http://103.77.166.202/api/user/update',
        data: formData,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }));
    print(response.toString());
    print(response.data);
    if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const InforPage()));
      Navigator.of(context).pop();
      fullnameController.clear();
      emailController.clear();
      phoneController.clear();
    }
  }

  @override
  void initState() {
    InternetPopup().initialize(context: context);
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
                          children: <Widget>[
                            SizedBox(height: size.height * 0.02),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 0, bottom: 4),
                                child: Text(
                                  'Họ và Tên',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: fullnameController,
                              validator: (value) {
                                return (value == null || value.isEmpty)
                                    ? 'Vui lòng nhập lại họ tên'
                                    : null;
                              },
                              decoration: InputDecoration(
                                  hintText: datauser!['fullname'].toString(),
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
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Vui lòng nhập email';
                                }
                                if (!RegExp(
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                    .hasMatch(value)) {
                                  return 'Nhập sai định dạng email';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r" "))
                              ],
                              decoration: InputDecoration(
                                  hintText: datauser!['email'].toString(),
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
                              controller: phoneController,
                              validator: (value) {
                                if (value == "") {
                                  return null;
                                }
                                if (value!.isEmpty) {
                                  return 'Vui lòng nhập Số điện thoại';
                                }
                                return null;
                              },
                              // maxLength: 20,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: datauser!['phone'].toString(),
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
                                          updateUser(),
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

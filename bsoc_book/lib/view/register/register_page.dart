import 'package:bsoc_book/controller/register/register_controller.dart';
import 'package:bsoc_book/view/login/login_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  RegisterationController registerController =
      Get.put(RegisterationController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
          key: _formKey,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: size.width * 0.85,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                          child: Image.asset(
                              'assets/images/logo-b4usolution.png')),
                      SizedBox(height: size.height * 0.02),
                      const Center(
                        child: Text(
                          "ĐĂNG KÝ TÀI KHOẢN",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0, bottom: 4),
                          child: Text(
                            'Tên đăng nhập (*)',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: registerController.usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tên đăng nhập';
                          } else if (value.length < 3) {
                            return 'Tên đăng nhập phải có ít nhất 3 ký tự trở lên';
                          } else if (!RegExp(r'^[a-zA-Z0-9_]+$')
                              .hasMatch(value)) {
                            return 'Tên đăng nhập chỉ được chứa ký tự a-z, A-Z, 0-9 hoặc _';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Tên đăng nhập",
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-z0-9]")),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 0, bottom: 4),
                          child: Text(
                            'Email (*)',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: registerController.emailController,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        controller: registerController.phoneController,
                        validator: (value) {
                          // return (value == null || value.isEmpty)
                          //     ? 'Vui lòng nhập Số điện thoại'
                          //     : null;
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
                            hintText: "Số điện thoại",
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
                            'Mật khẩu (*)',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: registerController.passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          } else if (value.length < 6) {
                            return 'Mật khẩu phải có ít nhất 6 ký tự';
                          } else if (!RegExp(
                                  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$')
                              .hasMatch(value)) {
                            // return 'Mật khẩu phải chứa ít nhất một chữ cái viết hoa và một chữ cái thường (Aa-Zz), một ký hiệu đặc biệt (#, &, % v.v.), và một số (0-9)';
                            return 'Mật khẩu phải có (Aa-Zz), (#, &, @...) và (0-9)';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Mật khẩu",
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
                                    registerController.registerWithUser(),
                                  },
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 153, 195, 59),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15)),
                              child: const Text(
                                "Đăng ký",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Bạn đã có tài khoản?",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.off(LoginPage());
                            },
                            child: const Text("Vui lòng đăng nhập"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

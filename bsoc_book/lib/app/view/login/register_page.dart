import 'package:bsoc_book/app/view/login/components/success_register_page.dart';
import 'package:bsoc_book/app/view_model/login_view_model.dart';
import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/config/routes.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late LoginViewModel _loginViewModel;
  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void goHome() {
    Application.router
        .navigateTo(context, Routes.appRouteLogin, clearStack: true);
  }

  @override
  void initState() {
    _loginViewModel = LoginViewModel();
    super.initState();
  }

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
                        'assets/images/logo-b4usolution.png',
                        height: MediaQuery.of(context).viewInsets.bottom == 0
                            ? size.height * 0.08
                            : size.height * 0.04,
                      )),
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
                        controller: _usernameController,
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
                        controller: _emailController,
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
                        controller: _phoneController,
                        validator: (value) {
                          if (value == "") {
                            return null;
                          }
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập Số điện thoại';
                          }
                          return null;
                        },
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
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          } else if (value.length < 6) {
                            return 'Mật khẩu phải có ít nhất 6 ký tự';
                          }
                          // else if (!RegExp(
                          //         r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$')
                          //     .hasMatch(value)) {
                          //   return 'Mật khẩu phải có (Aa-Zz), (#, &, @...) và (0-9)';
                          // }
                          else {
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
                                setState(() {
                                  _isLoading = true;
                                }),
                                if (_formKey.currentState!.validate())
                                  {
                                    _loginViewModel
                                        .registerUser(
                                            username: _usernameController.text,
                                            email: _emailController.text,
                                            phone: _phoneController.text,
                                            password: _passwordController.text)
                                        .then((value) {
                                      print(value);
                                      if (value!.statusCode == 200) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SuccessRegisterPage()));
                                      } else if (value.data ==
                                          'Error: Username is already taken!') {
                                        WidgetHelper.showMessageError(
                                            context: context,
                                            content:
                                                'Tên người dùng đã được sử dụng!');
                                      } else if (value.data ==
                                          'Error: Email is already in use!') {
                                        WidgetHelper.showMessageError(
                                            context: context,
                                            content: 'Email đã được sử dụng!');
                                      } else {
                                        WidgetHelper.showMessageError(
                                            context: context,
                                            content:
                                                'Đăng ký thất bại. Thử lại.');
                                      }
                                    })
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
                              goHome();
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

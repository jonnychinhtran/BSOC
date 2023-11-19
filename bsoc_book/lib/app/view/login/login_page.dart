import 'package:bsoc_book/app/view_model/login_view_model.dart';
import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/config/routes.dart';
import 'package:bsoc_book/app/view/login/register_page.dart';
import 'package:bsoc_book/app/view/login/reset_pass_page.dart';
import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = false;
  late LoginViewModel _loginViewModel;
  bool state = false;

  void goHome() {
    Application.router.navigateTo(context, Routes.app, clearStack: true);
  }

  @override
  void initState() {
    _loginViewModel = LoginViewModel();
    _isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0, // Remove shadow
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            goHome();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Stack(
              children: [
                Form(
                    key: _formKey,
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                              child: Image.asset(
                            'assets/images/logo-b4usolution.png',
                            height:
                                MediaQuery.of(context).viewInsets.bottom == 0
                                    ? size.height * 0.08
                                    : size.height * 0.04,
                          )),
                          SizedBox(height: size.height * 0.02),
                          const Center(
                            child: Text(
                              "ĐĂNG NHẬP",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.04),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 34.0, right: 34.0, bottom: 8.0),
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
                          Container(
                            padding:
                                const EdgeInsets.only(left: 34.0, right: 34.0),
                            child: TextFormField(
                              controller: _usernameController,
                              validator: (value) {
                                return (value == null || value.isEmpty)
                                    ? 'Vui lòng nhập tên đăng nhập'
                                    : null;
                              },
                              decoration: InputDecoration(
                                  hintText: "Tên đăng nhập",
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-z0-9]")),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 34.0, right: 34.0, bottom: 8.0),
                              child: Text(
                                'Mật khẩu',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 34.0, right: 34.0),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: !_obscureText,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Vui lòng nhập mật khẩu";
                                } else if (value.length < 6) {
                                  return "Mật khẩu phải chứa tối thiểu 6 ký tự";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Mật khẩu",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(
                                    (_obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    color: AppColors.PRIMARY_COLOR,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 34.0, right: 34.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ResetPassPage()),
                                    );
                                  },
                                  child: const Text(
                                    "Quên mật khẩu",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.only(left: 34.0, right: 34.0),
                            child: ElevatedButton(
                              onPressed: () => {
                                if (_formKey.currentState!.validate())
                                  {
                                    setState(() {
                                      _isLoading = true;
                                    }),
                                    _loginViewModel
                                        .login(
                                            username: _usernameController.text,
                                            password: _passwordController.text)
                                        .then((bool value) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      if (true == value) {
                                        _loginViewModel.loadAppData();

                                        Application.router.navigateTo(
                                            context, Routes.app,
                                            clearStack: true);
                                      } else {
                                        WidgetHelper.showMessageError(
                                          context: context,
                                          content:
                                              "Vui lòng nhập tên đăng nhập và mật khẩu",
                                        );
                                      }
                                    })
                                  }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 153, 195, 59),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15)),
                              child: const Text(
                                "Đăng nhập",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Bạn chưa có tài khoản?",
                                style: TextStyle(color: Colors.black),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterPage()),
                                  );
                                },
                                child: const Text("Đăng ký ngay"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                (true == _isLoading)
                    ? Center(
                        child: LoadingAnimationWidget.discreteCircle(
                        color: AppColors.PRIMARY_COLOR,
                        secondRingColor: Colors.black,
                        thirdRingColor: Colors.purple,
                        size: 30,
                      ))
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

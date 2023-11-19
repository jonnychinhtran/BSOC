import 'package:bsoc_book/app/view/login/components/success_resetpass_page.dart';
import 'package:bsoc_book/app/view/login/login_page.dart';
import 'package:bsoc_book/app/view_model/login_view_model.dart';
import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/config/routes.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetPassPage extends StatefulWidget {
  const ResetPassPage({super.key});

  @override
  State<ResetPassPage> createState() => _ResetPassPageState();
}

class _ResetPassPageState extends State<ResetPassPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  late LoginViewModel _loginViewModel;
  bool _isLoading = false;

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
      body: SafeArea(
        child: Form(
            key: _formKey,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.85,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                            "QUÊN MẬT KHẨU",
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
                            padding: EdgeInsets.only(left: 0, bottom: 4),
                            child: Text(
                              'Email đăng ký',
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
                        SizedBox(height: size.height * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => {
                                  if (_formKey.currentState!.validate())
                                    {
                                      setState(() {
                                        _isLoading = true;
                                      }),
                                      if (_formKey.currentState!.validate())
                                        {
                                          _loginViewModel
                                              .resetPassword(
                                            email: _emailController.text,
                                          )
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
                                                          const SuccessResetPassPage()));
                                            } else {
                                              WidgetHelper.showMessageError(
                                                  context: context,
                                                  content:
                                                      'Email không tồn tại. Thử lại.');
                                            }
                                          })
                                        },
                                    }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 153, 195, 59),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 15)),
                                child: const Text(
                                  "Gửi email xác thực",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => {goHome()},
                                style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 59, 118, 195),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 10)),
                                child: const Text(
                                  "Hủy",
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
      ),
    );
  }
}
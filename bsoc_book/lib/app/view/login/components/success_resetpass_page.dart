import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/config/routes.dart';
import 'package:bsoc_book/widgets/default_button.dart';
import 'package:flutter/material.dart';

class SuccessResetPassPage extends StatefulWidget {
  const SuccessResetPassPage({super.key});

  @override
  State<SuccessResetPassPage> createState() => _SuccessResetPassPageState();
}

class _SuccessResetPassPageState extends State<SuccessResetPassPage> {
  void goLogin() {
    Application.router
        .navigateTo(context, Routes.appRouteLogin, clearStack: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/icon/success.png',
                  width: 110,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Lấy lại mật khẩu thành công",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Chúc mừng bạn đã lấy lại mật khẩu thành công",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Vui lòng kiểm tra email để nhận mật khẩu mới",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 15),
              DefaultButton(
                  title: 'Đăng Nhập Ngay',
                  onPress: () {
                    goLogin();
                  })
            ],
          ),
        ),
      ),
    );
  }
}

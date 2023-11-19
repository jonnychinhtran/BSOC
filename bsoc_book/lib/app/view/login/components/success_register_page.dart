import 'package:bsoc_book/config/application.dart';
import 'package:bsoc_book/config/routes.dart';
import 'package:bsoc_book/widgets/default_button.dart';
import 'package:flutter/material.dart';

class SuccessRegisterPage extends StatefulWidget {
  const SuccessRegisterPage({super.key});

  @override
  State<SuccessRegisterPage> createState() => _SuccessRegisterPageState();
}

class _SuccessRegisterPageState extends State<SuccessRegisterPage> {
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
                "Đăng ký thành công",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Chúc mừng bạn đã đăng ký thành công",
                style: TextStyle(
                  fontSize: 16,
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

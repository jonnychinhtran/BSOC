import 'dart:convert';
import 'package:bsoc_book/routes/app_routes.dart';
import 'package:bsoc_book/view/login/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterationController extends GetxController {
  TextEditingController fullnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> registerWithUser() async {
    int value1 = int.parse(phoneController.text);
    final formData = {
      "username": usernameController.text,
      "email": emailController.text,
      "phone": value1,
      "password": passwordController.text,
    };

    try {
      Dio().options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
      var response = await Dio().post('http://103.77.166.202/api/auth/register',
          data: json.encode(formData));
      if (response.statusCode == 200) {
        final jsondata = response.data;
        print(jsondata);
        Get.snackbar("Thành công", "Đăng ký thành công.");
        usernameController.clear();
        emailController.clear();
        passwordController.clear();
        phoneController.clear();
        Get.to(LoginPage());
      } else {
        Get.snackbar("Lỗi", "Đăng ký thất bại. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      // Get.snackbar("Lỗi đăng ký", e['message']);
      Get.snackbar("Lỗi đăng ký",
          "Vui lòng kiểm tra lại thiếu thông tin hoặc trùng tên");
      print(e);
    }
  }
}

import 'package:bsoc_book/view/infor/infor_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUserConntroller extends GetxController {
  String? token;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future<void> updateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('accessToken');

    final formData = {
      "username": usernameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
    };

    try {
      var response = await Dio().post('http://103.77.166.202/api/user/update',
          data: formData,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }));
      print(response);
      if (response.statusCode == 200) {
        Get.snackbar("Thành công", "Thay đổi thành công.");
        usernameController.clear();
        emailController.clear();
        phoneController.clear();
        Get.to(InforPage());
      } else {
        Get.snackbar("Lỗi", "Thay đổi thất bại. Thử lại.");
      }
      print("res: ${response.data}");
    } catch (e) {
      Get.snackbar("error", e.toString());
      print(e);
    }
  }
}
